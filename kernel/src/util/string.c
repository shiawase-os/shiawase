#include <string.h>

void *memcpy(void *restrict dest, const void *restrict src, size_t n) {
    unsigned char *d = dest;
    const unsigned char *s = src;

    for (size_t i = 0; i < n; i++) {
        d[i] = s[i];
    }

    return dest;
}

int strcmp(const char *s1, const char *s2) {
    while (1) {
        int res = ((*s1 == 0) || (*s1 != *s2));
        if  (__builtin_expect((res), 0)) {
            break;
        }
        ++s1;
        ++s2;
    }

    return (*s1 - *s2);
}
