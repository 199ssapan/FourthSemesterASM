.386
_stack segment para stack
db 65000 dup(?)
_stack ends

_data segment para public
gamma_len db 0
tmp db "?"
gamma db 100 dup ("?")
file1_name db 100 dup ("?")
file2_name db 100 dup ("?")
file1_descr dw 0
file2_descr dw 0
error_ db "Error!", 0dh, 0ah, "$"
gamma_err db "Gamma error!", 0dh, 0ah, "$"
_data ends

_code segment para public use16
assume cs:_code,ds:_data,ss:_stack

get_file_descriptor:
	push bp
	mov bp, sp
	
	xor ax, ax
	mov ah, 3dh
	mov al, [bp + 6]
	mov dx, [bp + 4]
	int 21h
	jnc get_descr_ret
	
	mov dx, offset error_
	mov ah, 09h
	int 21h
	jmp exit
	
	get_descr_ret:
	pop bp
	ret

read_charf:
	push bp
	mov bp, sp
	
	mov bx, [bp + 4]
	mov cx, 1
	mov ah, 3fh
	mov dx, offset tmp
	int 21h
	
	pop bp
	ret

close_file:
	push bp
	mov bp, sp
	
	mov bx, [bp + 4]
	mov ah, 3bh
	int 21h
	
	pop bp
	ret
	
write_charf:
	push bp
	mov bp, sp
	
	mov ah, 40h
	mov bx, [bp + 4]
	mov cx, 1
	mov dx, [bp + 6]
	int 21h
	pop bp
	ret

rewrite_make_file:
	push bp
	mov bp, sp
	
	xor ax, ax
	mov ah, 3ch
	mov cx, [bp + 6]
	mov dx, [bp + 4]
	int 21h
	
	pop bp
	ret

read_string_1:
	push bp
	mov bp, sp
	
	xor ax, ax
	mov bx, 0
	mov ah, 3fh
	mov cx, 100
	mov dx, [bp + 4]
	int 21h
	
	mov si, ax
	mov bx, [bp + 4]
	mov byte ptr[bx + si - 2], 0
	mov ax, si
	pop bp
	ret
	
start: ;программа вся та же самая что и копирование файлов, только в момент записиь символ xor-ится
	; с символом из гаммы
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov dx, offset file1_name
	push dx
	call read_string_1
	add sp, 2
	
	mov dx, offset file2_name
	push dx
	call read_string_1
	add sp, 2
	
	mov dx, offset gamma
	push dx
	call read_string_1
	add sp, 2
	
	sub ax, 2
	cmp ax, 0
	jle err_gamma_len
	mov [gamma_len], al
	
	mov dx, offset file1_name
	push 0
	push dx
	call get_file_descriptor
	add sp, 4
	
	mov [file1_descr], ax
	
	mov dx, offset file2_name
	push 0
	push dx
	call rewrite_make_file
	add sp, 4
	mov [file2_descr], ax
	
	push word ptr [file2_descr]
	call close_file
	add sp, 2
	
	;;;
	
	mov dx, offset file2_name
	push 1
	push dx
	call get_file_descriptor
	add sp, 4
	
	mov [file2_descr], ax
	xor si, si
	dec si
	cycle_read:
		inc si
		push word ptr [file1_descr]
		call read_charf
		add sp, 2
		
		cmp ax, 0
		jne next1
		
		push word ptr [file1_descr]
		call close_file
		add sp, 2
		
		push word ptr [file2_descr]
		call close_file
		add sp, 2
		jmp break_cycle_read
		
		next1: ; c xor gamma[si % gamma_len]
		mov bx, offset gamma
		mov ax, si
		div [gamma_len]
		mov al, ah ; в al сейчас остаток от деления si на gamma_len
		xor ah, ah
		mov si, ax
		mov al, byte ptr[tmp]
		xor al, byte ptr[bx + si]
		mov [tmp], al
		
		mov dx, offset tmp
		push dx
		push word ptr[file2_descr]
		call write_charf
		add sp, 4
		jmp cycle_read
	err_gamma_len:
		mov dx, offset gamma_err
		mov ah, 09h
		int 21h
	break_cycle_read:
	exit:
	mov ax, 4c00h
	int 21h
	
_code ends

end start