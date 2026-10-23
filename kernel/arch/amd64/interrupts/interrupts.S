.section .text
.extern __amd64_interrupt_dispatch

.global __amd64_load_idt
.type __amd64_load_idt, @function
__amd64_load_idt:
    lidt (%rdi)
    ret
.size __amd64_load_idt, .-__amd64_load_idt

.macro ISR_NO_ERROR vector
.global __amd64_isr_\vector
.type __amd64_isr_\vector, @function

__amd64_isr_\vector:
    pushq $0

    pushq %rbp
    pushq $\vector

    jmp __amd64_isr_common

.size __amd64_isr_\vector, .-__amd64_isr_\vector

.endm

.macro ISR_ERROR vector

.global __amd64_isr_\vector
.type __amd64_isr_\vector, @function

__amd64_isr_\vector:
    pushq %rbp

    pushq $\vector

    jmp __amd64_isr_common

.size __amd64_isr_\vector, .-__amd64_isr_\vector

.endm

.macro ISR_STUB vector
    .if (\vector == 8) || (\vector >= 10 && \vector <= 14) || (\vector == 17) || (\vector == 21) || (\vector == 29) || (\vector == 30)
        ISR_ERROR \vector
    .else
        ISR_NO_ERROR \vector
    .endif
    .pushsection .rodata
    .quad __amd64_isr_\vector
    .popsection
.endm

.section .rodata
.global __amd64_isr_table
.type __amd64_isr_table, @object
.size __amd64_isr_table, 2048
__amd64_isr_table:
.section .text

# here we go: vectors 0..255
.altmacro
.set isr_vec, 0
.rept 256
    ISR_STUB %isr_vec
    .set isr_vec, isr_vec + 1
.endr
.noaltmacro

.global __amd64_isr_common
.type __amd64_isr_common, @function

__amd64_isr_common:
    cmpq $0x08, 0x20(%rsp)
    je 1f

    swapgs
1:
    pushq %rsi

    pushq %rdi

    pushq %r15
    pushq %r14
    pushq %r13
    pushq %r12
    pushq %r11
    pushq %r10
    pushq %r9
    pushq %r8

    pushq %rdx
    pushq %rcx
    pushq %rbx
    pushq %rax

    xorq %rax, %rax
    movw %ds, %ax
    pushq %rax

    xorq %rax, %rax
    movw %es, %ax
    pushq %rax

    xorq %rax, %rax
    movw %fs, %ax
    pushq %rax

    xorq %rax, %rax
    movw %gs, %ax
    pushq %rax

    movq %cr2, %rax
    pushq %rax

    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es

    cld

    movq 0x98(%rsp), %rdi
    movq %rsp, %rsi
    subq $8, %rsp
    call __amd64_interrupt_dispatch
    addq $8, %rsp

    cli

    jmp __amd64_isr_resume_from_context
.size __amd64_isr_common, .-__amd64_isr_common

.global __amd64_isr_resume_from_context
.type __amd64_isr_resume_from_context, @function

__amd64_isr_resume_from_context:
    addq $8, %rsp
    addq $8, %rsp

    popq %rax
    movw %ax, %fs

    popq %rax
    movw %ax, %es

    popq %rax
    movw %ax, %ds

    popq %rax
    popq %rbx
    popq %rcx
    popq %rdx

    popq %r8
    popq %r9
    popq %r10
    popq %r11
    popq %r12
    popq %r13
    popq %r14
    popq %r15

    popq %rdi
    popq %rsi

    addq $16, %rsp
    addq $8, %rsp

    cmpq $0x08, 0x08(%rsp)
    je 2f
    swapgs

2:
    iretq

.size __amd64_isr_resume_from_context, .-__amd64_isr_resume_from_context
