_strlen: 
    push bp
    mov bp, sp
    
    mov bx, word ptr [bp + arg1] 
    xor ax, ax ; счётчик (ax)

lencyc:    
    cmp byte ptr [bx], 0
    je lenret
    inc ax
    inc bx
    jmp lencyc
    
lenret:    
    mov sp, bp
    pop bp
    ret
	
_getstr:
    push bp
    mov bp, sp
    
    ; чтение строки
    mov cx, word ptr [bp + arg2]
    mov dx, word ptr [bp + arg1]
    mov ah, 3fh
    mov bx, 0
    int 21h
    
    ; добавление в конец завершающего нуля
    mov bx, word ptr [bp + arg1]
    add bx, ax ; добавляем к адресу начала строки длину считанной строки
    sub bx, 2 ; убираем из строки возврат каретки (\r) и перевод строки (\n)
    mov byte ptr [bx], 0
	sub ax, 2
	mov word ptr [bp + arg2], ax
    mov sp, bp
    pop bp
    ret
	
output_str:
	push bp
    mov bp, sp
	
	mov ah, 40h
	mov bx, 1
	mov cx, [bp + arg2]
	mov dx, [bp + arg1]
	int 21h
	
	mov sp, bp
    pop bp
    ret

_parse_nums_op:
	push bp
    mov bp, sp
	
	mov bx, [bp + arg1]
	mov si, [bp + arg4]
	dec bx
	dec si
	cycle_parse_f:
		inc bx
		inc si
		cmp byte ptr[bx], " "
		je br_cycle_parse_f
		mov dl, byte ptr[bx]
		mov byte ptr[si], dl
		jmp cycle_parse_f
	br_cycle_parse_f:
	mov byte ptr[si], 0
	parse_sign:
		mov si, [bp + arg2]
		inc bx
		mov dl, byte ptr[bx]
		mov byte ptr[si], dl
	
	mov si, [bp + arg3]
	dec si
	inc bx
	cycle_parse_s:
		inc bx
		inc si
		cmp byte ptr[bx], 0
		je br_cycle_parse_s
		mov dl, byte ptr [bx]
		mov byte ptr[si], dl
		jmp cycle_parse_s
	br_cycle_parse_s:
	mov byte ptr[si], 0
	mov sp, bp
    pop bp
    ret