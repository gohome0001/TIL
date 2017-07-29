section .data
	helloworld db 'Hello, World!', 10
	sLen equ $-helloworld
	SYS_WRITE equ 4
	STDOUT equ 1
	SYS_EXIT equ 1

section .text
	global _start

_start:
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	lea ecx, helloworld
	mov edx, sLen
	int 80h

	mov eax, SYS_EXIT
	mov ebx, 0
	int 80h
