_calc:
	
	push bp
	mov bp, sp
	sub sp, 2
	cmp byte ptr[bp + arg2], "*"
	jne nomul
	push word ptr[bp + arg1]
	call _mult
	add sp, 2
	jmp end_calc
	nomul:
	mov ax, word ptr[n1]
	cmp ax, word ptr[n2]
	jne _exit255
	mov ax, word ptr[m1]
	cmp ax, word ptr[m2]
	jne _exit255
	mov ax, word ptr[n1]
	mul word ptr [m1]
	mov word ptr[bp + var1], ax
	xor si, si
	mov bx, 0
	mov di, 0
	sub bx, 2
	sub di, 2
	dec si
	cycle_add:
		inc si
		cmp si, word ptr[bp + var1]
		je _exit0
		mov ax, si
		xor dx, dx
		div word ptr[m1]
		cmp dx, 0
		jne no_newline
		cmp si, 0
		je no_newline
		push bx
		mov cx, 2
		mov ah, 40h
		mov bx, [bp + arg1]
		mov dx, offset newline
		int 21h
		pop bx
		
		no_newline:
		push si
		add bx, 2
		add di, 2
		xor ax, ax
		cmp byte ptr [bp + arg2], "+"
		je addit
		cmp byte ptr [bp + arg2], "-"
		je subtract
		subtract:
		mov ax, ds:[bx]
		sub ax, es:[di]
		jmp endop
		addit:
		add ax, ds:[bx]
		add ax, es:[di]
		jmp endop
		endop:
		
		pusha
		
		push word ptr[bp + arg1]
		push ax
		call print_num
		add sp, 4
		
		
		push ax
		
		mov cx, 1
		mov ah, 40h
		mov bx, [bp + arg1]
		mov dx, offset spacebar
		int 21h
		
		pop ax
		
		popa
		pop si
		jmp cycle_add
	end_calc:
	mov sp, bp
	pop bp
	ret
	
_mult:
	push bp
	mov bp, sp
	sub sp, 12
    
	mov ax, word ptr[n1]
    mov word ptr [bp + var1], ax
	mov ax, word ptr[n2]
    mov word ptr [bp + var2], ax
	mov ax, word ptr[m2]
    mov word ptr [bp + var3], ax 
    mov word ptr [bp + var4], 0
    mov word ptr [bp + var5], 0
    mov ax, word ptr[m1]
    mov word ptr [bp + var6], ax

    xor si, si;
    cycle_o:
        mov word ptr[bp + var4], 0;
        cycle_in:
            mov cx, 0; /*sum*/ 
            mov word ptr[bp + var5], 0;
            cycle_inin:

                push si;
                mov di, word ptr[bp + var5];
                add di, di;
                mov ax, word ptr [bp + var6];         
                add si, si;
                mul si;
                add di, ax;
                pop si;

                mov ax, ds:[di];

                push ax;

                mov di, word ptr[bp + var4]
                add di, di
                mov ax, word ptr[bp + var3]
                mov bx, word ptr[bp + var5]
                add bx, bx
                mul bx
                add di, ax

                pop ax;

                mov bx, es:[di]
                mul bx
                add cx, ax
                inc word ptr[bp + var5]
				mov ax, word ptr[bp + var5]
				cmp ax, word ptr[bp + var2]
				jl cycle_inin

		pusha
		mov ax, cx
		mov cx, 30000
		div cx
		push [bp + arg1]
		push dx
		call print_num
		add sp, 4
		popa
      
		pusha
		mov ah, 40h
		mov bx, [bp + arg1]
		mov cx, 1
		mov dx, offset spacebar
		int 21h
		popa

		inc word ptr[bp + var4];
		mov ax, word ptr[bp + var4]
		cmp ax, word ptr[bp + var3]
		jl cycle_in
	pusha 
    mov dx, offset newline
    mov ah, 40h
    mov bx, [bp + arg1]
    mov cx, 2
    int 21h
	popa
    inc si
    cmp si, word ptr[bp + var1]
    jl cycle_o
  
  mov sp, bp
  pop bp
  ret

  
_getdet:
	push bp
	mov bp, sp
	sub sp, 4
	
	xor bx, bx
	xor cx, cx
	
	mov ax, word ptr[n1]
	cmp ax, word ptr[m1]
	jne _exit255
	cmp ax, 1
	je d1
	cmp ax, 2
	je d2
	cmp ax, 3
	je d3
	jmp _exit255
	
	d1:
	mov ax, word ptr[bx]
	
	jmp enddet
	
	d2:
	mov ax, ds:[bx]
	imul word ptr ds:[bx + 6]
	mov word ptr[bp + var1], ax
	mov ax, [bx + 2]
	imul word ptr[bx + 4]
	sub word ptr[bp + var1], ax
	mov ax, word ptr[bp + var1]
	
	jmp enddet
	
	d3:
	mov ax, ds:[bx]
	mov word ptr[bp + var1], 0
	imul word ptr ds:[bx + 8]
	imul word ptr ds:[bx + 16]
	mov cx, ax
	
	mov ax, ds:[bx + 2]
	imul word ptr ds:[bx + 10]
	imul word ptr ds:[bx + 12]
	add cx, ax
	
	mov ax, ds:[bx + 4]
	imul word ptr ds:[bx + 6]
	imul word ptr ds:[bx + 14]
	add cx, ax
	
	mov ax, ds:[bx + 4]
	imul word ptr ds:[bx + 8]
	imul word ptr ds:[bx + 12]
	sub cx, ax
	
	mov ax, ds:[bx]
	imul word ptr ds:[bx + 10]
	imul word ptr ds:[bx + 14]
	sub cx, ax
	
	mov ax, ds:[bx + 2]
	imul word ptr ds:[bx + 6]
	imul word ptr ds:[bx + 16]
	sub cx, ax
	mov ax, cx
	
	enddet:
	push word ptr[bp + arg1]
	push ax
	call print_num
	add sp, 4
	mov sp, bp
	pop bp
	ret