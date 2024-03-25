stack_s segment para stack
db 256 dup(?)
stack_s ends

data_s segment para public
strlen dw ? 
str db 256 dup(?)
finalstr db 512 dup(?)
err_str db "Error!", 0ah, 0dh, "$"
newline db 0Dh, 0Ah, "$"
low_lim db ?
up_lim db ?
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

    mov ah, 01h ; ввод нижней границы
    int 21h
	mov [low_lim], al
	
	mov ah, 01h ; ввод верхней границы
	int 21h
	mov [up_lim], al
	
	mov bl, byte ptr [low_lim] ; проверка на то что нижняя граница меньше верхней
	cmp bl, al
	ja err
	
	mov ah, 09h
	mov dx, offset newline
	int 21h
	
	mov ah, 01h
	int 21h
	mov di, offset finalstr
	xor si, si
    
cyc_char_input:
    cmp al, 0dh      
    je cyc_input_end   
    
	mov cl, "0"
	
	mov bl, byte ptr [low_lim] ; ниже ли введенный символ нижней границы
	cmp al, bl
	jb out_range1
	out_range_back1:
	
	mov bl, byte ptr [up_lim] ; выше ли введенный символ верхней границы
	cmp al, bl
	ja out_range2
	out_range_back2:
	
    mov byte ptr[di], cl ; запись считанного символа в строку
    inc di
	inc si
	mov byte ptr[di], al; переход к следующему байту в буфере
    inc di	; увеличение счетчика считанных символов
	inc si
	
	mov word ptr[strlen], si ; запись длины строки(она получилась больше в 2 раза)
    
    mov ah, 01h
    int 21h
    jmp cyc_char_input

err:
	mov ah, 09h ; обработка ошибок
	mov dx, offset err_str
	int 21h
	mov ax, 4cffh
	int 21h
	
out_range1:
	mov cl, "1" ; если символ не вошел в диапазон тогда в строку ставим 1 иначе 0
	jmp out_range_back1 ; например нам дан диапазон af и введенная строка это azc1b тогда конечная стркоа будет иметь вид 0a 1z 0c 11 0b без пробелов
	
out_range2:
	mov cl, "1"
	jmp out_range_back2

cyc_input_end:  
    mov word ptr [strlen], si
    
    mov ah, 40h                
    mov bx, 1                  
    mov cx, 2
    mov dx, offset newline         
    int 21h
	
	mov bx, offset finalstr ; подготовка к выводу символов не вошедших в диапазон
	xor si, si
	xor di, di
	xor cx, cx
	xor bp, bp
	add di, 30h ; 30h == "0"
	add si, 30h
	add bp, 30h
	
	
print_ci:
	
	cmp cx, [strlen] ; если текущий индекс оказался выше или равен длине тогда выходим
	jae exit
	
	cmp byte ptr[bx], "0" ; если бит равен 0 значит этот символ попал в диапазон и мы пропускаем его вывод
	je cont_print
	
	mov ah, 02h
	mov dl, [bx + 1]
	int 21h
	
	mov ah, 02h
	mov dl, "-"
	int 21h
	
	mov ah, 02h
	mov dx, bp
	int 21h
	
	mov ah, 02h
	mov dx, di
	int 21h
	
	mov ah, 02h
	mov dx, si
	int 21h
	
	mov ah, 02h
	mov dl, " "
	int 21h
	
	cont_print:
	add bx, 2
	add cx, 2
	add si, 1
	cmp si, 3ah
	je carry_digits1
	jmp print_ci

carry_digits1: ; если si равен 11 значит его нужно обнулить а к di прибавить 1
	mov si, 30h
	add di, 1
	cmp di, 3ah
	je carry_digits2
	jmp print_ci

carry_digits2:
	mov si, 30h
	mov di, 30h
	add bp, 1
	jmp print_ci
	
str_out:
	mov ah, 40h
	mov bx, 1
	mov dx, offset finalstr
	mov cx, word ptr[strlen]
	int 21h
	jmp exit
	

exit:
	mov ax, 4c00h
	int 21h
code_s ends

end start