// despite popular belief this is actually not a header for the Bundeszentrale für Politische Bildung
// but rather for the boot parameter block, which is a standardized way of passing boot info the kmain
// no matter the boot protocol
#pragma once
#include <stdint.h>

// magic
#define BPB_MAGIC "BPB"
#define BPB_VERSION 0x1

struct bpb_framebuffer {
    void *address;
    uint64_t width;
    uint64_t height;
    uint64_t pitch;
    uint16_t bpp;

    uint8_t red_mask_size;
    uint8_t red_mask_shift;
    uint8_t green_mask_size;
    uint8_t green_mask_shift;
    uint8_t blue_mask_size;
    uint8_t blue_mask_shift;
};

#define BPB_MEMMAP_RESERVED         0
#define BPB_MEMMAP_USABLE           1
#define BPB_MEMMAP_ACPI_RECLAIMABLE 2
#define BPB_MEMMAP_ACPI_NVS         3
#define BPB_MEMMAP_FAULTY           4

struct bpb_memmap_entry {
    uint64_t start;
    uint64_t len;
    uint64_t type;
};

struct bpb_module {
    uint64_t address;
    uint64_t size;
    char *string;
};

struct boot_parameter_block {
    char magic[3];
    uint8_t version;
    char *arch;
    char *protocol;
    char *loader;
    char *cmdline;
    uint64_t hhdm_offset;
    uint64_t fb_count;
    struct bpb_framebuffer *fbs;
    uint64_t mmap_entry_count;
    struct bpb_memmap_entry *mmap_entries;
    uint64_t module_count;
    struct bpb_module *modules;
};
