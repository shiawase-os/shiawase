#pragma once
// this is basically a collection of functions EVERY architecture has to define

// init arch stuff (like gdt & idt for x86)
int arch_early_init();
