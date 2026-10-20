#include "log/log.h"
#include "util/compiler.h"
#include <mem/gdt.h>
#include <stdint.h>
#include <string.h>

static const uint64_t __i686_gdt_template[6] = {
    0x0000000000000000, // null 0x00
    0x00cf9b000000ffff, // code32 0x08
    0x00cf93000000ffff, // data32 0x10
    0x00cff3000000ffff, // udata32 0x18
    0x00cffb000000ffff, // ucode32 0x20
    0x0000000000000000, // ldt 0x28
};

struct __i686_gdtr {
    uint16_t size;
    uint32_t address;
} __packed;

// TODO: CPU-local GDT.
static uint64_t __i686_current_gdt[6] = { 0 };

void __i686_gdt_reload(void) {
    uint64_t *gdt = __i686_current_gdt;

    memcpy(gdt, __i686_gdt_template, sizeof(__i686_gdt_template));

    struct __i686_gdtr gdtr = {
        .size = sizeof(__i686_gdt_template) - 1,
        .address = (uint32_t)(uintptr_t)gdt,
    };

    asm volatile("lgdt (%0)" : : "r"(&gdtr) : "memory");

    asm volatile(
        "movw $0x10, %%ax\n\t"
        "movw %%ax, %%ds\n\t"
        "movw %%ax, %%es\n\t"
        "movw %%ax, %%ss\n\t"
        "movw %%ax, %%gs\n\t"
        "movw %%ax, %%fs\n\t"
        "ljmp $0x08, $1f\n\t"
        "1:\n\t"
        :
        :
        : "eax", "memory"
    );

    kinfo("[OK] Initialized i686 GDT at 0x%.8x\n",
          (uint32_t)(uintptr_t)gdt);
}

void __i686_get_set_ldt(void *base, uint32_t limit) {
    uint64_t *gdt = __i686_current_gdt;

    if (base == NULL) {
        gdt[5] = 0;
        asm volatile("lldt %%ax" : : "a"((uint16_t)0) : "memory");
        return;
    }

    uintptr_t address = (uintptr_t)base;

    if (limit > 0xfffff || address > UINT32_MAX) {
        kwarn("i686 LDT base or limit is out of range\n");
        return;
    }

    gdt[5] = 0;
    gdt[5] |= (uint64_t)(limit & 0xffff);
    gdt[5] |= (uint64_t)(address & 0xffff) << 16;
    gdt[5] |= (uint64_t)((address >> 16) & 0xff) << 32;
    gdt[5] |= UINT64_C(0x8200) << 40;
    gdt[5] |= (uint64_t)((limit >> 16) & 0x0f) << 48;
    gdt[5] |= (uint64_t)((address >> 24) & 0xff) << 56;

    asm volatile("lldt %%ax" : : "a"((uint16_t)0x28) : "memory");
}
