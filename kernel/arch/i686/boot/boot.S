.extern __kernel_phys_start
.extern __kernel_phys_end
.extern __kernel_bss_end

.set KERNEL_VIRT_BASE, 0xC0100000
.set KERNEL_PHYS_BASE, 0x00100000


.section .multiboot1, "a", @progbits

.set MB1_ALIGN,       (1 << 0)
.set MB1_MEMORY_INFO, (1 << 1)
.set MB1_AOUT_KLUDGE, (1 << 16)

.set MB1_FLAGS,    (MB1_ALIGN | MB1_MEMORY_INFO | MB1_AOUT_KLUDGE)
.set MB1_MAGIC,    0x1BADB002
.set MB1_CHECKSUM, -(MB1_MAGIC + MB1_FLAGS)

.align 4

multiboot_header:
    .long MB1_MAGIC
    .long MB1_FLAGS
    .long MB1_CHECKSUM

    .long multiboot_header
    .long __kernel_phys_start
    .long __kernel_phys_end
    .long __kernel_bss_end
    .long _start

.section .multiboot2, "a", @progbits

.set MB2_MAGIC,    0xE85250D6
.set MB2_ARCH,     0
.set MB2_LENGTH,   (multiboot2_header_end - multiboot2_header)
.set MB2_CHECKSUM, -(MB2_MAGIC + MB2_ARCH + MB2_LENGTH)

.set MB2_TAG_END,   0
.set MB2_TAG_ENTRY, 3
.set MB2_TAG_ALIGN, 6

.align 8

multiboot2_header:
    .long MB2_MAGIC
    .long MB2_ARCH
    .long MB2_LENGTH
    .long MB2_CHECKSUM

.align 8

multiboot2_entry_tag:
    .short MB2_TAG_ENTRY
    .short 0
    .long 12
    .long _start

.align 8

multiboot2_align_tag:
    .short MB2_TAG_ALIGN
    .short 0
    .long 8

.align 8

multiboot2_end_tag:
    .short MB2_TAG_END
    .short 0
    .long 8

multiboot2_header_end:


.section .boot_rodata, "a", @progbits

.align 8

gdt_base:
    .quad 0

    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0x9a
    .byte 0xcf
    .byte 0x00

    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0x92
    .byte 0xcf
    .byte 0x00

gdt_end:

.align 8

gdtr:
    .word gdt_end - gdt_base - 1
    .long gdt_base


.section .boot_bss, "aw", @nobits

.align 4096

.global page_directory

page_directory:
    .skip 4096


.align 16

.global __stack_bottom

__stack_bottom:
    .skip 65536

.global __stack_top

__stack_top:

# **********************
# * TEMP MB DATA STORE *
# **********************
.align 4
.global boot_magic
boot_magic:
    .long 0

.global boot_info
boot_info:
    .long 0


.section .boot_text, "ax", @progbits

.global _start
.type _start, @function

.code32

_start:
    cli

    mov %eax, boot_magic
    mov %ebx, boot_info

    mov $__stack_top, %esp
    and $-16, %esp

    xor %ebp, %ebp

    mov $page_directory, %edi
    xor %eax, %eax
    mov $1024, %ecx
    rep stosl

    mov $0x00000083, %eax
    mov %eax, page_directory + (0 * 4)

    mov $0x00400083, %eax
    mov %eax, page_directory + (1 * 4)

    mov $0x00800083, %eax
    mov %eax, page_directory + (2 * 4)

    mov $0x00C00083, %eax
    mov %eax, page_directory + (3 * 4)

    mov $0x01000083, %eax
    mov %eax, page_directory + (4 * 4)

    mov $0x01400083, %eax
    mov %eax, page_directory + (5 * 4)

    mov $0x01800083, %eax
    mov %eax, page_directory + (6 * 4)

    mov $0x01C00083, %eax
    mov %eax, page_directory + (7 * 4)

# higher half now

    mov $0x00000083, %eax
    mov %eax, page_directory + (768 * 4)

    mov $0x00400083, %eax
    mov %eax, page_directory + (769 * 4)

    mov $0x00800083, %eax
    mov %eax, page_directory + (770 * 4)

    mov $0x00C00083, %eax
    mov %eax, page_directory + (771 * 4)

    mov $0x01000083, %eax
    mov %eax, page_directory + (772 * 4)

    mov $0x01400083, %eax
    mov %eax, page_directory + (773 * 4)

    mov $0x01800083, %eax
    mov %eax, page_directory + (774 * 4)

    mov $0x01C00083, %eax
    mov %eax, page_directory + (775 * 4)

# enable 4 MiB paging
    mov %cr4, %eax
    or $0x10, %eax
    mov %eax, %cr4

# load page diretory
    mov $page_directory, %eax
    mov %eax, %cr3

# enable paging
    mov %cr0, %eax
    or $0x80000000, %eax
    mov %eax, %cr0

# load the gdt
    lgdt gdtr

# reload the code segment and jump to the higher half
    ljmp $0x08, $higher_half_entry


.code32

.global higher_half_entry
.type higher_half_entry, @function
.extern _cmain

higher_half_entry:
    mov $0x10, %ax

    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    mov $__stack_top, %esp
    and $-16, %esp

    xor %ebp, %ebp

    sub $8, %esp

    pushl boot_info
    pushl boot_magic
    call _cmain

    add $16, %esp
.halt:
    cli
    hlt
    jmp .halt

.size _start, . - _start
