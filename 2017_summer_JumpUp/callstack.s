section .data
	msg: db 'func', 10
	msg_len: equ $-msg

section .text
	global _start

_start:
	call func
	
	mov eax, 1
	mov ebx, 0
	int 80h

func:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, msg_len
	int 80h
	ret
