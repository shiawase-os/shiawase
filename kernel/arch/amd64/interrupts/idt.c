#include "log/log.h"
#include "mem/gdt.h"
#include <interrupts/idt.h>
#include <stddef.h>

void __amd64_idt_entry_set_handler(struct __amd64_idt_entry *entry, uintptr_t address) {
    entry->offset_low = address & 0xffff;
    entry->offset_mid = (address >> 16) & 0xffff;
    entry->offset_high = (address >> 32) & 0xffffffff;
}

// todo: cpu local structure
static struct __amd64_idt_entry idt[256];

void __amd64_idt_setup() {
    for (size_t i = 0; i < 256; ++i) {
        struct __amd64_idt_entry *entry = &idt[i];

        entry->segment_selector = KERNEL_CODE_SELECTOR;
        entry->ist = 0;
        entry->gate_type = 0b1110;
        entry->dpl = 0;
        entry->present = 1;
        entry->reserved0 = 0;
        entry->reserved1 = 0;
        entry->reserved2 = 0;

        __amd64_idt_entry_set_handler(entry, __amd64_isr_table[i]);
    }
}

void __amd64_idt_reload() {
    struct __amd64_idtr idtr = {
        .size = sizeof(idt) - 1,
        .offset = (uintptr_t)idt,
    };

    __amd64_load_idt(&idtr);

    kinfo("[OK] AMD64 IDT loaded at 0x%.16llx\n", idt);
}
