// CPU local data structures
#pragma once
#include <stdint.h>
#include <stddef.h>

struct __amd64_cpu {
    void *self;
    uint64_t cpuid;
};

#define CPU_READ_LOCAL(field) ({ \
    __typeof__(((struct __amd64_cpu *)0)->field) __value; \
    __asm__ volatile ( \
        "mov %%gs:%c1, %0" \
        : "=r"(__value) \
        : "i"(offsetof(struct __amd64_cpu, field)) \
    ); \
    __value; \
})

void __amd64_set_cpu_local(struct __amd64_cpu *cpu_local);
