#pragma once
#include <stdint.h>

void __i686_gdt_reload();
void __i686_get_set_ldt(void *base, uint32_t limit);
