section .bss
	num resb 2
	r resb 2 

section .code
	global _start

_start:
	mov ax, ffffh
	mov dx, 12ffh
	mov bx, fffh
	div bx

	mov [num], ax
	mov [r], dx

	mov eax, 1
	mov ebx, 0
	int 80h
