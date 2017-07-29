section .data
	msg1 db 'input name : '
	msg1_len equ $-msg1
	msg2 db 'Your name : '
	msg2_len equ $-msg2

section .bss
	name resb 10

section .text
	global _start

_start:	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, name
	mov edx, 10
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov eax, 4
	mov ebx, 0
	mov ecx, name
	mov edx, 10
	int 80h

	mov eax, 1
	mov ebx, 0
	int 80h

