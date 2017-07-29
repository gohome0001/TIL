section .bss
	num resb 4

section .text	
	global _start

_start:
	xor eax, eax
	add eax, 4
	add eax, '0'
	add eax, 00000a00h
	mov [num], eax

	mov eax, 4
	mov ebx, 2
	mov ecx, num
	mov edx, 1
	int 80h

	mov eax, 1
	mov ebx, 0
	int 80h
