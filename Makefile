BUILD = build
SRC = src
ASRC = $(wildcard $(SRC)/*.asm)
NASM = nasm -f bin

qemu: $(BUILD)/bootloader.bin
	qemu-system-x86_64 -hda $(BUILD)/bootloader.bin

$(BUILD)/bootloader.bin: $(wildcard $(SRC)/*.asm) $(BUILD)
	cd $(SRC) && $(NASM) boot.asm -o ../$(BUILD)/bootloader.bin

$(BUILD):
	mkdir -p $(BUILD)
