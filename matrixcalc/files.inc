;int get_file_descriptor(int mode, char* name)
get_file_descriptor: ; получение дескриптора файла по имени и режиму открытия
	push bp
	mov bp, sp
	
	xor ax, ax
	mov ah, 3dh
	mov al, [bp + 6]
	mov dx, [bp + 4]
	int 21h
	jnc get_descr_ret ; если флаг cf установлен значит ошибка есть
	
	jmp _exit255
	
	get_descr_ret:
	mov sp, bp
	pop bp
	ret
	
;void close_file(int descriptor)	
close_file: ; закрытие файла
	push bp
	mov bp, sp
	
	mov bx, [bp + 4]
	mov ah, 3eh
	int 21h
	
	mov sp, bp
	pop bp
	ret

;void get_file_name(char* dstfilename)
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
	
	mov sp, bp
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