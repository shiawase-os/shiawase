#include "log/log.h"
#include "util/compiler.h"
#include <mem/gdt.h>
#include <stdint.h>
#include <string.h>

static const uint64_t __amd64_gdt_template[9] = {
    0x0, // NULL 0x0
    0x00af9b000000ffff, // code64 0x8
	0x00af93000000ffff, // data64 0x10
	0x00eff3000000ffff, // udata64 0x18
	0x00affb000000ffff, // ucode64 0x20
	0x0020890000000000, // low tss 0x28
	0x0000000000000000, // high tss
	0x0000000000000000, // low ldt
	0x0000000000000000  // high ldt
};

struct __amd64_gdtr {
    uint16_t size;
    uint64_t address;
} __packed;

// todo: cpu local structure
static uint64_t __amd64_current_gdt[9] = { 0 };

void __amd64_gdt_reload() {
    uint64_t *gdt = __amd64_current_gdt;

    memcpy(gdt, __amd64_gdt_template, sizeof(__amd64_gdt_template));

    // todo: tss stuff
    /*uintptr_t tss_addr = 0x0;

    gdt[5] |= ((tss_addr & 0xff000000) << 32) | ((tss_addr & 0xff0000) << 16) | ((tss_addr & 0xffff) << 16) | 0x68; // 0x68 is the size of the TSS on x86_64
    gdt[6] = (tss_addr >> 32) & 0xffffffff;*/

    struct __amd64_gdtr gdtr = {
        .size = sizeof(__amd64_gdt_template) - 1,
        .address = (uintptr_t)gdt,
    };

    asm volatile("lgdt (%%rax)" : : "a"(&gdtr) : "memory");
    asm volatile(
		"mov $0x10, %%ax;"
		"mov %%ax, %%ds;"
		"mov %%ax, %%es;"
		"mov %%ax, %%ss;"
		"mov %%ax, %%gs;"
		"mov %%ax, %%fs;"
		"pushq $0x8;"
		"pushq $.reload;"
		"retfq;"
		".reload:"
	: : : "ax");

    kinfo("[OK] Initialized amd64 GDT at 0x%.16llx\n", gdt);
}

void __amd64_get_set_ldt(void *base, uint64_t limit) {
    (void)limit;

    uint64_t *gdt = __amd64_current_gdt;

    if (base == NULL) {
        gdt[7] = 0;
        gdt[8] = 0;
        asm volatile("lldt %%ax" : : "a"(0));
		return;
    }

    uint64_t base_low = (uint64_t)base & 0xffffffff;
	gdt[7] = 0x82000000ffff; // present, ldt, limit 64k
	gdt[7] |= (base_low & 0xffff) << 16;
	gdt[7] |= ((base_low >> 16) & 0xff) << 32;
	gdt[7] |= ((base_low >> 24) & 0xff) << 56;
	gdt[8] = ((uint64_t)base >> 32) & 0xffffffff;
	asm volatile("lldt %%ax" : : "a"(0x38));
}
