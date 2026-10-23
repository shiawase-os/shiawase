#include "interrupts/idt.h"
#include "mem/gdt.h"
#include <arch/arch.h>

#include <log/log.h>

int arch_early_init() {
    __i686_gdt_reload();
    __i686_get_set_ldt(0x0, 0x0);
    __i686_idt_setup();
    __i686_idt_reload();
    asm ("int $0x3");
    asm ("int $0x3");
    return 0;
}
