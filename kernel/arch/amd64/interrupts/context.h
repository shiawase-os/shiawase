#pragma once
#include <stdint.h>

struct __amd64_context {
    uint64_t cr2; // CR2 is for page faults, contains the faulting address
    uint64_t gs, fs, es, ds; // Segment registers
    uint64_t rax, rbx, rcx, rdx;
    uint64_t r8, r9, r10, r11, r12, r13, r14, r15;
    uint64_t rdi, rsi;
    uint64_t vector; // Interrupt vector / number
    uint64_t rbp; // Base pointer, for walking the stack
    uint64_t error_code; // Error code for exceptions, only pushed on vectors 8, 10–14, 17, 21, 29, 30, otherwise 0
    uint64_t rip, cs, rflags, rsp, ss; // Pushed by the CPU
};
