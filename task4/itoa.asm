.386

stack_s segment para stack
db 256 dup(?)
stack_s ends

data_s segment para public
n dw 1234h
str1 dw 0, 0
data_s ends

code_s segment para use16

assume cs:code_s, ds:data_s, ss:stack_s

start:
	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	mov cx, 4
	mov bx, word ptr[n]
	
get_ascii:
	mov dx, 01111b
	and dx, bx
	cmp dx, 10
	jb below1
	jae ab_eq
	jmp_back:
	mov di, cx
	sub di, 1
	mov bp, offset str1
	mov byte ptr ds:[bp + di], dl
	shr bx, 4
	loop get_ascii
	jmp exit
	
below1:
	add dl, "0"
	jmp jmp_back
ab_eq:
	sub dl, 10
	add dl, "A"
	jmp jmp_back
	
exit:
	mov dx, offset str1
	mov bx, 1
	mov cx, 4
	mov ah, 40h
	int 21h
	mov ax, 4c00h
	int 21h
	
code_s ends
end start