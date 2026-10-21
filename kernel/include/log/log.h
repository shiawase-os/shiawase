#pragma once
#include <log/level.h>

#define KLOG_BUFFER_SIZE 1024

void klog(int level, const char *fmt, ...);

#define kdbg(fmt, ...) klog(LOGLEVEL_DEBUG, fmt __VA_OPT__(,) __VA_ARGS__)
#define kinfo(fmt, ...) klog(LOGLEVEL_INFO, fmt __VA_OPT__(,) __VA_ARGS__)
#define kwarn(fmt, ...) klog(LOGLEVEL_WARN, fmt __VA_OPT__(,) __VA_ARGS__)
#define kerr(fmt, ...) klog(LOGLEVEL_ERROR, fmt __VA_OPT__(,) __VA_ARGS__)
