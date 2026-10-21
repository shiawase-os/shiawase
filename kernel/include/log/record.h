#pragma once

#include <stdint.h>

struct log_record {
    uint8_t level;

    uint64_t timestamp;
    uint32_t cpuid;
    char *message;
};
