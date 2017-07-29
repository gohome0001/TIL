section .data
	howto db 'input two SMALL integer', 10, 0
	howto_s equ $-howto

	r_add db 10, 'add result : ', 0
	r_sub db 10, 'sub result : ', 0
	r_mul db 10, 'mul result : ', 0
	r_div1 db 10, 'div result : ', 0
	r_div2 db 10, '>>> leftover ', 0
	r_msg_s equ $-r_div2

	in_s equ 2
	out_s equ 1

	end db 10, '---------------------', 10, 0
	end_s equ $-end
	
section .bss
	x1 resb 2
	x2 resb 2
	result resb 2

section .code
	global _start

_start:
	mov edi, howto
	mov esi, howto_s
	call print
	
	mov eax, 3
	mov ebx, 0
	mov ecx, x1
	mov edx, in_s
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, x2
	mov edx, in_s
	int 80h

	mov ax, [x1]
	mov bx, [x2]
	and ax, 255
	and bx, 255
	mov [x1], ax
	mov [x2], bx

	mov ax, [x1]
	mov bx, [x2]

	sub bx, '0'
	add ax, bx	; add
	mov [result], ax	
	
	mov edi, r_add
	mov esi, r_msg_s	
	call print
	
	mov edi, result
	mov esi, out_s
	call print

	mov ax, [x1]
	mov bx, [x2]
 	sub bx, '0'
	sub ax, bx	; sub
	mov [result], ax
	
	mov edi, r_sub
	mov esi, r_msg_s
	call print
	
	mov edi, result
	mov esi, out_s
	call print

	mov ax, [x1]
	mov bx, [x2]	
	sub ax, '0'
	sub bx, '0'
	mul bx		; mul
	add ax, '0'
	mov [result], ax
	
	mov edi, r_mul
	mov esi, r_msg_s
	call print
	
	mov edi, result
	mov esi, out_s
	call print

	xor eax, eax
	xor edx, edx
	mov ax, [x1]
	mov bx, [x2]
	sub ax, '0'	
	sub bx, '0'
	div bx		; mul
	add ax, '0'
	mov [result], ax
	add dx, '0'
	mov [x1], dx

	mov edi, r_div1
	mov esi, r_msg_s
	call print
	
	mov edi, result
	mov esi, out_s
	call print
	
	mov edi, r_div2
	mov esi, r_msg_s
	call print
	
	mov edi, x1
	mov esi, out_s
	call print

	mov edi, end
	mov esi, end_s
	call print
	
	mov eax, 1
	mov ebx, 0
	int 80h
	
	
print:
	push ebp
	mov ebp, esp

	mov eax, 4
	mov ebx, 1
	mov ecx, edi
	mov edx, esi
	int 80h
	leave
	ret

