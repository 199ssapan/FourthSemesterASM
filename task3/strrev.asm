stack_s segment para stack
db 256 dup(?)
stack_s ends

data_s segment para public
str db 256 dup(?)  
strlen dw ? 
newline db 0Dh, 0Ah
data_s ends

code_s segment para public 

assume cs:code_s,ds:data_s,ss:stack_s

start:
    mov ax, data_s
    mov ds, ax
    mov ax, stack_s
    mov ss, ax
    
    mov al, 0           ; al - текущий считанный символ
    mov bx, offset str  ; bx - буфер строки
    mov si, 0           ; si - счётчик

    mov ah, 01h
    int 21h
    
cyc_char_input:
    cmp al, 0dh       ; сравнение (0dh = Enter)
    je cyc_input_end        ; завершение цикла, если дошли до перевода строки
    
    mov byte ptr[bx], al ; запись считанного символа в строку
    inc bx               ; переход к следующему байту в буфере
    inc si               ; увеличение счетчика считанных символов
    
    mov ah, 01h
    int 21h
    jmp cyc_char_input

cyc_input_end:  
    mov word ptr [strlen], si
    
    mov ah, 40h                
    mov bx, 1                  
    mov cx, 2
    mov dx, offset newline         
    int 21h
	mov si, word ptr [strlen]
	
cyc_reverse_output:
	sub si, 1
	cmp si, 0
	jl cyc_output_end
	mov bx, offset str
	mov dl, byte ptr [bx + si]
	mov ah, 02h
	int 21h
	jmp cyc_reverse_output
	
cyc_output_end:
	mov ax, 4c00h
	int 21h
code_s ends

end start