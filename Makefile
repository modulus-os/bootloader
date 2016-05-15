BUILD = build
SRC = src
ASRC = $(wildcard $(SRC)/*.asm)
NASM = nasm -f bin

qemu: $(BUILD)/bootloader.bin
	qemu-system-x86_64 -hda $(BUILD)/bootloader.bin -no-reboot -d int

bochs: $(BUILD)/bootloader.bin bochs.x86_64
	bochs -f bochs.x86_64 -q

$(BUILD)/bootloader.bin: $(wildcard $(SRC)/*.asm) $(BUILD)
	cd $(SRC) && $(NASM) init.asm -o ../$(BUILD)/bootloader.bin

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)
