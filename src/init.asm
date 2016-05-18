; init.asm
;
; Stage one of bootloader; loads second stage

bits 16

org 0x7c00

sec_count equ 2
ss_sector equ 1

start:
	cli

	xor ax, ax
	mov ds, ax

	; Check for INT 0x13 extensions
	mov ah, 0x41
	mov bx, 0x55aa
	mov dl, 0x80
	int 0x13

	; Load with CHS if not supported
	jc .use_chs

	; Otherwise use LBA
	jmp .use_lba

.use_lba:
	mov si, extensions_supported
	call print16

	jmp load_ss_lba

.use_chs:
	mov si, no_extensions
	call print16

	jmp load_ss_chs

.hang:
	hlt
	jmp .hang

; BIOS print
print16:
	lodsb
	or al, al
	jz .return
	mov ah, 0x0E
	int 0x10
	jmp print16
.return:
	ret

load_ss_chs:
	; Get drive geometry
	mov ah, 8
	mov dl, 0x80
	int 0x13
	inc dh
	and cl, 0x3f

	; Convert LBA to CHS
	mov ax, ss_sector
	div cl
	mov [chs.temp], al

	mov ax, ss_sector
	div cl
	inc ah
	mov [chs.sector], ah

	mov ax, [chs.temp]
	div dh
	mov [chs.head], ah

	mov ax, [chs.temp]
	div dh
	mov [chs.cylinder], al

	; Load second stage w/ CHS
	mov ah, 2
	mov al, sec_count

	and word [chs.cylinder], 0xff
	mov ch, [chs.cylinder]

	shr word [chs.cylinder], 2
	and word [chs.cylinder], 0xc0
	mov ax, word [chs.cylinder]
	or word [chs.sector], ax
	mov cl, [chs.sector]

	mov dh, 0

	mov ax, 0x07c0
	mov es, ax
	mov bx, 512
	mov dl, 0x80
	int 0x13

	jmp jump

load_ss_lba:
	; Load second stage w/ LBA
	mov si, da_pack
	mov ah, 0x42
	mov dl, 0x80
	int 0x13

	jmp jump

; Disk data packet
da_pack:
	db 0x10
	db 0
block_count:
	dw sec_count
address:
	dw 0x7c00 + 512
	dw 0
lba:
	dd ss_sector
	dd 0

; CHS structure
chs:
.cylinder: dw 0
.head: dw 0
.sector: dw 0
.temp: dw 0

jump:
	mov ax, 0
	mov ds, ax

	; Jump to second stage
	jmp main

extensions_supported db "INT 0x13 extensions supported...", 13, 10, 0
no_extensions db "INT 0x13 extensions not supported, using CHS...", 13, 10, 0

; Fill up rest of sector and add boot signature
	times 510-($-$$) db 0
	db 0x55
	db 0xaa

; Second stage of boot loader
%include "main.asm"
