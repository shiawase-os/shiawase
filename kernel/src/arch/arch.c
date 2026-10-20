#include "log/log.h"
#include "util/compiler.h"
#include <arch/arch.h>

__weak int arch_early_init() {
    // do nothing
    kinfo("default arch_early_init()");
    return 0;
}
