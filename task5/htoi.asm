.386
stack_s segment para stack
db 256 dup(?)
stack_s ends

data_s segment para public
num dw 0
digits db "0123456789ABCDEF"
num_str db 6 dup ("?")
new_num_str db 4 dup ("?")
new_num_len dw 0
multiplier dw 1
sixteen dw 16
data_s ends

code_s segment para public use16

assume cs:code_s, ds:data_s, ss:stack_s

itoh: 
	; в регистре ax - число,
	;в регистре bx - адрес строки для числа, 
	;в регистре si - адрес длины строки для числа
	mov si, [si]
    cycle_itoa:
		xor dx, dx
		dec si
		cmp si, 0
		jl break_itoa
		div [sixteen]
		cmp dx, 10
		jb bel
		jnb nbel
		bel:
			add dx, "0"
			jmp next
		nbel:
			add dx, "A"
			sub dx, 10
		next:
		mov byte ptr[bx + si], dl
		
		jmp cycle_itoa
	break_itoa:	
    ret

htoi:
	;в регистре bx - адрес строки c числом, 
	;в регистре si - длина числа, 
	;функция возвращает в регистре di полученное число
	xor cx, cx
	xor dx, dx
	mov bp, offset digits
	mov ax, [multiplier]
	cycle_htoi:
		dec si
		cmp si, 0
		jl break_htoi
		xor di, di
		mov dl, byte ptr [bx + si]
		call get_index
		mul di
		add cx, ax
		mov ax, [multiplier]
		mul [sixteen]
		mov [multiplier], ax
		jmp cycle_htoi
	break_htoi:
	mov di, cx
	ret

get_index:
	;dl входной символ
	;bp смещение до алфавита
	;di возвращаемое значение индекс символа в алфавите
	xor di, di
	cycle_get_index:
		cmp dl, byte ptr ds:[bp + di]
		je break_get_index
		inc di
		jmp cycle_get_index
	break_get_index:
	ret
	
get_len:
	;ax - число
	;si - выход: длина числа
	mov si, 1
	cycle_get_len:
		xor dx, dx
		div [sixteen]
		cmp ax, 0
		je break_get_len
		inc si
		jmp cycle_get_len
	break_get_len:
	ret
	
start:
	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	mov bx, 0
	mov ah, 3fh
	mov cx, 240
	mov dx, offset num_str
	int 21h
	
	mov bx, offset num_str
	mov si, ax
	sub si, 2
	
	call htoi
	mov [num], di
	
	add [num], 123h
	
	mov ax, [num]
	call get_len
	mov [new_num_len], si
	
	mov ax, [num]
	mov bx, offset new_num_str
	mov si, offset new_num_len
	call itoh
	
	mov ax, [num]
	call get_len
	
	mov ah, 40h
	mov cx, si
	mov bx, 1
	mov dx, offset new_num_str
	int 21h
	
	mov ax, 4c00h
	int 21h

code_s ends
end start