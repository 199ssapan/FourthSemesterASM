.386
_stack segment para stack
db 65000 dup(?)
_stack ends

_data segment para public
tmp db "?"
file1_name db 100 dup ("?")
file2_name db 100 dup ("?")
file1_descr dw 0
file2_descr dw 0
error_ db "Error!", 0dh, 0ah, "$"
_data ends

_code segment para public use16
assume cs:_code,ds:_data,ss:_stack

get_file_descriptor: ; получение дескриптора файла по имени и режиму открытия
	push bp
	mov bp, sp
	
	xor ax, ax
	mov ah, 3dh
	mov al, [bp + 6]
	mov dx, [bp + 4]
	int 21h
	jnc get_descr_ret ; если флаг cf установлен значит ошибка есть
	
	mov dx, offset error_
	mov ah, 09h
	int 21h
	jmp exit
	
	get_descr_ret:
	pop bp
	ret

read_charf: ; чтение символа с файла
	push bp
	mov bp, sp
	
	mov bx, [bp + 4]
	mov cx, 1
	mov ah, 3fh
	mov dx, offset tmp
	int 21h
	
	pop bp
	ret

close_file: ; закрытие файла
	push bp
	mov bp, sp
	
	mov bx, [bp + 4]
	mov ah, 3bh
	int 21h
	
	pop bp
	ret
	
write_charf: ; запись символа в файл
	push bp
	mov bp, sp
	
	mov ah, 40h
	mov bx, [bp + 4]
	mov cx, 1
	mov dx, [bp + 6]
	int 21h
	
	pop bp
	ret

rewrite_make_file: ; перезапись второго файла, если он есть, содержимое стирается, иначе создается новый файл
	push bp
	mov bp, sp
	
	xor ax, ax
	mov ah, 3ch
	mov cx, [bp + 6]
	mov dx, [bp + 4]
	int 21h
	
	pop bp
	ret

get_file_name: ; получения имени файла через консоль
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
	
	pop bp
	ret
	
start:
    mov ax, _data
    mov ds, ax
    mov ax, _stack
    mov ss, ax
	
	mov dx, offset file1_name
	push dx
	call get_file_name
	add sp, 2
	
	mov dx, offset file2_name
	push dx
	call get_file_name
	add sp, 2
	
	mov dx, offset file1_name
	push 0
	push dx
	call get_file_descriptor
	add sp, 4
	
	mov [file1_descr], ax
	
	mov dx, offset file2_name ; перезапись файла или создание нового
	push 0
	push dx
	call rewrite_make_file
	add sp, 4
	mov [file2_descr], ax
	
	push word ptr [file2_descr]
	call close_file
	add sp, 2
	
	mov dx, offset file2_name
	push 1
	push dx
	call get_file_descriptor
	add sp, 4
	
	mov [file2_descr], ax
	
	cycle_read:
		push word ptr [file1_descr]
		call read_charf ; читаем символ с 1 файла
		add sp, 2
		
		cmp ax, 0 ; если в ах вернулся 0 значит считалось 0 байт, значит файл закончился, закрываем файлы, 
		;выходим из программы
		jne next1
		
		push word ptr [file1_descr]
		call close_file
		add sp, 2
		
		push word ptr [file2_descr]
		call close_file
		add sp, 2
		jmp break_cycle_read
		
		next1:
		mov bx, offset tmp
		push bx
		push word ptr[file2_descr]
		call write_charf
		add sp, 4
		jmp cycle_read
	break_cycle_read:
	exit:
	mov ax, 4c00h
	int 21h
	
_code ends

end start