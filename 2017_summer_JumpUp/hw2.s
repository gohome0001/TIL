section .data
	helloworld: db 'Hello, World!\n', 10
	helloLen : equ $-helloworld

section .text
	global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, helloworld
	mov edx, helloLen
	int 80h

	mov eax, 1
	mov ebx, 1
	int 80h
