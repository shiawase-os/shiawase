#include "log/log.h"
#include <boot/bpb.h>

void kmain(struct boot_parameter_block *bpb) {
    kinfo("Hello world from architecture-independant, bootloader-independant kmain!\n");
    kinfo("BPB located at %p:\n", bpb);
    kinfo("- Architecture: %s\n", bpb->arch);
    kinfo("- Boot Protocol: %s\n", bpb->protocol);
    kinfo("- Bootloader: %s\n", bpb->loader);
    kinfo("- HHDM Offset: 0x%llx\n", bpb->hhdm_offset);

    kinfo("BPB memory map (%lld entries):\n", bpb->mmap_entry_count, bpb->mmap_entries);
    for (uint64_t i = 0; i < bpb->mmap_entry_count; i++) {
        struct bpb_memmap_entry *entry = &bpb->mmap_entries[i];

        kinfo("  #%llu %016llx - %016llx (%llx) [%llu]\n",
              (unsigned long long)i,
              (unsigned long long)entry->start,
              (unsigned long long)(entry->start + entry->len),
              (unsigned long long)entry->len,
              (unsigned long long)entry->type);
    }

    for (;;)
        ;
}
