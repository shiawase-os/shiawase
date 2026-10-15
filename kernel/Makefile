ARCH ?= amd64
BUILD_DIR ?= build/$(ARCH)

include mk/$(ARCH).mk

SOURCE_DIR := src
ARCH_DIR := arch/$(ARCH)
INCLUDE_DIR := include
MODULES_DIR := modules

KERNEL := $(BUILD_DIR)/tsunami

C_SRCS   := $(shell find $(SOURCE_DIR) $(ARCH_DIR) -type f -name '*.c' 2>/dev/null)
S_SRCS   := $(shell find $(SOURCE_DIR) $(ARCH_DIR) -type f -name '*.S' 2>/dev/null)
ASM_SRCS := $(shell find $(SOURCE_DIR) $(ARCH_DIR) -type f -name '*.asm' 2>/dev/null)

OBJS := $(sort $(patsubst %, $(BUILD_DIR)/%.o, $(C_SRCS) $(S_SRCS) $(ASM_SRCS)))

DEPS := $(OBJS:.o=.d)

INCLUDES := -I$(INCLUDE_DIR) -I$(SOURCE_DIR) -I$(ARCH_DIR)

.PHONY: all clean

all: $(KERNEL)

# Link final kernel ELF binary
$(KERNEL): $(OBJS)
	@mkdir -p $(dir $@)
	@echo "  LD      $@"
	@$(LD) $(LDFLAGS) -T $(LINKER_SCRIPT) $(OBJS) -o $@

# Compile C source files (*.c -> *.c.o)
$(BUILD_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	@echo "  CC      $<"
	@$(CC) $(CFLAGS) $(INCLUDES) -MMD -MP -c $< -o $@

# Assemble GNU assembly files (*.S -> *.S.o)
$(BUILD_DIR)/%.S.o: %.S
	@mkdir -p $(dir $@)
	@echo "  CC (AS) $<"
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Assemble NASM assembly files (*.asm -> *.asm.o)
$(BUILD_DIR)/%.asm.o: %.asm
	@mkdir -p $(dir $@)
	@echo "  NASM    $<"
	@nasm -f $(ASM_FORMAT) $< -o $@

clean:
	@echo "  CLEAN"
	@rm -rf build/
	@rm -rf *.iso

-include $(DEPS)
