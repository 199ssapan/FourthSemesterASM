data_s segment para public
db 256 dup()
data_s ends

stack_s segment para stack
db 256 dup()
stack_s ends

code_s segment para

assume cs:code_s, ds:data_s, ss:stack_s

start:
	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	mov ah, 01h ;считывание символа с клавиатуры
	int 21h
	
	mov dl, al ; запись этого символа в регистр dl для дальнейшего вызовы функции вывода символа (02h) на стандартный вывод
	mov ah, 02h 
	int 21h
	
	mov ax, 4c00h
	int 21h
	
code_s ends
end start