PYTHON := python3
CA65 := ca65
LD65 := ld65
OD65 := od65

BUILD_DIR := build
GEN_DIR := $(BUILD_DIR)/generated
OBJ_DIR := $(BUILD_DIR)/obj
ROM := $(BUILD_DIR)/game.nes

SRC := $(shell find src -name '*.s' | sort)
OBJ := $(patsubst src/%.s,$(OBJ_DIR)/%.o,$(SRC))

.PHONY: all toolcheck assets rom validate smoke clean

all: rom

toolcheck:
	@command -v $(PYTHON) >/dev/null || (echo "python3 not found" && exit 1)
	@command -v $(CA65) >/dev/null || (echo "ca65 not found" && exit 1)
	@command -v $(LD65) >/dev/null || (echo "ld65 not found" && exit 1)

assets: toolcheck
	@mkdir -p $(GEN_DIR)
	$(PYTHON) tools/build_assets.py

rom: assets $(ROM)

validate: rom
	$(PYTHON) tools/validate_rom.py $(ROM)

smoke: rom
	$(PYTHON) tools/smoke.py $(ROM)

$(ROM): $(OBJ)
	$(LD65) -C src/nes.cfg -o $@ $(OBJ)

$(OBJ_DIR)/%.o: src/%.s
	@mkdir -p $(dir $@)
	$(CA65) -t nes -I src -I $(GEN_DIR) -o $@ $<

clean:
	rm -rf $(BUILD_DIR)
