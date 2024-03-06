data_s segment para public
buffer db 256 dup("?")
linebreak db 0ah, "$"
data_s ends

stack_s segment para stack
db 256 dup("?")
stack_s ends

code_s segment para

assume cs:code_s, ss:stack_s, ds:data_s

start:
	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	mov ah, 0ah
	mov bx, offset buffer
	; оформление буфера в начале него должна стоять максимально возможная длина строки
	;mov cx, 240
	mov byte ptr [bx], 240 ; запись по адресу нулевого символа в буфере
	
	mov dx, bx ; приготовление к записи, в dx должен лежать адрес начала буфера перед вызовом функции
	int 21h
	
	mov bx, offset buffer
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
	mov dx, offset buffer
	add dx, 2
	mov ah, 09h
	int 21h
	
	mov ax, 4c00h
	int 21h
	
code_s ends
end start