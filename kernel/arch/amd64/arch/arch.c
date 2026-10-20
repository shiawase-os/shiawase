#include "mem/gdt.h"
#include <arch/arch.h>

#include <log/log.h>

int arch_early_init() {
    __amd64_gdt_reload();
    __amd64_get_set_ldt(0x0, 0x0);
    return 0;
}
