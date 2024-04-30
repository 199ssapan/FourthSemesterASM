get_len:
	push bp
	mov bp, sp
	mov ax, [bp + arg1]
	mov si, 1
	cycle2:
		xor dx, dx
		mov cx, ax
		div word ptr[bp + arg2]
		cmp ax, 0
		je br2
		inc si
		jmp cycle2
	br2:
	mov ax, si
	mov sp, bp
    pop bp
    ret

_atoi: 
    push bp
    mov bp, sp
	int 3
	xor cx, cx
	xor dx, dx
	
	mov bx, [bp + arg1]
	push bx
	call _strlen
	add sp, 2
	
	mov bx, [bp + arg1]
	mov si, ax
	
	mov ax, [multiplier]
	cycle_atoi:
		dec si
		cmp si, 0
		jl break_atoi
		cmp byte ptr[bx + si], "-"
		je break_atoi
		xor di, di
		mov dl, byte ptr [bx + si]
		cmp dl, "a"
		jge letter
			sub dx, 30h
			jmp next_h
		letter:
			sub dx, "a"
			add dx, 10
		next_h:
		mul dx
		jo exit_e
		add cx, ax
		cmp cx, 8000h
		je okay
		sub cx, ax
		add cx, ax
		jo exit_e
		okay:
		mov ax, [multiplier] ; ax *= mult
		mul word ptr[bp + arg2]
		mov [multiplier], ax
		
		jmp cycle_atoi
	break_atoi:
	mov [multiplier], 1
	mov di, cx
	mov ax, di
	mov sp, bp
    pop bp
    ret
_itoa:
	push bp
    mov bp, sp
	mov ax, [bp + arg1]
	mov bx, [bp + arg2]
	mov si, [bp + arg3]
    cycle_itoa:
		xor dx, dx
		dec si
		cmp si, 0
		jl break_itoa
		div word ptr[bp + arg4]
		cmp dl, 10
		jae hitoa
		add dl, 30h ; 5 -> "5"
		jmp next_it
		hitoa:
			add dx, "a"
			sub dx, 10
		next_it:
		mov byte ptr[bx + si], dl ; str[si] = (char)dl
		
		jmp cycle_itoa
	break_itoa:	
	mov sp, bp
    pop bp
    ret

