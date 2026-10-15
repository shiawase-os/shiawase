#include <log/level.h>

#include <log/sinks.h>
#include <string.h>
#include <stddef.h>

uint8_t log_level_threshold = LOGLEVEL_INFO;
static struct log_sink *head = NULL;
static struct log_sink *tail = NULL;

int register_log_sink(struct log_sink *sink) {
    if (!sink || !sink->name || !sink->write) {
        return -1;
    }

    for (struct log_sink *cur = head; cur; cur = cur->next) {
        if (cur == sink) {
            return -1;
        }
    }

    sink->next = NULL;

    if (!head) {
        head = sink;
        tail = sink;
    } else {
        tail->next = sink;
        tail = sink;
    }

    return 0;
}

int unregister_log_sink(const char *name) {
    if (!name) {
        return -1;
    }

    struct log_sink *prev = NULL;
    struct log_sink *cur = head;

    while (cur) {
        if (strcmp(name, cur->name) == 0) {
            if (prev) {
                prev->next = cur->next;
            } else {
                head = cur->next;
            }

            if (tail == cur) {
                tail = prev;
            }

            cur->next = NULL;
            return 0;
        }
    }

    return -1;
}

int output_to_sinks(const struct log_record record) {
    if (record.level < log_level_threshold) {
        return 0;
    }

    for (struct log_sink *cur = head; cur; cur = cur->next) {
        if (record.level >= cur->log_level_threshold) {
            cur->write(record);
        }
    }

    return 0;
}
