a20:
	call check_a20

	cmp ax, 1
	jz .enabled
	jmp .enable_bios

.enabled:
	mov si, a20_enabled
	call print16
	ret

.enable_bios:
	mov si, a20_disabled_0
	call print16

	mov ax, 0x2401
	int 0x15

	call check_a20

	cmp ax, 1
	jz .enabled
	jmp .enable_kb

	ret

.enable_kb:
	mov si, a20_disabled_1
	call print16

	call enable_a20_kb

	call check_a20

	cmp ax, 1
	jz .enabled
	jmp .enable_fast

	ret

.enable_fast:
	mov si, a20_disabled_2
	call print16

	in al, 0x92
	or al, 2
	out 0x92, al

	call check_a20

	cmp ax, 1
	jz .enabled
	jmp .failed

	ret

.failed:
	mov si, a20_disabled_3
	call print16

	hlt
	jmp .failed

; Check A20 function from wiki.osdev.org/A20Line
check_a20:
	pushf
	push ds
	push es
	push di
	push si

	cli

	xor ax, ax
	mov es, ax

	not ax
	mov ds, ax

	mov di, 0x0500
	mov si, 0x0510

	mov al, byte [es:di]
	push ax

	mov al, byte [ds:si]
	push ax

	mov byte [es:di], 0x00
	mov byte [ds:si], 0xFF

	cmp byte [es:di], 0xFF

	pop ax
	mov byte [ds:si], al

	pop ax
	mov byte [es:di], al

	mov ax, 0
	je check_a20__exit

	mov ax, 1

check_a20__exit:
	pop si
	pop di
	pop es
	pop ds
	popf

	ret

; Enable A20 with 8042 keyboard controller from wiki.osdev.org/A20Line
enable_a20_kb:
	cli

	call enable_a20_kb_wait
	mov al, 0xad
	out 0x64, al

	call enable_a20_kb_wait
	mov al, 0xd0
	out 0x64, al

	call enable_a20_kb_wait2
	in al, 0x60

  call enable_a20_kb_wait
  mov al, 0xd1
  out 0x64, al

	call enable_a20_kb_wait
	or al, 2
	out 0x60, al

	call enable_a20_kb_wait
	mov al, 0xae
	out 0x64, al

	call enable_a20_kb_wait
	sti
	ret

enable_a20_kb_wait:
	in al, 0x64
	test al, 2
	jnz enable_a20_kb_wait
	ret

enable_a20_kb_wait2:
	in al, 0x64
	test al, 1
	jz enable_a20_kb_wait2
	ret

a20_enabled db "A20 already enabled...", 13, 10, 0
a20_disabled_0 db "A20 disabled, attempting to enable w/ BIOS...", 13, 10, 0
a20_disabled_1 db "A20 disabled, attempting to enable w/ 8042 keyboard controller...", 13, 10, 0
a20_disabled_2 db "A20 disabled, attempting to enable w/ Fast A20 Gate...", 13, 10, 0
a20_disabled_3 db "Boot failed: could not enable A20", 13, 10, 0
