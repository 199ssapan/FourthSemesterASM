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
num1_sign db ?
num2_sign db ?
num1 dw ?
num2 dw ?
op db ?
str_num1 db 7 dup (?)
str_num2 db 7 dup (?)
alpha_len dw ?
alpha10 db "0123456789", 0
alpha16 db "0123456789abcdef", 0
str1 db 50 dup(?)
str1_len dw 50
i dw 0
err_str db "Error", "$"
multiplier dw 1
ten dw 10
sixteen dw 16
res_add dw 0
res_sub dw 0
res_mul dw 0, 0
res_div dw 0
res_rem dw 0
res_str db 9 dup (?)
res_sign db ?
base db ?
newline db 10, 13, "$"
res dw ?
data ends

code segment para public use16

assume cs:code,ds:data,ss:stack

include atoiitoa.inc
include ariph.inc
include checks.inc
include strs.inc

_exit:
    push bp
    mov bp, sp
    
    mov ax, word ptr [bp + arg1]
    mov ah, 4ch
	int 21h
    
    mov sp, bp
    pop bp
    ret
    
; void exit0()
; завершает работу программы с кодом 0 
_exit0:
    push bp
    mov bp, sp
    
    mov dx, 0
    push dx
    call _exit
    add sp, 2
    
    mov sp, bp
    pop bp
    ret

_calc: 
    push bp
    mov bp, sp
	mov dx, offset str1_len
	push dx
	mov dx, offset str1
	push dx
	call _getstr
	add sp, 4
	
	mov dx, offset str1
	push dx
	call _strlen
	add sp, 2
	cmp ax, 5
	jl exit_e
	
	mov dx, [bp + arg2]
	push dx
	call _strlen
	add sp, 2
	mov [alpha_len], ax
	
	mov dx, [bp + arg2]
	push dx
	mov bx, offset str1
	push bx
	call _check
	add sp, 4

	mov dx, offset str_num1
	push dx
	mov dx, offset str_num2
	push dx
	mov dx, offset op
	push dx
	mov dx, offset str1
	push dx
	
	call _parse_nums_op
	add sp, 8
	
	mov dx, offset num1_sign
	push dx
	mov dx, [bp + arg2]
	push dx
	mov dx, offset str_num1
	push dx
	
	call check_num
	add sp, 6
	
	mov dx, offset num2_sign
	push dx
	mov dx, [bp + arg2]
	push dx
	mov dx, offset str_num2
	push dx
	
	call check_num
	add sp, 6
	
	mov dx, offset op
	push dx
	call check_op
    add sp, 2
	
	cmp byte ptr[bp + arg1], "h"
	je get_hex_atoi1
	push 10
	jmp no_hex_atoi1
	get_hex_atoi1:
		push 16
	no_hex_atoi1:
	mov dx, offset str_num1
	push dx
	call _atoi
	add sp, 4
	mov [num1], ax
	
	cmp byte ptr[bp + arg1], "h"
	je get_hex_atoi2
	push 10
	jmp no_hex_atoi2
	get_hex_atoi2:
		push 16
	no_hex_atoi2:
	mov dx, offset str_num2
	push dx
	call _atoi
	add sp, 4
	mov [num2], ax
	
	mov ax, [num1]
	cmp [num1_sign], "-"
	jne plus1
	neg ax
	mov [num1], ax
	plus1:
	
	mov ax, [num2]
	cmp [num2_sign], "-"
	jne plus2
	neg ax
	mov [num2], ax
	plus2:
	
	mov ax, [num2]
	push ax
	mov ax, [num1]
	push ax
	
	mov bx, offset op
	cmp byte ptr[bx], "+"
	je _add
	cmp byte ptr[bx], "-"
	je _sub
	cmp byte ptr[bx], "*"
	je _mul
	cmp byte ptr[bx], "/"
	je _div
	cmp byte ptr[bx], "%"
	je _rem
	
	_add:
		call addition
		jmp next_act
	_sub:
		call subtraction
		jmp next_act
	_mul:
		call multiplication
		jmp next_act
	_div:
		call division
		jmp next_act
	_rem:
		call division
		add sp, 4
		cmp [num1], 0
		jge pos_r
		mov ax, [num2]
		add ax, dx
		mov dx, ax
		pos_r:
		
		mov ax, dx
		mov [res], ax
		jmp print_res
		
		next_act:
		add sp, 4
		cmp byte ptr[bp + arg1], "h"
		je posit_
		cmp ax, 0
		jge posit_
		neg ax
		mov [res_sign], "-"
		posit_:
		
		mov [res], ax
	print_res:
		mov cx, ax
		mov bx, ax
		cmp byte ptr[bp + arg1], "h"
		je hexlen1
			push 10
			jmp next1
		hexlen1:
			push 16
		next1:
		push bx
		call get_len
		add sp, 2
		
		cmp byte ptr[bp + arg1], "h"
		je get_hex_itoa
			push 10
			jmp push_other
		get_hex_itoa:
		push 16
		push_other:
		push ax
		mov dx, offset res_str
		push dx
		push bx
		
		call _itoa
		add sp, 8
		cmp byte ptr[bp + arg1], "h"
		je pos_out
		cmp [res_sign], "-"
		jne pos_out
		mov ah, 02h
		mov dl, "-"
		int 21h
		
		pos_out:
		mov ax, [res]
		push ax
		call get_len
		add sp, 2
		
		push ax
		mov dx, offset res_str
		push dx
		call output_str
		add sp, 4
    mov sp, bp
    pop bp
    ret

start: ; вызов функции calc (модифицировать главную функцию программы не требуется)
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    
	mov ah, 01h
	int 21h
	
	mov byte ptr [base], al
	
	mov ah, 09h
	mov dx, offset newline
	int 21h
	
	cmp byte ptr[base], "h"
	je hexcall
	cmp byte ptr[base], "d"
	jne exit_e
		mov dx, offset alpha10
	jmp callcalc
	hexcall:
		mov dx, offset alpha16
	
	callcalc:
	push dx
	xor dx, dx
	mov dl, [base]
	push dx
    call _calc
	add sp, 4
	call _exit0
	exit_e:
		mov dx, offset err_str
		mov ah, 09h
		int 21h
		mov ax, 4cffh
		int 21h
		exit__:
		mov ax, 4c00h
		int 21h
code ends

end start