data_s segment para public
str1 db 12 dup ("?")
str2 db 12 dup ("?")
str3 db 12 dup ("?")
len1 db ?
len2 db ?
linebreak db 0ah, 0dh, "$"	
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
	mov dx, offset str1
	mov cx, 10
	mov bx, 0
	int 21h
	
	mov si, ax
	mov bp, offset str1
	mov byte ptr ds:[bp + si - 2], "?"
	mov byte ptr ds:[bp + si - 1], "?"
	
	
	mov ah, 3fh
	mov dx, offset str2
	int 21h
	
	mov si, ax
	mov bp, offset str2
	mov byte ptr ds:[bp + si - 2], "?"
	mov byte ptr ds:[bp + si - 1], "?"
	
	mov ah, 3fh
	mov dx, offset str3
	int 21h
	
	mov si, ax
	mov bp, offset str3
	mov byte ptr ds:[bp + si - 2], "?"
	mov byte ptr ds:[bp + si - 1], "?"
	
	mov bx, offset str1
	mov byte ptr[bx + 11], ";"
	
	mov bx, offset str2
	mov byte ptr[bx + 11], ";"
	
	mov dx, offset linebreak
	mov ah, 09h
	int 21h
	
	mov bx, 1
	mov cx, 32
	mov dx, offset str1
	mov ah, 40h
	int 21h
	
	mov bx, offset str1
	mov byte ptr[bx + 11], " "
	
	mov bx, offset str2
	mov byte ptr[bx + 11], " "
	
	mov dx, offset linebreak
	mov ah, 09h
	int 21h
	
	mov bx, 1
	mov cx, 32
	mov dx, offset str1
	mov ah, 40h
	int 21h
	
	mov bx, offset str1
	mov word ptr[bx + 10], 0d0ah
	
	mov bx, offset str2
	mov word ptr[bx + 10], 0d0ah
	
	mov dx, offset linebreak
	mov ah, 09h
	int 21h
	
	mov bx, 1
	mov cx, 32
	mov dx, offset str1
	mov ah, 40h
	int 21h
	
	mov ax, 4c00h
	int 21h
	
	
code_s ends
end start