ARCH ?= amd64

KERNEL_NAME := tsunami
KERNEL_PATH := kernel/build/$(ARCH)/$(KERNEL_NAME)

TOOLCHAIN_ROOT := $(realpath toolchain/root)
TOOLCHAIN_BIN := $(TOOLCHAIN_ROOT)/bin
TOOLCHAIN_STAMP := $(TOOLCHAIN_ROOT)/.installed-$(ARCH)

ISO_NAME := shiawase-$(ARCH)
ISO_PATH := ./$(ISO_NAME).iso

ISO_DIR := build/iso/$(ARCH)
ISO_BOOT_DIR := $(ISO_DIR)/boot
ISO_GRUB_DIR := $(ISO_BOOT_DIR)/grub

GRUB_CONFIG_PATH := config/$(ARCH)/grub.cfg

export PATH := $(TOOLCHAIN_BIN):$(PATH)

.PHONY: all kernel toolchain iso clean run

all: iso

kernel: toolchain
	@$(MAKE) -C kernel ARCH=$(ARCH) PATH="$(PATH)"

toolchain: $(TOOLCHAIN_STAMP)

$(TOOLCHAIN_STAMP):
	@$(MAKE) -C toolchain root ARCH=$(ARCH)
	@touch $@

iso: kernel
	@rm -rf $(ISO_DIR)
	@mkdir -p $(ISO_GRUB_DIR)
	@cp $(KERNEL_PATH) $(ISO_BOOT_DIR)/$(KERNEL_NAME)
	@cp $(GRUB_CONFIG_PATH) $(ISO_GRUB_DIR)/grub.cfg
	@echo "  GRUB"
	@grub-mkrescue -o $(ISO_PATH) $(ISO_DIR)

run: iso
	@echo "  QEMU $(if $(filter amd64,$(ARCH)),x86_64,i386)"
	@qemu-system-$(if $(filter amd64,$(ARCH)),x86_64,i386) \
		-cdrom $(ISO_PATH) \
		-boot order=d \
		-no-reboot \
		-no-shutdown \
		-d int,cpu_reset \
		-D qemu.log \
		-debugcon stdio

clean:
	@$(MAKE) -C kernel clean
	@rm -rf build/
	@rm -rf *.iso
