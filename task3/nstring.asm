stack_s segment para stack
db 256 dup(?)
stack_s ends 

data_s segment para public 
str db 256 dup("?")
newline db 0dh, 0ah, "$"
strlen dw ?
n dw 3
data_s ends

code_s segment para

assume cs:code_s, ds:data_s, ss:stack_s

start:
	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	mov ah, 3fh ; функция ввода из файла
	mov dx, offset str
	mov cx, 240
	mov bx, 0
	int 21h
	
	mov word ptr[strlen], ax
	mov si, [n]
	
	mov ah, 09h
	mov dx, offset newline
	int 21h
cyc_n_out:
	
	cmp si, 0
	je end_cyc
	mov bx, 1
	mov cx, word ptr[strlen]
	mov dx, offset str
	mov ah, 40h 
	int 21h
	sub si, 1
	jmp cyc_n_out

end_cyc:
	mov ax, 4c00h
	int 21h

code_s ends
end start