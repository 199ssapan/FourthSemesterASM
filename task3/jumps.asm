stack segment para stack
db 256 dup(?)
stack ends

data segment para public
success db "Success!", 0ah, "$"
unsuccess db "Unsuccess!", 0ah, "$"
db 256 dup(?)
data ends

code segment para public 

assume cs:code, ds:data, ss:stack

start:
	mov ax, data 
    mov ds, ax
    mov ax, stack
    mov ss, ax
	
	
	mov ax, -2		
	mov bx, -2
	cmp ax, bx		; сравниваем значение в двух регистрах
	jl less1		; если ax < bx (знаковое) -> переход на метку less1
	jg greater1		; если ax > bx (знаковое) -> переход на метку greater1
	je equal1		; если ax == bx -> переход на метку equal1
	
less1:
	sub bx, 1		; операция вычитания -> bx -= 1
	cmp ax, bx
	jge grOrEq1			; если ax >= bx (знаковое) -> переход на метку grOrEq1
	jl exit_unsuccess	; если ax < bx (знаковое) -> переход на метку exit_unsuccess
	
greater1:
	dec ax				; операция декремента -> ax -= 1
	cmp ax, bx
	jz exit_success		; если после инструкции cmp был выставлен флаг ZF (Zero Flag) -> переход на exit_success
						; что в данном случае равноценно ax == bx

equal1:
	neg ax			; инструкция изменения знака -> ax = -ax
	cmp ax, bx
	jb below1		; если ax < bx (беззнаковое) 
	ja above1		; если ax > bx (беззнаковое)
	
below1:
	cmp ax, bx
	jmp exit_success

above1:
	cmp ax, bx
	jmp exit_unsuccess

grOrEq1:
	add ax, bx		; операция сложения -> ax = ax + bx
	mov si, 01000b	; si = 8
	xor ax, ax
	test ax, ax		; логическое сравнение -> ax & ax
	jz exit_success	; если последняя арифметическая \ логическая операция в результате дала 0
	
exit_unsuccess:
	mov ah, 09h
	mov dx, offset unsuccess
	int 21h
	mov al, 0ffh	; код выхода
	jmp exit
	
exit_success:
	mov al, 0
	mov ah, 09h
	mov dx, offset success
	int 21h
exit:
	mov ah, 4ch		; код функции выхода из программы
	int 21h			; вызов DOS-прерывания
code ends	

end start