section .data
	
	str: db 'ABCDEF'
	str_len equ $-str
	lf db 10
	temp dd 0

section .text
	global _start

_start:
	mov ecx, str_len

loop_func:
	mov [temp], ecx
	mov eax, str_len
	sub eax, ecx
	
	lea ecx, [str+eax]

	mov eax, 4
	mov ebx, 1
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
