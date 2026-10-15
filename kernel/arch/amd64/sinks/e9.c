#include "log/record.h"
#include <sinks/e9.h>

#include <log/sinks.h>
#include <io/port.h>

static void __amd64_e9_output(const char* str) {
    while (*str) {
        outb(0xe9, (uint8_t)*str++);
    }
}

static void __amd64_e9_sink_write(const struct log_record record) {
    __amd64_e9_output(record.message);
}

static struct log_sink __amd64_e9_sink = {
    .log_level_threshold = 0,
    .name = "amd64-e9",
    .write = &__amd64_e9_sink_write
};

void __amd64_register_e9_sink() {
    register_log_sink(&__amd64_e9_sink);
}
