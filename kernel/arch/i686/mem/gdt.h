#pragma once
#include <stdint.h>

struct __i686_cpu;

#define KERNEL_CODE_SELECTOR    0x08
#define KERNEL_DATA_SELECTOR    0x10
#define USER_DATA_SELECTOR      0x18
#define USER_CODE_SELECTOR      0x20
#define LDT_SELECTOR            0x28
#define CPU_LOCAL_SELECTOR      0x30

void __i686_gdt_reload(struct __i686_cpu *cpu);
void __i686_get_set_ldt(struct __i686_cpu *cpu, void *base, uint32_t limit);
