
#include <cpu/local.h>
#include <mem/gdt.h>

void __i686_set_cpu_local(struct __i686_cpu *cpu_local) {
    if (cpu_local == NULL) {
        return;
    }

    cpu_local->self = cpu_local;
    __i686_gdt_reload(cpu_local);
}
