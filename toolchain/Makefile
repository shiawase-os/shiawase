ARCH ?= x86-64

ifeq ($(ARCH),amd64)
	TOOLCHAIN_ARCH := x86-64
	TOOLCHAIN_PREFIX := x86_64-buildroot-linux-gnu
else ifeq ($(ARCH),i686)
	TOOLCHAIN_ARCH := x86-i686
	TOOLCHAIN_PREFIX := i686-buildroot-linux-gnu
else
	TOOLCHAIN_ARCH := $(ARCH)
	TOOLCHAIN_PREFIX := $(ARCH)-buildroot-linux-gnu
endif

TOOLCHAIN_VERSION := stable-2026.08-1
TOOLCHAIN_NAME := $(TOOLCHAIN_ARCH)--glibc--$(TOOLCHAIN_VERSION)

TOOLCHAIN_URL := https://toolchains.bootlin.com/downloads/releases/toolchains/$(TOOLCHAIN_ARCH)/tarballs/$(TOOLCHAIN_NAME).tar.xz
CHECKSUM_URL := https://toolchains.bootlin.com/downloads/releases/toolchains/$(TOOLCHAIN_ARCH)/tarballs/$(TOOLCHAIN_NAME).sha256

DOWNLOAD_DIR := $(CURDIR)/download/$(ARCH)

TARGET_TOOLCHAIN := $(DOWNLOAD_DIR)/$(TOOLCHAIN_NAME).tar.xz
TARGET_CHECKSUM := $(DOWNLOAD_DIR)/$(TOOLCHAIN_NAME).sha256

EXTRACT_DIR := $(CURDIR)/extracted/$(ARCH)

ROOT_DIR := $(CURDIR)/root
ROOT_BIN := $(ROOT_DIR)/bin

.PHONY: all
all: info

.PHONY: info
info: root
	@echo ""
	@echo "$(ARCH) toolchain installed at $(ROOT_BIN), run 'export PATH=\"$PATH:$(ROOT_BIN)\"' to add the executables to your path"


.PHONY: download
download:
	@mkdir -p $(DOWNLOAD_DIR)
	wget -O $(TARGET_TOOLCHAIN) $(TOOLCHAIN_URL)
	wget -O $(TARGET_CHECKSUM) $(CHECKSUM_URL)

.PHONY: check
check: download
	cd $(DOWNLOAD_DIR) && sha256sum -c $(TARGET_CHECKSUM)

.PHONY: extract
extract: check
	@mkdir -p $(EXTRACT_DIR)
	tar -xf $(TARGET_TOOLCHAIN) -C $(EXTRACT_DIR) --strip-components=1

.PHONY: root
root: extract
	@mkdir -p $(ROOT_BIN)
	@for file in $(EXTRACT_DIR)/bin/$(TOOLCHAIN_PREFIX)-*; do \
		if [ -f "$$file" ] && [ ! -L "$$file" ]; then \
			name=$$(basename "$$file"); \
			app=$${name#$(TOOLCHAIN_PREFIX)-}; \
			# Strip .br_real if present to form the clean command name \
			clean_app=$${app%.br_real}; \
			echo '#!/bin/sh' > "$(ROOT_BIN)/$(ARCH)-shiawase-$$clean_app"; \
			echo 'exec "'$$file'" "$$@"' >> "$(ROOT_BIN)/$(ARCH)-shiawase-$$clean_app"; \
			chmod +x "$(ROOT_BIN)/$(ARCH)-shiawase-$$clean_app"; \
		fi \
	done

.PHONY: clean
clean:
	rm -rf download/
	rm -rf extracted/
	rm -rf root/
