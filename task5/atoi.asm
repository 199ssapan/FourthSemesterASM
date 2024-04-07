.386
stack_s segment para stack
db 256 dup("?")
stack_s ends

data_s segment para public
new_num_str db 5 dup ("?")
num_str db 7 dup ("?")
new_strlen dw 0
num dw 0
multiplier dw 1
ten dw 10
data_s ends

code_s segment para public use16

assume 	cs:code_s,ds:data_s,ss:stack_s

atoi:
	;в регистре bx - адрес строки c числом, 
	;в регистре si - длина числа, 
	;функция возвращает в регистре di полученное число
	xor di, di
	mov ax, [multiplier]
	cycle_atoi:
		xor dx, dx
		dec si
		cmp si, 0
		jl break_atoi
		mov dl, byte ptr[bx + si]
		sub dx, 30h
		mul dx
		add di, ax
		mov ax, [multiplier]
		mul [ten]
		mov [multiplier], ax
		jmp cycle_atoi
	break_atoi:
	ret

itoa: 
	; в регистре ax - число,
	;в регистре bx - адрес строки для числа, 
	;в регистре si - адрес длины строки для числа
	mov si, [si]
    cycle_itoa:
		xor dx, dx
		dec si
		cmp si, 0
		jl break_itoa
		div [ten]
		add dl, 30h
		mov byte ptr[bx + si], dl
		
		jmp cycle_itoa
	break_itoa:	
    ret

get_len:
	;ax - число
	;si - выход: длина числа
	mov si, 1
	cycle2:
		xor dx, dx
		mov cx, ax
		div [ten]
		cmp ax, 0
		je br2
		inc si
		jmp cycle2
	br2:
	ret

start:

	mov ax,data_s
	mov ds,ax
	mov ax,stack_s
	mov ss,ax

	mov ah, 3fh ; функция ввода из файла
	mov dx, offset num_str
	mov cx, 240
	mov bx, 0
	int 21h
	
	mov bx, offset num_str
	mov si, ax
	sub si, 2
	call atoi
	
	add di, 12345
	mov [num], di
	
	mov ax, [num]
	call get_len
	mov [new_strlen], si
	
	mov si, offset new_strlen
	mov ax, [num]
	mov bx, offset new_num_str
	call itoa
	
	mov dx, offset new_num_str
	mov bx, 1
	mov cx, [new_strlen]
	mov ah, 40h
	int 21h
	
	mov ax,4c00h
	int 21h

code_s ends
end start
