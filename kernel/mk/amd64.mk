ARCH := amd64

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
    -m64 \
    -march=x86-64 \
    -mno-mmx \
    -mno-sse \
    -mno-red-zone \
    -mcmodel=kernel \
    -O0 \
    -g

override LDFLAGS += \
    -m elf_x86_64 \
    -z noexecstack

ASM_FORMAT := elf64

LINKER_SCRIPT := linker/amd64.ld
