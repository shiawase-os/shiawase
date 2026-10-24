
#pragma once

#include <stdint.h>
#include <stddef.h>
#include <interrupts/idt.h>

struct __i686_cpu {
    void *self; // gs:0 -> this structure
    uint32_t cpuid; // cpuid
    uint64_t gdt[7]; // GDT for this cpu
    struct __i686_idt_entry idt[256]; // Idt for this cpu
};

#define CPU_READ_LOCAL(field) ({ \
    __typeof__(((struct __i686_cpu *)0)->field) __value; \
    _Static_assert(sizeof(__value) <= sizeof(uint32_t), \
                   "CPU_READ_LOCAL supports fields up to 32 bits"); \
    __asm__ volatile ( \
        "movl %%gs:%c1, %0" \
        : "=r"(__value) \
        : "i"(offsetof(struct __i686_cpu, field)) \
    ); \
    __value; \
})

#define CPU_LOCAL_ARRAY(field) ({ \
    uintptr_t __base; \
    __asm__ volatile ( \
        "movl %%gs:0, %0" \
        : "=r"(__base) \
    ); \
    &((struct __i686_cpu *)__base)->field[0]; \
})

void __i686_set_cpu_local(struct __i686_cpu *cpu_local);
