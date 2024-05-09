division:
	push bp
    mov bp, sp
	mov ax, [bp + arg1]
	cwd
	cmp word ptr[bp + arg2], 0
	je exit_e
	idiv word ptr[bp + arg2]
	mov sp, bp
    pop bp
    ret
	
multiplication:
	push bp
    mov bp, sp
	mov ax, [bp + arg1]
	imul word ptr[bp + arg2]
	jo exit_e
	mov sp, bp
    pop bp
    ret

addition:
	push bp
    mov bp, sp
	mov ax, [bp + arg1]
	add ax, [bp + arg2]
	jo exit_e
	mov sp, bp
    pop bp
    ret
	
subtraction:
	push bp
    mov bp, sp
	mov ax, [bp + arg1]
	sub ax, [bp + arg2]
	jo exit_e
	mov sp, bp
    pop bp
    ret