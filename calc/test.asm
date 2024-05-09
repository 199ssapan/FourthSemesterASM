; шаблон для зачётного задания №1 (калькулятор) с использованием стековых фреймов
.386

arg1 equ 4
arg2 equ 6
arg3 equ 8
arg4 equ 10

var1 equ -2
var2 equ -4
var3 equ -6
var4 equ -8

stack segment para stack
db 65530 dup(?)
stack ends

data segment para public
num1 dw ?
num2 dw ?
op db ?
str_num1 db "-155", 0
str_num2 db 7 dup (?)
num1_sign db ?
num2_sign db ?
alpha_len dw ?
alpha10 db "0123456789", 0
alpha16 db "0123456789ABCDEF", 0
str1 db 50 dup(?)
str1_len dw 50
i dw 0
err_str db "Error", "$"
multiplier dw 1
ten dw 10
sixteen dw 16
nstr db 10 dup (0)
data ends

code segment para public use16

assume cs:code,ds:data,ss:stack

_itoa:
	push bp
    mov bp, sp
	mov ax, [bp + arg1]
	mov bx, [bp + arg2]
	mov si, [bp + arg3]
	mov byte ptr[si], 0
    cycle_itoa:
		xor dx, dx
		dec si
		cmp si, 0
		jl break_itoa
		mov cx, word ptr[bp + arg4]
		div word ptr[bp + arg4]
		cmp dl, 10
		jae up10
			add dl, 30h ; 5 -> "5"
			jmp next_itoa
		up10:
			add dx, "A"
			sub dx, 10
		next_itoa:
		mov byte ptr[bx + si], dl ; str[si] = (char)dl
		
		jmp cycle_itoa
	break_itoa:	
	mov sp, bp
    pop bp
    ret
	
_strlen: 
    push bp
    mov bp, sp
    
    mov bx, word ptr [bp + arg1] 
    xor ax, ax ; счётчик (ax)

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
	
get_len:
	push bp
    mov bp, sp
	mov si, 1
	mov ax, [bp + arg1]
	cycle2:
		xor dx, dx
		mov cx, ax
		div word ptr[bp + arg2]
		cmp ax, 0
		je br2
		inc si
		jmp cycle2
	br2:
	mov ax, si
	mov sp, bp
    pop bp
    ret
	
start: ; вызов функции calc (модифицировать главную функцию программы не требуется)
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
	mov ax, 145
	mov bx, ax
	push 16
	push ax
	call get_len
	add sp, 4
	
	push 16
	push ax
	mov dx, offset nstr
	push dx
	push bx
	call _itoa
	add sp, 8
	
	mov dx, offset nstr
	push dx
	call _strlen
	add sp, 2
	
	mov cx, ax
	mov bx, 1
	mov ah, 40h
	mov dx, offset nstr
	int 21h
	
	mov ax, 4c00h
	int 21h
code ends

end start