section .data
	str: db 'ABCD', 10, 0
	str_len: equ $-str

section .code
	global _start

_start:
	push point
	jmp func
point:
	mov eax, 1
	mov ebx, 0
	int 80h

func:
	mov eax, 4
	mov ebx, 1
	mov ecx, str
	mov edx, str_len
	int 80h
	
	pop edi
	jmp edi
