section .data
	count db 0

section .text
	global _start

_start:
	mov al, [count]
	inc al
	inc al

	add al, '0'
	mov [count], al

	call print	

	mov al, [count]
	mov ebx, 10
	mov [count], ebx
	
	call print

	dec al
	mov [count], al

	call print

	mov ebx, 10
	mov [count], ebx
	
	call print

	mov eax, 1
	mov ebx, 0
	int 80h

print:
	pushad
	mov eax, 4
	mov ebx, 1
	mov ecx, count	
	mov edx, 1
	int 80h
	popad
	ret
