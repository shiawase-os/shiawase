#pragma once
#include <stdint.h>

#define KERNEL_CODE_SELECTOR    0x08
#define KERNEL_DATA_SELECTOR    0x10
#define USER_CODE_SELECTOR      0x18
#define USER_DATA_SELECTOR      0x20
#define TSS_LOW_SELECTOR        0x28
#define TSS_HIGH_SELECTOR       0x30
#define LDT_LOW_SELECTOR        0x38
#define LDT_HIGH_SELECTOR       0x40

void __amd64_gdt_reload();
void __amd64_get_set_ldt(void *base, uint64_t limit);
