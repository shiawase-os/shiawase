#ifndef _I686_GDT_H
#define _I686_GDT_H

#include <stdint.h>

void __i686_gdt_reload();
void __i686_get_set_ldt(void *base, uint32_t limit);

#endif // _I686_GDT_H
