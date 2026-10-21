#pragma once
#include <stdint.h>
#include <util/compiler.h>

struct __amd64_idtr {
    uint16_t size;
    uint64_t offset;
} __packed;

struct __amd64_idt_entry {
    uint16_t offset_low;
    uint16_t segment_selector;
    uint8_t ist : 3;
    uint8_t reserved0 : 5;
    uint8_t gate_type : 4;
    uint8_t reserved1 : 1;
    uint8_t dpl : 2;
    uint8_t present : 1;
    uint16_t offset_mid;
    uint32_t offset_high;
    uint32_t reserved2;
} __packed;

_Static_assert(sizeof(struct __amd64_idt_entry) == 16, "AMD64 IDT entry must be 16 bytes");
_Static_assert(sizeof(struct __amd64_idtr) == 10, "AMD64 IDTR must be 10 bytes");

extern const uint64_t __amd64_isr_table[256];

void __amd64_idt_entry_set_handler(struct __amd64_idt_entry *entry, uintptr_t address);
void __amd64_load_idt(void *idtr);

void __amd64_idt_setup();
void __amd64_idt_reload();
