#include "boot/bpb.h"
#include "log/log.h"
#include "sinks/e9.h"
#include "util/executil.h"
#include <stddef.h>
#include <stdint.h>

#include <io/port.h>
#include <boot/multiboot.h>
#include <string.h>

extern uint8_t __bss_start[];
extern uint8_t __bss_end[];

extern void kmain(struct boot_parameter_block *bpb);

static void *allocate_memory_from_mb1_mmap(struct mb1_boot_info *mbi, size_t size) {
    size = (size + 0xFFF) & ~0xFFF;

    uint8_t *mmap_ptr = (uint8_t *)(uintptr_t)mbi->memmap_addr;
    uint8_t *mmap_end = mmap_ptr + mbi->memmap_length;

    while (mmap_ptr < mmap_end) {
        struct mb1_mmap_entry *entry = (struct mb1_mmap_entry *)mmap_ptr;

        if (entry->type == MB1_MMAP_TYPE_AVAILABLE && entry->len >= size) {
            if (entry->addr < 0x1000) { // cheeky fix because 0x0-0x1000 can be a valid region but that messes with !ptr checks
                mmap_ptr += entry->size + sizeof(entry->size);
                continue;
            }

            void *old_base = (void *)entry->addr;
            entry->addr += size;
            entry->len -= size;
            return old_base;
        }

        mmap_ptr += entry->size + sizeof(entry->size);
    }

    kerr("Failed to allocate %lld bytes from multiboot 1 memory map!\n", size);
    return NULL;
}

void _cmain(uint32_t magic, uintptr_t boot_info_phys) {
    __amd64_clear_bss((uintptr_t)__bss_start, __bss_end - __bss_start);
    __amd64_register_e9_sink();

    if (magic == MULTIBOOT1_BOOTLOADER_MAGIC) {
        struct mb1_boot_info bi;
        memcpy(&bi, (void*)boot_info_phys, sizeof(bi));

        uint64_t bpb_total_size = 0x0;
        bpb_total_size += sizeof(struct boot_parameter_block);

        uint64_t mmap_count;
        uint64_t module_count;
        uint64_t memmap_count;
        uint64_t framebuffer_count;

        if (bi.flags & MB1_BIF_FRAMEBUFFER) {
            bpb_total_size += sizeof(struct bpb_framebuffer);
            framebuffer_count++;
        } else {
            kwarn("No multiboot framebuffer provided!\n");
        }

        if (bi.flags & MB1_BIF_MODULES) {
            bpb_total_size += sizeof(struct bpb_module) * bi.module_count;
            module_count = bi.module_count;
        } else {
            kwarn("No multiboot modules provided!\n");
        }

        if (bi.flags & MB1_BIF_MEMMAP) {
            memmap_count = bi.memmap_length / sizeof(struct mb1_mmap_entry);
            bpb_total_size += sizeof(struct bpb_memmap_entry) * memmap_count;
        } else {
            kwarn("No multiboot framebuffer provided!\n");
        }

        bpb_total_size += sizeof("amd64");
        bpb_total_size += sizeof("multiboot1");

        void *bpb_memory_area = allocate_memory_from_mb1_mmap(&bi, bpb_total_size);
        void *bpb_pointer = bpb_memory_area;
        void *bpb_framebuffer_area = bpb_memory_area + sizeof(struct boot_parameter_block);
        void *bpb_modules_area = bpb_framebuffer_area + sizeof(struct bpb_framebuffer) * framebuffer_count;
        void *bpb_memmap_area = bpb_modules_area + sizeof(struct bpb_module) * module_count;
        void *bpb_other_area = bpb_memmap_area + sizeof(struct bpb_memmap_entry) * memmap_count; // contains string and stuff

        // copy the strings
        memcpy(bpb_other_area, "amd64", sizeof("amd64"));
        char *bpb_arch_string = bpb_other_area;
        bpb_other_area += sizeof("amd64");
        memcpy(bpb_other_area, "multiboot1", sizeof("multiboot1"));
        char* bpb_proto_string = bpb_other_area;

        // construct the bpb
        struct boot_parameter_block *bpb = (struct boot_parameter_block *)bpb_pointer;
        memcpy(bpb->magic, BPB_MAGIC, 3);
        bpb->version = BPB_VERSION;
        bpb->arch = bpb_arch_string;
        bpb->protocol = bpb_proto_string;
        bpb->loader = (void *)(uintptr_t)bi.boot_loader_name;
        bpb->cmdline = (void *)(uintptr_t)bi.cmdline_address;
        bpb->hhdm_offset = 0xffff000000000000; // guh, i dont like this but it is how it is
        bpb->fb_count = framebuffer_count;
        bpb->fbs = bpb_framebuffer_area; // i hope this works
        bpb->mmap_entry_count = memmap_count;
        bpb->mmap_entries = bpb_memmap_area;
        bpb->module_count = module_count;
        bpb->modules = bpb_modules_area;

        uint8_t *mb1_mmap_ptr = (uint8_t *)(uintptr_t)bi.memmap_addr;
        uint8_t *mb1_mmap_end = mb1_mmap_ptr + bi.memmap_length;
        void *bpb_mmap_pointer = bpb_memmap_area;
        while (mb1_mmap_ptr < mb1_mmap_end) {
            struct mb1_mmap_entry *entry = (struct mb1_mmap_entry *)mb1_mmap_ptr;
            struct bpb_memmap_entry *bme = (struct bpb_memmap_entry *)bpb_mmap_pointer;

            bme->len = entry->len;
            bme->start = entry->addr;

            switch (entry->type) {
            case MB1_MMAP_TYPE_AVAILABLE:
                bme->type = BPB_MEMMAP_USABLE;
                break;
            case MB1_MMAP_TYPE_RESERVED:
                bme->type = BPB_MEMMAP_RESERVED;
                break;
            case MB1_MMAP_TYPE_ACPI_RECLAIMABLE:
                bme->type = BPB_MEMMAP_ACPI_RECLAIMABLE;
                break;
            case MB1_MMAP_TYPE_ACPI_NVS:
                bme->type = BPB_MEMMAP_ACPI_NVS;
                break;
            case MB1_MMAP_TYPE_FAULTY:
                bme->type = BPB_MEMMAP_FAULTY;
                break;
            default:
                kwarn("Invalid multiboot memory map entry (unknown type %d)!\n", entry->type);
                bme->type = BPB_MEMMAP_FAULTY;
                bpb_mmap_pointer += sizeof(struct bpb_memmap_entry);
                mb1_mmap_ptr += entry->size + sizeof(entry->size);
                continue;
            }

            bpb_mmap_pointer += sizeof(struct bpb_memmap_entry);
            mb1_mmap_ptr += entry->size + sizeof(entry->size);
        }

        kmain(bpb);

        kerr("Failed to run kmain(...)!\n");
        for (;;) {
            __asm__ volatile ("cli; hlt");
        }
    } else {
        kerr("Multiboot 2 not supported!\n");
        for (;;) {
            __asm__ volatile ("cli; hlt");
        }
    }

    for (;;)
        __asm__ volatile ("cli; hlt");
}
