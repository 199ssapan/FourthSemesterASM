_strlen:
    push bp
    mov bp, sp
    
    mov bx, word ptr [bp + arg1] 
    mov ax, 0 ; счётчик (ax)
    
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