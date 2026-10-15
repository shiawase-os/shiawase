#ifndef _STRING_H
#define _STRING_H

#include <stddef.h>

void *memcpy(void *restrict dest, const void *restrict src, size_t n);

int strcmp(const char *s1, const char *s2);

#endif // _STRING_H
