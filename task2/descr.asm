data_s segment para public
str db 256 dup("?")
data_s ends

stack_s segment para stack
db 256 dup("?")
stack_s ends

code_s segment para

assume cs:code_s, ds:data_s, ss:stack_s

start:
	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	mov ah, 3fh
	mov dx, offset str
	mov cx, 240
	mov bx, 0
	int 21h
	
	mov bx, 1
	mov cx, ax
	mov dx, offset str
	mov ah, 40h
	int 21h
	
	mov ax, 4c00h
	int 21h
	
	
code_s ends
end start
