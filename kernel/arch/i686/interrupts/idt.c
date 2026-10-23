#include "log/log.h"
#include "mem/gdt.h"
#include <interrupts/idt.h>
#include <stddef.h>

void __i686_idt_entry_set_handler(struct __i686_idt_entry *entry, uintptr_t address) {
    entry->offset_low = address & 0xffff;
    entry->offset_high = (address >> 16) & 0xffff;
}

// todo: cpu local struct
static struct __i686_idt_entry idt[256];

void __i686_idt_setup() {
    for (size_t i = 0; i < 256; ++i) {
        struct __i686_idt_entry *entry = &idt[i];

        entry->segment_selector = KERNEL_CODE_SELECTOR;
        entry->reserved0 = 0;
        entry->reserved1 = 0;
        entry->gate_type = 0b1110;
        entry->dpl = 0b00;
        entry->present = 0b1;

        __i686_idt_entry_set_handler(entry, __i686_isr_table[i]);
    }
 }

 void __i686_idt_reload() {
     struct __i686_idtr idtr = {
         .size = sizeof(idt) - 1,
        .offset = (uintptr_t)idt,
     };

     __i686_load_idt(&idtr);

     kinfo("[OK] i686 IDT loaded at 0x%.8lx\n", idt);
 }
