top="."
out="build"

def configure(cfg):
	cfg.find_program("nasm", VAR="NASM")

	cfg.env.NASM_FLAGS = "-f bin -i../src/"
	cfg.env.ASM_MAIN = "../src/init.asm"

def options(opt):
	opt.add_option("-q", "--qemu", dest="qemu", default=False, action="store_true", help="Run in QEMU")
	opt.add_option("-b", "--bochs", dest="bochs", default=False, action="store_true", help="Run in Bochs")

def build(bld):
	bld(rule="${NASM} ${NASM_FLAGS} ${ASM_MAIN} -o bootloader.bin",
		source=bld.path.ant_glob("src/*.asm"),
		target="bootloader.bin")

	if (bld.options.qemu and bld.options.bochs):
		print("Error: Both QEMU and Bochs selected")
	elif (bld.options.qemu):
		bld(rule="qemu-system-x86_64 -hda bootloader.bin -d int", always=True)
	elif (bld.options.bochs):
		bld(rule="pwd")
		bld(rule="bochs -f ../bochs.x86_64 -q", always=True)
