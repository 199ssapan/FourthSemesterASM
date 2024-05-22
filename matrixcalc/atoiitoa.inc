_itoa:
	push bp
    mov bp, sp
	mov ax, [bp + arg1]
	mov bx, [bp + arg2]
	mov si, [bp + arg3]
	mov byte ptr[bx + si], 0
    cycle_itoa:
		xor dx, dx
		dec si
		cmp si, 0
		jl break_itoa
		mov cx, 10
		div cx
		add dl, 30h ; 5 -> "5"
		mov byte ptr[bx + si], dl ; str[si] = (char)dl
		jmp cycle_itoa
	break_itoa:	
	mov sp, bp
    pop bp
    ret
	
get_len:
	push bp
	mov bp, sp
	mov ax, [bp + arg1]
	mov si, 1
	cycle2:
		xor dx, dx
		mov cx, ax
		mov di, 10
		div di
		cmp ax, 0
		je br2
		inc si
		jmp cycle2
	br2:
	mov ax, si
	mov sp, bp
    pop bp
    ret