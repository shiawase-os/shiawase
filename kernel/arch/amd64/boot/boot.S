# exported symbols, by the linker
.extern __kernel_start
.extern __kernel_end
.extern __kernel_phys_start
.extern __kernel_phys_end
.extern __kernel_bss_end

# kernel-specifc variables
.set KERNEL_VIRT_BASE, 0xffffffff80000000
.set KERNEL_PHYS_BASE, 0x00200000

# ***************
# * MULTIBOOT 1 *
# ***************
.section .multiboot1, "a", @progbits

# mb1 flags
.set MB1_ALIGN,       (1 << 0)
.set MB1_MEMORY_INFO, (1 << 1)
.set MB1_AOUT_KLUDGE, (1 << 16)

# general mb1 variables
.set MB1_FLAGS,    (MB1_ALIGN | MB1_MEMORY_INFO | MB1_AOUT_KLUDGE)
.set MB1_MAGIC,    0x1BADB002
.set MB1_CHECKSUM, -(MB1_MAGIC + MB1_FLAGS)

# multiboot1 header has to be 4-byte aligned
.align 4
multiboot_header:
    .long MB1_MAGIC # write the magic first
    .long MB1_FLAGS # then flags
    .long MB1_CHECKSUM # and checksum

    .long multiboot_header
    .long __kernel_phys_start
    .long __kernel_phys_end
    .long __kernel_bss_end
    .long _start



# ***************
# * MULTIBOOT 2 *
# ***************
.section .multiboot2, "a", @progbits

# mb2 values
.set MB2_MAGIC,    0xE85250D6
.set MB2_ARCH,     0
.set MB2_LENGTH,   (multiboot2_header_end - multiboot2_header)
.set MB2_CHECKSUM, -(MB2_MAGIC + MB2_ARCH + MB2_LENGTH)

# mb2 tag ids
.set MB2_TAG_END,   0
.set MB2_TAG_ENTRY, 3
.set MB2_TAG_ALIGN, 6

# the mb2 header and its tags have to be 8-byte aligned
.align 8
multiboot2_header:
    .long MB2_MAGIC
    .long MB2_ARCH
    .long MB2_LENGTH
    .long MB2_CHECKSUM

.align 8
multiboot2_entry_tag: # specify the entry of the kernel
    .short MB2_TAG_ENTRY
    .short 0
    .long 12
    .long _start

.align 8
multiboot2_align_tag: # specify that modules should be aligned
    .short MB2_TAG_ALIGN
    .short 0
    .long 8

.align 8
multiboot2_end_tag: # end
    .short MB2_TAG_END
    .short 0
    .long 8

multiboot2_header_end:

# *******************
# * AMD64 EARLY GDT *
# *******************
.section .boot_rodata, "a", @progbits

.align 8
gdt_base:
    .quad 0 # null descriptor

    .word 0xffff # 64-bit kernel code descriptor
    .word 0x0000
    .byte 0x00
    .byte 0x9a
    .byte 0x20
    .byte 0x00

    .word 0xffff # 64-bit kernel data descriptor
    .word 0x0000
    .byte 0x00
    .byte 0x92
    .byte 0x00
    .byte 0x00
gdt_end:

# gdt pointer
.align 8
gdtr:
    .word gdt_end - gdt_base - 1
    .long gdt_base


# **********************
# * AMD64 EARLY PAGING *
# **********************
.section .boot_bss, "aw", @nobits

# each table is 4096 blocks
.align 4096

# pml4_table also called PML4
.global pml4_table
pml4_table:
    .skip 4096

# pdpt_table also called PDPT
.global pdpt_table
pdpt_table:
    .skip 4096

# p2_table for identiy mapped also called pd_identity
.global pd_identity
pd_identity:
    .skip 4096

# p2_table for higher half mapped also called pd_high
.global pd_high
pd_high:
    .skip 4096

# *****************
# * INITIAL STACK *
# *****************
.align 16
.global __stack_bottom
__stack_bottom:
    .skip 65536 # reserve 16 KiB of stack for the kernel

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


# ********************
# * 32-BIT BOOTSTRAP *
# ********************
.section .boot_text, "ax", @progbits # put it into the lower half part
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

    mov $pdpt_table, %eax
    or $0x03, %eax
    mov %eax, pml4_table

    mov $pdpt_table, %eax
    or $0x03, %eax
    mov %eax, pml4_table + (511 * 8)

    mov $pd_identity, %eax
    or $0x03, %eax
    mov %eax, pdpt_table

    mov $pd_high, %eax
    or $0x03, %eax
    mov %eax, pdpt_table + (510 * 8)

    mov $pd_identity, %edi
    mov $0x00000083, %eax
    mov $32, %ecx

.identity_loop:
    mov %eax, (%edi)
    add $0x00200000, %eax
    add $8, %edi
    loop .identity_loop

    mov $pd_high, %edi
    mov $0x00200083, %eax
    mov $32, %ecx

.high_loop:
    mov %eax, (%edi)
    add $0x00200000, %eax
    add $8, %edi
    loop .high_loop


    mov %cr4, %eax
    or $0x20, %eax
    mov %eax, %cr4

    mov $pml4_table, %eax
    mov %eax, %cr3

    mov $0xc0000080, %ecx
    rdmsr
    or $0x100, %eax
    wrmsr

    mov %cr0, %eax
    or $0x80000000, %eax
    mov %eax, %cr0

    mov $gdt_base, %eax
    mov %eax, gdtr + 2
    lgdt gdtr

    ljmp $0x08, $_long_mode_entry


.code64

.global _long_mode_entry
.type _long_mode_entry, @function

_long_mode_entry:
    cli

    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    movabs $_long_mode_high, %rax
    jmp *%rax


.extern _cmain

_long_mode_high:
    cli

    mov $__stack_top, %rsp
    and $-16, %rsp

    xor %ebp, %ebp

    movabs $boot_magic, %rax
    mov (%rax), %edi

    movabs $boot_info, %rax
    mov (%rax), %esi


    movabs $_cmain, %rax
    call *%rax

.halt:
    cli
    hlt
    jmp .halt

.size _start, . - _start
