.386

stack segment para stack
db 256 dup (?)
stack ends 

data segment para public
src_string db "Try find symbol!"
new_line db 0dh, 0ah, "$"
src_len dw ?
success_str db " - Symbol was found!", 0dh, 0ah, "$"
error_str db " - Symbol wasn't found (((", 0dh, 0ah, "$"
reserved db 256 dup (?)
data ends

code segment para public use16

assume cs:code,ds:data,ss:stack

start:
	; инициализация сегментных регистров
	mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
	nop
	xor si, si
	xor di, di
	inf:
	
	mov ah, 01h
	int 21h
	mov byte ptr [reserved], al
	
	cmp al, 0dh
	jne next
	add si, 1
	cmp si, 2
	je exit
	
	next:
	
	
	mov al, byte ptr [reserved]
	mov cx, offset new_line
	mov bx, offset src_string
	sub cx, bx	; cx = длина строки
	mov word ptr [src_len], cx
	
	dec bx
search:
	inc bx
	cmp al, byte ptr [bx]
	loopne search
	je found
	
	mov dx, offset error_str
	jmp print
found:
	mov dx, offset success_str
print:
	mov ah, 09h
	int 21h
	
	inc di
	cmp di, 5
	je print_line
	jmp_back:
	jmp inf
print_line:
	mov dx, offset src_string
	mov ah, 09h
	int 21h
	xor di, di
	jmp jmp_back

exit:
	mov ax, 4c00h
	int 21h
	
code ends

end start