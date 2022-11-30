# File paths
SRC_DIR := ./src
BUILD_DIR := ./build
OBJ_DIR := $(BUILD_DIR)

# Compilation flags
AS := riscv32-unknown-elf-as
DUMP := riscv32-unknown-elf-objdump
COPY := riscv32-unknown-elf-objcopy
CFLAGS := -march=rv32i -mabi=ilp32
DUMPFLAGS := -D
VCOPYFLAGS := -O verilog

# Files to be compiled
SRCS := $(wildcard $(SRC_DIR)/*.asm)
OBJS := $(SRCS:$(SRC_DIR)/%.asm=$(OBJ_DIR)/%.o)
DUMPS := $(OBJS:$(OBJ_DIR)/%.o=$(BUILD_DIR)/%.dump)
VCOPYS := $(OBJS:$(OBJ_DIR)/%.o=$(BUILD_DIR)/%.hex)

# Don't remove *.o files automatically
.SECONDARY: $(OBJS)

all: $(OBJS) $(DUMPS) $(VCOPYS)

# Compile each *.c file as *.o files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm 
	@echo + AS $< $@
	@mkdir -p $(OBJ_DIR)
	@$(AS) $(CFLAGS) -c -o $@ $<
	
# Link each *.o file as executable files
$(BUILD_DIR)/%.dump: $(OBJ_DIR)/%.o
	@echo + DUMP $< $@
	@mkdir -p $(BUILD_DIR)
	@$(DUMP) $(DUMPFLAGS) $< > $@
	
$(BUILD_DIR)/%.hex: $(OBJ_DIR)/%.o
	@echo + COPY $< $@
	@mkdir -p $(BUILD_DIR)
	@$(COPY) $(VCOPYFLAGS) $< $@

.PHONY: all clean

clean:
	rm -rf $(BUILD_DIR)
