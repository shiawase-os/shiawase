#pragma once
#include <stdint.h>

// passed by the bootloader in EAX
#define MULTIBOOT1_BOOTLOADER_MAGIC 0x2BADB002u
#define MULTIBOOT2_BOOTLOADER_MAGIC 0x36D76289u

// multiboot 1 boot information structure

// BIF -> BOOT INFO FLAG
#define MB1_BIF_MEM             (1 << 0)
#define MB1_BIF_BOOT_DEV        (1 << 1) // see the mb1 boot device flags
#define MB1_BIF_CMDLINE         (1 << 2) // if the struct contains the address to a kernel commandline
#define MB1_BIF_MODULES         (1 << 3) // see the mb1 modules section below
#define MB1_BIF_SYMS_AOUT       (1 << 4) // for both SMYS_AOUT and SYMS_ELF see mb1 syms section below
#define MB1_BIF_SYMS_ELF        (1 << 5) // bits 4 and 5 are mutually exclusive
#define MB1_BIF_MEMMAP          (1 << 6) // see mb1 memmap section below
#define MB1_BIF_DRIVES          (1 << 7) // see mb1 drives section below
#define MB1_BIF_CONFIG_TABLE    (1 << 8) // address returned by the `GET CONFIGURATION` BIOS call
#define MB1_BIF_BOOTLOADER_NAME (1 << 9) // if the struct contains a bootloader name
#define MB1_BIF_APM_TABLE       (1 << 10)
#define MB1_BIF_VBE_TABLE       (1 << 11) // defines if the VBE fields in the boot_info struct are available
#define MB1_BIF_FRAMEBUFFER     (1 << 12) // see mb1_framebuffer section below

struct mb1_boot_info {
    // flags
    uint32_t flags;

    // memory info
    uint32_t mem_lower; // amount of "lower memory" (starting at 0), in kilobytes, maximum is 640 kbs
    uint32_t mem_upper; // amount of "higher memory" (starting at 1 megabyte), in kilobytes, maximally the address of the first upper memory hole - 1 megabyte, not guaranteed

    // boot device
    // contains the BIOS disk device the os was loaded from,
    // +-------+-------+-------+-------+
    // | part3 | part2 | part1 | drive |
    // +-------+-------+-------+-------+
    // LSB                            MSB
    // the most significant byte contains the BIOS drive number as understood by INT 0x13, e.g. 0x00 for floppy 1, 0x80 for hard drive 1
    // three remaining bytes specify the partition, it supports multi level stuff, if its the final level the remaining levels will contain 0xFF
    uint32_t boot_device;

    // contains the physical address of the kernel commandline, C-style null terminated string
    uint32_t cmdline_address;

    // modules stuff
    uint32_t module_count;
    uint32_t module_list_address; // physical address of list of mb1 modules

    // mb1 symbols, it can be a standard a.out symbol file or ELF specifc stuff, for that look at bits 4 & 5, they are mutually exclusive
    // bit 4 means that there is a a.out symbol file
    // bit 5 means taht there is an ELF section header table address
    union {
        struct {
            uint32_t tabsize;
            uint32_t strsize;
            uint32_t addr;
            uint32_t reserved;
        } __attribute__((packed)) aout;

        struct {
            uint32_t num;
            uint32_t size;
            uint32_t addr;
            uint32_t shndx;
        } __attribute__((packed)) elf;
    } __attribute__((packed)) syms;

    // mb1 memmap
    // just look at the memory map stuff below to get info :P
    uint32_t memmap_length; // total length of the memmap entry list
    uint32_t memmap_addr; // physical address of the memmap entry list

    // mb1 drives array
    uint32_t drives_length; // length of the drive array at drives_addr in bytes
    uint32_t drives_addr; // physical address of the drives array, see drives section below

    // bios config table
    uint32_t config_table; // physical address of the bios config table

    // boot loader name
    uint32_t boot_loader_name; // physical address of a C-style, null termianted string containing the boot loader name

    // apm table
    uint32_t apm_table; // physical address to the APM table strucutre defined below

    // VBE schenanigans
    uint32_t vbe_control_info;
    uint32_t vbe_mode_info;
    uint16_t vbe_mode;
    uint16_t vbe_interface_seg;
    uint16_t vbe_interface_off;
    uint16_t vbe_interface_len;

    // framebuffer stuff
    uint64_t framebuffer_address;
    uint32_t framebuffer_pitch;
    uint32_t framebuffer_width;
    uint32_t framebuffer_height;
    uint8_t framebuffer_bpp;
    uint8_t framebuffer_type;

    // framebuffer color info, this depends on the framebuffer_type
    union {

        // framebuffer type 0 -> indexed
        struct {
            uint32_t palette_addr; // physical address of an array of color descriptors
            uint16_t palette_num_colors; // amount of color descriptors found at the address
            // to see how these color descriptors look like, look below
        } __attribute__((packed)) indexed;

        // framebuffer type 1 -> direct RGB color
        struct {
            // standard framebuffer mask stuff
            uint8_t red_field_position;
            uint8_t red_mask_size;
            uint8_t green_field_position;
            uint8_t green_mask_size;
            uint8_t blue_field_position;
            uint8_t blue_mask_size;
        } __attribute__((packed)) rgb;
    } __attribute__((packed)) framebuffer_color_info;
} __attribute__((packed));

// multiboot 1 memory map

struct mb1_mmap_entry {
    uint32_t size;
    uint64_t addr;
    uint64_t len;
    uint32_t type;
} __attribute__((packed));

#define MB1_MMAP_TYPE_AVAILABLE         1
#define MB1_MMAP_TYPE_RESERVED          2
#define MB1_MMAP_TYPE_ACPI_RECLAIMABLE  3
#define MB1_MMAP_TYPE_ACPI_NVS          4
#define MB1_MMAP_TYPE_FAULTY            5
