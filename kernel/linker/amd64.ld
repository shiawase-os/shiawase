OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)

ENTRY(_start)

KERNEL_VIRT_BASE = 0xffffffff80000000;
KERNEL_PHYS_BASE = 0x00200000;

PHDRS {
    boot   PT_LOAD FLAGS(0x5);
    text   PT_LOAD FLAGS(0x5);
    rodata PT_LOAD FLAGS(0x4);
    data   PT_LOAD FLAGS(0x6);
}

SECTIONS
{
    . = KERNEL_PHYS_BASE;
    __kernel_phys_start = .;

    .boot ALIGN(0x1000) : {
        __boot_start = .;
        KEEP(*(.multiboot1))
        KEEP(*(.multiboot2))
        *(.boot_text)
        *(.boot_rodata)
        *(.boot_bss)
        __boot_end = .;
    } :boot

    . = KERNEL_VIRT_BASE + (__boot_end - KERNEL_PHYS_BASE);
    . = ALIGN(CONSTANT(MAXPAGESIZE));
    __kernel_start = .;

    .text : AT(ADDR(.text) - KERNEL_VIRT_BASE + KERNEL_PHYS_BASE) {
        __text_start = .;
        *(.text)
        *(.text.*)
        __text_end = .;
    } :text

    . = ALIGN(CONSTANT(MAXPAGESIZE));

    .rodata : AT(ADDR(.rodata) - KERNEL_VIRT_BASE + KERNEL_PHYS_BASE) {
        __rodata_start = .;
        *(.rodata)
        *(.rodata.*)
        *(.note.gnu.build-id)
        __rodata_end = .;
    } :rodata

    . = ALIGN(CONSTANT(MAXPAGESIZE));

    .data : AT(ADDR(.data) - KERNEL_VIRT_BASE + KERNEL_PHYS_BASE) {
        __data_start = .;
        *(.data)
        *(.data.*)
        __data_end = .;
    } :data

    .bss : AT(ADDR(.bss) - KERNEL_VIRT_BASE + KERNEL_PHYS_BASE) {
        . = ALIGN(0x1000);

        __bss_start = .;
        *(COMMON)
        *(.bss)
        *(.bss.*)
        __bss_end = .;
    } :data

    __kernel_end = .;
    __kernel_phys_end = __kernel_end - KERNEL_VIRT_BASE + KERNEL_PHYS_BASE;
    __kernel_bss_end = __bss_end - KERNEL_VIRT_BASE + KERNEL_PHYS_BASE;

    /DISCARD/ : {
        *(.eh_frame*)
        *(.comment*)
        *(.note.GNU-stack)
        *(.got*)
        *(.got.plt*)
    }
}
