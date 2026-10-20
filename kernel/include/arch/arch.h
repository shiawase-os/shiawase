#ifndef _ARCH_H
#define _ARCH_H

// this is basically a collection of functions EVERY architecture has to define

// init arch stuff (like gdt & idt for x86)
int arch_early_init();

#endif // _ARCH_H
