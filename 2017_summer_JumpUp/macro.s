%macro mywrite 2
	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, %2
	int 80h

%endmacro

section .data
	str: db 'abcdef', 10
	str_len: equ $-str

section .text
	global _start

_start:
	mywrite str, str_len
	mov eax, 1
	mov ebx, 0
	int 80h
