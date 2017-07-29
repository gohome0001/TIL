section .data
	num db 7	
	true db 'T'

section .text	
	global _start
	
_start:
	mov al, [num]
	
	cmp al, 7
	je yes
exit:
	mov eax, 1
	mov ebx, 0
	int 80h

yes:
	mov al, [num]
	mov al, '0'
	mov [num], al
	
	mov eax, 4
	mov ebx, 1
	mov ecx, true
	mov edx, 1
	int 80h
	jmp exit
	
