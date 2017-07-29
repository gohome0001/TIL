section .text
	global _start
	
_start:
	jmp input_hello

main:
	mov al, 4
	mov bl, 1
	pop ecx
	mov dl, 14
	int 80h

	mov al, 1
	int 80h

input_hello:
	call main
	db 'Hello, World!', 10
