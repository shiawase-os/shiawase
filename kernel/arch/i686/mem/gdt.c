#include "log/log.h"
#include "util/compiler.h"
#include <mem/gdt.h>
#include <stdint.h>
#include <string.h>
#include <limits.h>
#include <cpu/local.h>

static const uint64_t __i686_gdt_template[7] = {
    0x0000000000000000, // null 0x00
    0x00cf9b000000ffff, // code32 0x08
    0x00cf93000000ffff, // data32 0x10
    0x00cff3000000ffff, // udata32 0x18
    0x00cffb000000ffff, // ucode32 0x20
    0x0000000000000000, // ldt 0x28
    0x0000000000000000, // CPU-local  0x30
};

struct __i686_gdtr {
    uint16_t size;
    uint32_t address;
} __packed;

static uint64_t __i686_make_segment_descriptor(uintptr_t base, uint32_t limit, uint8_t access, uint8_t flags) {
    uint64_t descriptor = 0;

    descriptor |= (uint64_t)(limit & 0xffff);
    descriptor |= (uint64_t)(base & 0xffff) << 16;
    descriptor |= (uint64_t)((base >> 16) & 0xff) << 32;
    descriptor |= (uint64_t)access << 40;
    descriptor |= (uint64_t)((limit >> 16) & 0x0f) << 48;
    descriptor |= (uint64_t)(flags & 0x0f) << 52;
    descriptor |= (uint64_t)((base >> 24) & 0xff) << 56;

    return descriptor;
}

void __i686_gdt_reload(struct __i686_cpu *cpu) {
    if (cpu == NULL){
        return;
    }

    uintptr_t cpu_address = (uintptr_t)cpu;
    uintptr_t gdt_address = (uintptr_t)&cpu->gdt[0];
    size_t cpu_size = sizeof(*cpu);

    if (cpu_address > UINT32_MAX || gdt_address > UINT32_MAX || cpu_size == 0 || cpu_size > 0x100000) {
        kerr("i686 GDT: CPU-local address or size out of range\n");
        return;
    }

    memcpy(cpu->gdt, __i686_gdt_template, sizeof(__i686_gdt_template));

    cpu->gdt[6] = __i686_make_segment_descriptor(cpu_address, (uint32_t)(cpu_size - 1), 0x92, 0x04 );

    struct __i686_gdtr gdtr = {
        .size = sizeof(cpu->gdt) - 1,
        .address = (uint32_t)gdt_address,
    };

    asm volatile("lgdt (%0)" : : "r"(&gdtr) : "memory");

    asm volatile(
        "movw $0x10, %%ax\n\t"
        "movw %%ax, %%ds\n\t"
        "movw %%ax, %%es\n\t"
        "movw %%ax, %%ss\n\t"
        "movw %%ax, %%fs\n\t"
        "ljmp $0x08, $1f\n\t"
        "1:\n\t"
        "movw $0x30, %%ax\n\t"
        "movw %%ax, %%gs\n\t"
        :
        :
        : "eax", "memory"
    );
}

void __i686_get_set_ldt(struct __i686_cpu *cpu, void *base, uint32_t limit) {
    if (cpu == NULL) {
        return;
    }

    if (base == NULL) {
        cpu->gdt[5] = 0;
        asm volatile("lldt %%ax" : : "a"((uint16_t)0) : "memory");
        return;
    }

    uintptr_t address = (uintptr_t)base;

    if (address > UINT32_MAX || limit > 0xfffff) {
        kwarn("i686 LDT base or limit is out of range\n");
        return;
    }

    cpu->gdt[5] = __i686_make_segment_descriptor(address, limit, 0x82, 0x00);

    asm volatile("lldt %%ax" : : "a"((uint16_t)0x28) : "memory");
}
