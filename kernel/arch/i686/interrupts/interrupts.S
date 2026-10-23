.section .text
.extern __i686_interrupt_dispatch

.global __i686_load_idt
.type __i686_load_idt, @function
__i686_load_idt:
    movl 4(%esp), %eax
    lidt (%eax)
    ret
.size __i686_load_idt, .-__i686_load_idt

.section .rodata
.balign 4
.global __i686_isr_table
.type __i686_isr_table, @object
__i686_isr_table:
.section .text

.macro ISR_NO_ERROR vector
.global __i686_isr_\vector
.type __i686_isr_\vector, @function
__i686_isr_\vector:
    pushl $0
    pushl $\vector
    jmp __i686_isr_common
.size __i686_isr_\vector, .-__i686_isr_\vector
.endm

.macro ISR_ERROR vector
.global __i686_isr_\vector
.type __i686_isr_\vector, @function
__i686_isr_\vector:
    pushl $\vector
    jmp __i686_isr_common
.size __i686_isr_\vector, .-__i686_isr_\vector
.endm

.macro ISR_STUB vector
    .if (\vector == 8) || (\vector >= 10 && \vector <= 14) || (\vector == 17) || (\vector == 21) || (\vector == 29) || (\vector == 30)
        ISR_ERROR \vector
    .else
        ISR_NO_ERROR \vector
    .endif
    .pushsection .rodata
    .long __i686_isr_\vector
    .popsection
.endm

.altmacro
.set isr_vec, 0
.rept 256
    ISR_STUB %isr_vec
    .set isr_vec, isr_vec + 1
.endr
.noaltmacro

.section .rodata
.size __i686_isr_table, 1024
.section .text

.global __i686_isr_common
.type __i686_isr_common, @function
__i686_isr_common:
    pushal

    xorl %eax, %eax
    movw %ds, %ax
    pushl %eax

    xorl %eax, %eax
    movw %es, %ax
    pushl %eax

    xorl %eax, %eax
    movw %fs, %ax
    pushl %eax

    xorl %eax, %eax
    movw %gs, %ax
    pushl %eax

    movl %cr2, %eax
    pushl %eax

    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es

    cld

    movl %esp, %ebx
    movl 0x34(%esp), %eax

    andl $-16, %esp
    subl $16, %esp
    movl %ebx, 4(%esp)
    movl %eax, 0(%esp)
    call __i686_interrupt_dispatch

    movl %ebx, %esp

    cli

    jmp __i686_isr_resume_from_context
.size __i686_isr_common, .-__i686_isr_common

.global __i686_isr_resume_from_context
.type __i686_isr_resume_from_context, @function
__i686_isr_resume_from_context:
    addl $4, %esp

    popl %eax
    movw %ax, %gs

    popl %eax
    movw %ax, %fs

    popl %eax
    movw %ax, %es

    popl %eax
    movw %ax, %ds

    popal

    addl $8, %esp

    iretl
.size __i686_isr_resume_from_context, .-__i686_isr_resume_from_context
