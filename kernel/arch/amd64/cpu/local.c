#include <cpu/local.h>

#include <cpu/msr.h>

void __amd64_set_cpu_local(struct __amd64_cpu *cpu_local) {
    __amd64_wrmsr(IA32_GS_BASE, (uintptr_t)cpu_local);
    __amd64_wrmsr(IA32_KERNEL_GS_BASE, (uintptr_t)cpu_local);
}
