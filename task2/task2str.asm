data_s segment para public
buffer1 db 256 dup("?")
buffer2 db 256 dup("?")
buffer3 db 256 dup("?")
linebreak db 0ah, "$"
semicolon db ";", "$"
space db " ", "$"
data_s ends

stack_s segment para stack
db 256 dup("?")
stack_s ends

code_s segment para 

assume 	cs:code_s,ds:data_s,ss:stack_s

start:

	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	mov ah, 0ah
	mov bx, offset buffer1
	; оформление буфера в начале него должна стоять максимально возможная длина строки
	;mov cx, 240
	mov byte ptr [bx], 240 ; запись по адресу нулевого символа в буфере
	mov bx, offset buffer2
	mov byte ptr[bx], 240
	mov bx, offset buffer3
	mov byte ptr[bx], 240
	
	mov dx, offset buffer1 ; приготовление к записи, в dx должен лежать адрес начала буфера перед вызовом функции
	int 21h
	
	mov ah, 09h
	mov dx, offset linebreak
	int 21h
	
	mov ah, 0ah
	mov dx, offset buffer2
	int 21h
	
	mov ah, 09h
	mov dx, offset linebreak
	int 21h
	
	mov ah, 0ah
	mov dx, offset buffer3
	int 21h
	
	mov bx, offset buffer1
	mov cx, [bx + 1] ; получение фактической длины введеной строки
	mov ch, 0 ; очистка для дальнейшей перессылки в di для того чтобы не было мусора в di
	mov di, cx
	add di, 2 ; начало строки без макс длины и фактической длины
	;mov cl, '$'
	mov byte ptr [bx + di], "$" ; ставим завершающий $ в конец строки
	; вывод переноса строки чтобы введеная и выведенная строки не "наслаивались друг на друга"
	mov dx, offset linebreak
	mov ah, 09h
	int 21h
	; вывод строки без первых двух символов(макс длины и факт длины)
	mov dx, offset buffer1
	add dx, 2
	mov ah, 09h
	int 21h
	
	mov bx, offset buffer2
	mov cx, [bx + 1]
	mov ch, 0
	mov di, cx
	add di, 2
	mov byte ptr [bx+di], "$"
	mov dx, offset linebreak
	mov ah, 09h
	int 21h
	
	mov dx, offset buffer2
	add dx, 2
	mov ah, 09h
	int 21h
	
	mov bx, offset buffer3
	mov cx, [bx + 1]
	mov ch, 0
	mov di, cx
	add di, 2
	mov byte ptr [bx+di], "$"
	
	mov dx, offset linebreak
	mov ah, 09h
	int 21h
	
	mov dx, offset buffer3
	add dx, 2
	mov ah, 09h
	int 21h
	
	mov dx, offset linebreak
	int 21h
	
	mov bx, offset buffer1
	lea dx, [bx + 2]
	int 21h
	
	mov dx, offset semicolon
	int 21h
	
	mov bx, offset buffer2
	lea dx, [bx + 2]
	int 21h
	
	mov dx, offset semicolon
	int 21h
	
	mov bx, offset buffer3
	lea dx, [bx + 2]
	int 21h
	
	mov dx, offset linebreak
	int 21h
	
	mov bx, offset buffer1
	lea dx, [bx + 2]
	int 21h
	
	mov dx, offset space
	int 21h
	
	mov bx, offset buffer2
	lea dx, [bx + 2]
	int 21h
	
	mov dx, offset space
	int 21h
	
	mov bx, offset buffer3
	lea dx, [bx + 2]
	int 21h
	
	mov ax,4c00h
	int 21h

code_s ends
end start