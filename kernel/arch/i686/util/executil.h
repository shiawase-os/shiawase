#ifndef _I686_EXECUTIL_H
#define _I686_EXECUTIL_H

#include <stdint.h>

void __i686_clear_bss(uint32_t bss_start, uint32_t bss_size);

#endif // _I686_EXECUTIL_H
