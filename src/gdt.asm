load_gdt:
	lgdt [gdtr]

	ret

gdt_start:
	; Null descriptor
	dw 0
	dw 0
	dw 0
	dw 0
	; Code descriptor
	dw 0xffff ; Limit 0-15
	dw 0 ; Base 0 - 15
	db 0 ; Base 16 - 23s
	db 0b10011010 ; Access/Type byte
	db 0b11001111; Limit & flags
	db 0 ; Base 24 - 31
	; Data descriptor
	dw 0xffff ; Limit 0-15
	dw 0 ; Base 0 - 15
	db 0 ; Base 16 - 23
	db 0b10010010 ; Access/Type byte
	db 0b11001111; Limit & flags
	db 0 ; Base 24 - 31

gdt_end:

gdtr:
	dw gdt_end - gdt_start - 1
	dd gdt_start
