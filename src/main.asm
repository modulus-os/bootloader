%include "a20.asm"
%include "gdt.asm"

main:
	xor ax, ax
	mov ds, ax

	mov si, msg_title
	call print16

	; Enable A20
	call a20
	
	; Load GDT
	call load_gdt

	; Switch to protected mode
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	jmp 0x08:pmode


msg_title db " * Modulus Bootloader * ", 13, 10, 0

%include "pmode.asm"

; Fill rest of sector
	times (512 - (($-$$) % 512)) db 0
