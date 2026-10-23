#pragma once

#include <stdint.h>
#include <util/compiler.h>

struct __i686_idtr {
    uint16_t size;
    uint32_t offset;
} __packed;

struct __i686_idt_entry {
    uint16_t offset_low;
    uint16_t segment_selector;
    uint8_t reserved0;
    uint8_t gate_type : 4;
    uint8_t reserved1 : 1;
    uint8_t dpl : 2;
    uint8_t present : 1;
    uint16_t offset_high;
} __packed;

_Static_assert(sizeof(struct __i686_idt_entry) == 8, "i686 IDT entry must be 8 bytes");
_Static_assert(sizeof(struct __i686_idtr) == 6, "i686 IDTR must be 6 bytes");

extern const uint32_t __i686_isr_table[256];

void __i686_idt_entry_set_handler(struct __i686_idt_entry *entry, uintptr_t address);
void __i686_load_idt(void *idtr);

void __i686_idt_setup();
void __i686_idt_reload();
