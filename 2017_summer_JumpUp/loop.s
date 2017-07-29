section .data
	count dd 0
	lf db 10
	temp dd 0

section .text
	global _start

_start:
	mov ecx, 9

loop_func:
	mov [temp], ecx
	
	mov eax, ecx
	add eax, '0'
	mov [count], eax
	
	mov eax, 4
	mov ebx, 1
	mov ecx, count
	mov edx, 1
	int 80h

	mov eax, 4
 	mov ebx, 1
	mov ecx, lf
	mov edx, 1
	int 80h

	mov ecx, [temp]
	loop loop_func
	
	mov eax, 1
	mov ebx, 0
	int 80h

