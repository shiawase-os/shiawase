ARCH := i686

CROSS_PREFIX ?= $(ARCH)-shiawase-

CC      := $(CROSS_PREFIX)gcc
AS      := $(CROSS_PREFIX)as
LD      := $(CROSS_PREFIX)ld
AR      := $(CROSS_PREFIX)ar
OBJCOPY := $(CROSS_PREFIX)objcopy
OBJDUMP := $(CROSS_PREFIX)objdump
NM      := $(CROSS_PREFIX)nm
STRIP   := $(CROSS_PREFIX)strip

override CFLAGS += \
    -m32 \
    -march=i686 \
    -mno-mmx \
    -mno-sse \
    -mno-sse2 \
    -mno-80387 \
    -ffreestanding \
    -fno-stack-protector \
    -fno-pic \
    -fno-pie

override LDFLAGS += \
    -m elf_i386 \
    -z noexecstack

ASM_FORMAT := elf32

LINKER_SCRIPT := linker/i686.ld
