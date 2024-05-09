_check: 
    push bp
    mov bp, sp
	
	push [bp + arg1]
	call _check_spaces
	add sp, 2
	
    mov sp, bp
    pop bp
    ret

_check_spaces:
	nop
    push bp
    mov bp, sp
	
	mov bx, [bp + arg1]
	
	dec bx
	cyc_check_spaces:
		inc bx
		cmp byte ptr[bx], 0
		je cs_ret
		cmp byte ptr[bx], " "
		je space
		xor si, si
		jmp cyc_check_spaces
		space:
			inc si
			cmp si, 2
			je exit_e
			jmp cyc_check_spaces
		jmp cyc_check_spaces
	cs_ret:
    mov sp, bp
    pop bp
    ret

check_op:
	push bp
    mov bp, sp
	mov bx, [bp + arg1]
	cmp byte ptr[bx], "+"
	je ret_check_op
	cmp byte ptr[bx], "-"
	je ret_check_op
	cmp byte ptr[bx], "*"
	je ret_check_op
	cmp byte ptr[bx], "/"
	je ret_check_op
	cmp byte ptr[bx], "%"
	je ret_check_op
	jmp exit_e
	ret_check_op:
	mov sp, bp
    pop bp
    ret
	
check_num:
	push bp
    mov bp, sp
	
	xor dx, dx
	mov di, [bp + arg1]
	mov bx, [bp + arg2]
	mov si, [bp + arg3]
	mov byte ptr[si], "+"
	cmp byte ptr[di],"-"
	jne no_change
	mov si, [bp + arg3]
	mov byte ptr[si], "-"
	inc di
	no_change:
	
	dec di
	cyc_cn:
		inc di
		cmp byte ptr[di], 0
		je ret_ok
		mov dl, byte ptr[di]
		xor si, si
		dec si
		cyc_in:
			inc si
			cmp si, [alpha_len]
			je exit_e
			cmp dl, byte ptr[bx + si]
			je cyc_cn
			jmp cyc_in
		jmp cyc_cn
	ret_ok:
	mov sp, bp
    pop bp
    ret