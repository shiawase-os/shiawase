#define NANOPRINTF_IMPLEMENTATION

#define NANOPRINTF_USE_FIELD_WIDTH_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_PRECISION_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_FLOAT_FORMAT_SPECIFIERS 0
#define NANOPRINTF_USE_LARGE_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_SMALL_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_BINARY_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_WRITEBACK_FORMAT_SPECIFIERS 1

#include <log/log.h>

#include <log/record.h>
#include <log/nanoprintf.h>
#include <log/sinks.h>
#include <stdarg.h>

void klog(int level, const char *fmt, ...) {
    char buffer[KLOG_BUFFER_SIZE];

    va_list args;
    va_start(args, fmt);

    npf_vsnprintf(buffer, sizeof(buffer), fmt, args);

    va_end(args);

    struct log_record record = {
        .cpuid = 0,
        .timestamp = 0,
        .level = level,
        .message = buffer
    };

    output_to_sinks(record);
}
