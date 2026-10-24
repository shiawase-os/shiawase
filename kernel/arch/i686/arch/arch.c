#include "cpu/local.h"
#include "interrupts/idt.h"
#include "mem/gdt.h"
#include <arch/arch.h>
#include <log/log.h>

static struct __i686_cpu bsp_cpu = {
    .self = &bsp_cpu,
    .cpuid = 0,
};

int arch_early_init() {
    __i686_set_cpu_local(&bsp_cpu);
    __i686_get_set_ldt(CPU_READ_LOCAL(self), 0x0, 0x0);
    __i686_idt_setup();
    __i686_idt_reload();
    asm ("int $0x3");
    asm ("int $0x3");
    return 0;
}
