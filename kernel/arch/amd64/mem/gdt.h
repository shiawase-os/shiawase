#ifndef _AMD64_GDT_H
#define _AMD64_GDT_H

#include <stdint.h>

void __amd64_gdt_reload();
void __amd64_get_set_ldt(void *base, uint64_t limit);

#endif // _AMD64_GDT_H
