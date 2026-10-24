#include <log/log.h>
#include <interrupts/context.h>

void __i686_interrupt_dispatch(uint32_t vector, struct __i686_context *context) {
    kinfo("Interrupt vector 0x%lx (Error Code: 0x%lx) at 0x%.8lx\n", vector, context->error_code, context->eip);
}
