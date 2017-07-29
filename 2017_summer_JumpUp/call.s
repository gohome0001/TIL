section .data
	result dd 0
	lf db 10

section .text
	global _start

_start:
	mov eax, 2
	mov ebx, 4
	
	call add_func	
	call print

	mov ebx, 3
	
	call add_func
	call print
	
	mov eax, 1
	mov ebx, 0
	int 80h

add_func:
	add eax, ebx
	ret

print:
	add eax, '0'
	mov [result], eax

	mov eax, 4
	mov ebx, 1
	mov ecx, result
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, lf
	mov edx, 1
	int 80h

	mov eax, [result]
	sub eax, '0'	
	ret
 
