[ORG 0x7c00]

start:
	xor ax, ax
	mov ds, ax

	; Print a message
	mov si, init_msg
	call print

	; Enable A20
	call a20

hang:
	jmp hang

init_msg db "Loading Modulus...", 13, 10, 0

%include "print.asm"
%include "a20.asm"

sig:
	times 510-($-$$) db 0
	db 0x55
	db 0xaa
