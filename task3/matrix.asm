data_s segment para public
digits db "0123456789"
newline db 0ah, 0dh, "$"
data_s ends

stack_s segment para stack
db 256 dup(?)
stack_s ends

code_s segment para

assume cs:code_s, ds:data_s, ss:stack_s

start:
	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	xor si, si
	xor di, di
	
	add si, 30h
	add di, 30h
	mov cx, 0 ; будет нужен для того, чтобы понять, когда завершать вывод
	
first_str_left:
	xor dx, dx
	mov dx, si
	mov ah, 02h
	int 21h
	
	mov dl, " "
	mov ah, 02h
	int 21h
	
	mov dl, " "
	mov ah, 02h
	int 21h
	
	add si, 1
	cmp si, 3ah
	je carry_digits
	jmp first_str_left
	
carry_digits:
	mov si, 30h
	add di, 1
	cmp di, 3ah ; если di принял значение 3а тогда вывод матрицы закончился и переходим к выводу следующей матрицы
	je next
	jmp cyc_out ;иначе выводим дальше 

cyc_out:
	mov dx, offset newline
	mov ah, 09h
	int 21h
	cyc_in:
		mov dx, di
		mov ah, 02h
		int 21h
		
		mov dx, si
		mov ah, 02h
		int 21h
		
		mov dl, " "
		mov ah, 02h
		int 21h
		
		add si, 1
		cmp si, 3ah
		je carry_digits
		jmp cyc_in
		
first_str_right:
	xor dx, dx
	
	mov dl, " "
	mov ah, 02h
	int 21h
	
	mov dx, si
	mov ah, 02h
	int 21h
	
	mov dl, " "
	mov ah, 02h
	int 21h
	
	add si, 1
	cmp si, 3ah
	je carry_digits
	jmp first_str_right
	
next:
	mov dx, offset newline
	mov ah, 09h
	int 21h
	
	mov dx, offset newline
	mov ah, 09h
	int 21h
	
	xor si, si
	xor di, di
	xor dx, dx
	
	add si, 30h
	add di, 30h
	cmp cx, 0 ; если сх 0 то мы вывели только одну матрицу
	je inc_cx
	
	mov ax, 4c00h
	int 21h

inc_cx:
	add cx, 1 ;переход к выводу второй матрицы
	jmp first_str_right
	
code_s ends

end start