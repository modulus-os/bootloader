%include "print.asm"
%include "a20.asm"
%include "gdt.asm"

main:
	cli

	mov ax, 0x07c0
	mov ds, ax

	; Print a message
	mov si, init_msg
	call print

	; Enable A20
	call a20

	; Load GDT
	call load_gdt

;	ret
.hang:
	jmp .hang

init_msg db " * Modulus Bootloader * ", 13, 10, 0

sig2:
	times (512 * 3 - 2)-($-$$) db 0
	db 0x55
	db 0xaa
