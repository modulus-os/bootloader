; init.asm
;
; Stage one of bootloader; loads second stage

start:
	cli

	mov ax, 0x07c0
	mov ds, ax

	; Load second stage
	mov si, da_pack
	mov ah, 0x42
	mov dl, 0x80
	int 0x13

	mov ax, 0
	mov ds, ax

	; Jump to second stage
	jmp main

.hang:
	jmp .hang

da_pack:
	db 0x10
	db 0
block_count:
	dw 16
address:
	dw 0x7c00 + 512
	dw 0
lba:
	dd 1
	dd 0

; Fill up rest of sector
sig:
	times 510-($-$$) db 0
	db 0x55
	db 0xaa

; Second stage of boot loader
%include "main.asm"
