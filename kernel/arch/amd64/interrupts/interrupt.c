#include "log/log.h"

void __amd64_interrupt_dispatch() {
    kinfo("Interrupt!\n");
    for (;;)
        ;
}
