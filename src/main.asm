%include "print.asm"
%include "a20.asm"
%include "gdt.asm"

main:
	xor ax, ax
	mov ds, ax

	; Print a message
	mov si, init_msg
	call print

	; Load GDT
	call load_gdt

	; Enable A20
	call a20

	; Switch to protected mode
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	jmp 0x08:pmode

init_msg db " * Modulus Bootloader * ", 13, 10, 0

%include "pmode.asm"

; Fill rest of sector(s)
	times (512 * 3)-($-$$) db 0
