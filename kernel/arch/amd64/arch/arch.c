#include "cpu/local.h"
#include "interrupts/idt.h"
#include "mem/gdt.h"
#include <arch/arch.h>

#include <log/log.h>

static struct __amd64_cpu __amd64_bsp_cpu = {
    .self = &__amd64_bsp_cpu,
    .cpuid = 0
};

int arch_early_init() {
    __amd64_set_cpu_local(&__amd64_bsp_cpu);
    kinfo("Bootstrap Processor CPU local info at 0x%.16llx\n", &__amd64_bsp_cpu);
    __amd64_gdt_reload();
    __amd64_get_set_ldt(0x0, 0x0);
    __amd64_idt_setup();
    __amd64_idt_reload();

    asm ("int $0x3");
    asm ("int $0x3");
    return 0;
}
