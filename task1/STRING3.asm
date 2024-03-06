data_s segment para public
str db "This is my string", 0Ah, "$"
data_s ends

stack_s segment stack
db 256 dup("?")
stack_s ends

code_s segment para

assume cs:code_s, ss:stack_s, ds:data_s

start:
	mov ax, stack_s
	mov ss, ax
	mov ax, data_s
	mov ds, ax
	
	mov dx, offset str
	mov ah, 09h
	int 21h
	
	mov ax, 4c00h
	int 21h
	
code_s ends
end start