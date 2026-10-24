// CPU local data structures
#pragma once
#include <stdint.h>
#include <interrupts/idt.h>
#include <stddef.h>

struct __amd64_cpu {
    void *self; // Pointer to the address of the this struct, this is located at gs:0 so this is a sneeky shortcut
    uint64_t cpuid; // ID of the current CPU
    uint64_t gdt[9]; // GDT for this CPU
    struct __amd64_idt_entry idt[256]; // IDT for this CPU
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

#define CPU_LOCAL_ARRAY(field) ({ \
    uintptr_t __base; \
    __asm__ volatile ( \
        "mov %%gs:0, %0" \
        : "=r"(__base) \
    ); \
    &((struct __amd64_cpu *)__base)->field[0]; \
})

void __amd64_set_cpu_local(struct __amd64_cpu *cpu_local);
