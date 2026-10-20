#include "arch/arch.h"
#include "log/log.h"
#include <boot/bpb.h>

void kmain(struct boot_parameter_block *bpb) {
    kinfo("Tsunami (Shiawase Kernel) on %s (%s) [%s]\n", bpb->arch, bpb->protocol, bpb->loader);

    arch_early_init();

    for (;;)
        ;
}
