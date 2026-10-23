// Model Specifc Register (MSR) handling code
#pragma once
#include <stdint.h>

#define IA32_GS_BASE        0xC0000101
#define IA32_KERNEL_GS_BASE 0xC0000102

static inline void __amd64_wrmsr(uint32_t msr, uint64_t value) {
    uint32_t low = (uint32_t)value;
    uint32_t high = (uint32_t)(value >> 32);

    __asm__ volatile ("wrmsr" :: "c"(msr), "a"(low), "d"(high) : "memory");
}

static inline uint64_t __amd64_rdmsr(uint32_t msr) {
    uint32_t low;
    uint32_t high;

    __asm__ volatile ("rdmsr" : "=a"(low), "=d"(high) : "c"(msr) : "memory");
    return ((uint64_t)high << 32) | low;
}
