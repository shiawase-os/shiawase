#include "mem/gdt.h"
#include <arch/arch.h>

#include <log/log.h>

int arch_early_init() {
    __i686_gdt_reload();
    __i686_get_set_ldt(0x0, 0x0);
    return 0;
}
