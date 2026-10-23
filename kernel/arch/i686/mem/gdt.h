#pragma once
#include <stdint.h>

#define KERNEL_CODE_SELECTOR    0x08
#define KERNEL_DATA_SELECTOR    0x10
#define USER_CODE_SELECTOR      0x18
#define USER_DATA_SELECTOR      0x20
#define LDT_SELECTOR            0x28

void __i686_gdt_reload();
void __i686_get_set_ldt(void *base, uint32_t limit);
