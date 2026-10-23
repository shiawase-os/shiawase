#include "log/log.h"
#include "interrupts/context.h"

void __amd64_interrupt_dispatch(uint64_t vector, struct __amd64_context *context) {
    kinfo("Interrupt vector 0x%llx (Error Code: 0x%llx) at 0x%.16llx\n", vector, context->error_code, context->rip);
}
