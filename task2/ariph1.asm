data_s segment para public
x dw 1
y dw 8
z dw ?
data_s ends

stack_s segment para stack
db 256 dup("?")
stack_s ends

code_s segment para 

assume 	cs:code_s,ds:data_s,ss:stack_s

start:

	mov ax, word ptr[x]
	mov cx, word ptr[y]
	imul cx ;DX:AX=AX*CX
	add cx, word ptr[x]
	idiv cx ; dx;ax / cx = ax
	mov word ptr[z],ax

	mov ax,4c00h
	int 21h

code_s ends
end start