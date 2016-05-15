load_gdt:
	lgdt [gdt]
	ret

gdt:
	; Null descriptor
	dq 0
	; Code selector
	dd 0xffffffff
	dw 0
	dd 0x9a
	; Data selector
	dd 0xffffffff
	dw 0
	dd 0x9a
gdtr:
	dd $ - gdt - 1
	dw gdt
