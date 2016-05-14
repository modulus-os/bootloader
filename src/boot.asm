[ORG 0x7c00]

start:
	xor ax, ax
	mov ds, ax

	mov si, init_msg
	call print

hang:
	jmp hang

init_msg db "Loading Modulus", 13, 10, 0

%include "print.asm"

sig:
	times 510-($-$$) db 0
	db 0x55
	db 0xaa
