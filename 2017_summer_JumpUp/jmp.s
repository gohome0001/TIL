section .data
	num db 7

section .text
	global _start

_start:
	jmp one
	mov eax, 1
	mov ebx, 0
	int 80

one:
	mov al, [num]
	add al, '0'
	mov [num], al
	
	mov eax, 4
	mov ebx, 1
	mov ecx, num
	mov ebx, 1 
	int 80h	
