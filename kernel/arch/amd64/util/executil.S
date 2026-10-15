.section .text
.global __amd64_clear_bss
.type __amd64_clear_bss, @function

__amd64_clear_bss:
    mov %rsi, %rcx
    xor %eax, %eax
    shr $3, %rcx
    rep stosq

    mov %rsi, %rcx
    and $7, %rcx
    rep stosb

    ret
