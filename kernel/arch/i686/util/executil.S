.section .text
.code32
.global __i686_clear_bss
.type __i686_clear_bss, @function

__i686_clear_bss:
    push %edi

    mov 8(%esp), %edi
    mov 12(%esp), %ecx

    xor %eax, %eax

    mov %ecx, %edx
    shr $2, %ecx
    rep stosl

    mov %edx, %ecx
    and $3, %ecx
    rep stosb

    pop %edi
    ret
