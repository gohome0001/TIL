section .data
	result db 4

section .text
	global _start

_start:
	mov al, 2
	mov bl, 4
	mul bl

	add ax , '0'
	mov [result], ax

	mov eax, 4
	mov edx, 1
	mov ecx, result
	mov edx, 1
	int 80h

	mov eax, 1
	mov ebx, 0
	int 80h
