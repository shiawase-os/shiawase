#pragma once
#include <stdint.h>

struct __i686_context {
    uint32_t cr2; // CR2 for page faults, contains the faulting address
    uint32_t gs, fs, es, ds; // Segment registers, more important on i686 than amd64
    uint32_t edi, esi, ebp, esp_dummy, ebx, edx, ecx, eax; // Registers pushed by `pushal`
    uint32_t vector; // Interrupt vector
    uint32_t error_code; // Exception error code, only used by vectors 8, 10–14, 17, 21, 29, 30
    uint32_t eip, cs, eflags; // Pushed by the CPU on interrupt entry
    uint32_t useresp, ss; // Only pushed / valid if (cs & 3) != 0
};
