section .data
	num db 7

section .text
	global _start

_start:
 	mov al, [num]
	and al, 1h
	add al, '0'
	mov [num], al
	
	mov eax, 4
	mov ebx, 1
	mov ecx, num	
	mov edx, 1
	int 80h
	
	mov eax, 1
	mov ebx, 0
	int 80h
