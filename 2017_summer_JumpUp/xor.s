section .data
	x db 7
	y db 5
	lf db 10

section .text
	global _start

_start:
	mov al, [x]
	mov bl, [y]
	
	xor al, bl
	xor bl, al
	xor al, bl
	
	add al, '0'
	add bl, '0'
	
	mov [x], al
	mov [y], bl
	
	mov eax, 4
	mov ebx, 1
	mov ecx, x
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
 	mov ecx, lf
	mov edx, 1
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, y
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
 	mov ecx, lf
	mov edx, 1
	int 80h
	
	mov eax, 1
	mov ebx, 0	
	int 80h
