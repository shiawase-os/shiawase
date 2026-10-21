#pragma once
#include <log/record.h>

extern uint8_t log_level_threshold;

struct log_sink {
    char *name;
    uint8_t log_level_threshold;

    void (*write)(const struct log_record record);

    struct log_sink *next;
};

int register_log_sink(struct log_sink *sink);
int unregister_log_sink(const char *name);

int output_to_sinks(const struct log_record record);
