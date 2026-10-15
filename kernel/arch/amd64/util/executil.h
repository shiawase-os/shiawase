#ifndef _AMD64_EXECUTIL_H
#define _AMD64_EXECUTIL_H

#include <stdint.h>

void __amd64_clear_bss(uint64_t bss_address, uint64_t bss_size);

#endif // _AMD64_EXECUTIL_H
