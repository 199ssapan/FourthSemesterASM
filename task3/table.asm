stack_s segment para stack
db 256 dup(?)
stack_s ends

data_s segment para public
nul_ db "nul"
soh_ db "soh"
stx_ db "stx"
etx_ db "etx"
eot_ db "eot"
enq_ db "enq"
ack_ db "ack"
bel_ db "bel"
bs_  db "bs "
ht_  db "ht "
lf_  db "lf "
vt_  db "vt "
ff_  db "ff "
cr_  db "cr "
so_  db "so "
si_  db "si "
dle_ db "dle"
dc1_ db "dc1"
dc2_ db "dc2"
dc3_ db "dc3"
dc4_ db "dc4"
nak_ db "nak"
syn_ db "syn"
etb_ db "etb"
can_ db "can"
em_  db "em "
sub_ db "sub"
esc_ db "esc"
fs_  db "fs "
gs_  db "gs "
rs_  db "rs "
us_  db "us "
digits db "0123456789ABCDEF"
newline db 0dh, 0ah, "$"
i dw 0
j db 0
k db 0
data_s ends

code_s segment para public 

assume cs:code_s,ds:data_s,ss:stack_s

start:
    mov ax, data_s
    mov ds, ax
    mov ax, stack_s
    mov ss, ax
	
	xor si, si
	xor di, di
	mov bx, offset digits
	xor cx, cx
	
	
first_4_str: ; вывод спецсимволов
	mov dx, offset nul_ ; так как я поместил названия спецсимволов в начало, то могу просто бежать по сегменту данных и выводить по три символа
	add dx, [i]
	mov bx, 1
	mov cx, 3
	mov ah, 40h
	int 21h
	
	mov dl, ":"
	mov ah, 02h
	int 21h
	
	mov dl, " "
	mov ah, 02h
	int 21h
	
	add [i], 3 ; скачок через 3 символа
	
	mov bx, offset digits ; вывод старшего разряда
	mov dl, byte ptr[bx + di]
	mov ah, 02h
	int 21h
	
	mov bx, offset digits ; вывод младшего разряда
	mov dl, byte ptr[bx + si]
	mov ah, 02h
	int 21h
	
	mov dl, " "
	mov ah, 02h
	int 21h
	
	add si, 1
	cmp si, 16
	je carry_digits1 ; если si равен 16 тогда меняем следующий разряд а si обнуляем
	back_carry_digits1:
	xor ah, ah
	add [j], 1
	cmp [j], 32 ; если j равно 32 то это значит что мы вывели все спецсимволы
	je second_part
	
	mov ax, word ptr[j]
	mov bp, 8
	mov dx, 0
	div bp
	
	cmp dx, 0 ; если остаток от деления j на 8 равен 0 тогда переносим строку
	je print_newline
	jmp first_4_str
	
carry_digits1: ; 0F -> 10
	mov si, 0
	add di, 1
	jmp back_carry_digits1
	
	
print_newline:
	mov dx, offset newline
	mov ah, 09h
	int 21h
	jmp first_4_str

second_part:
	xor si, si
	xor di, di
	mov di, 2
	mov bx, offset digits
	
cyc_out:
	mov dx, offset newline
	mov ah, 09h
	int 21h
	cyc_in:
		cmp di, 16 ; если di равен 16 это значит мы вывели все символы
		je exit
		
		mov dl, byte ptr[j] ; вывод ascii символа, который имеет код j 
		mov ah, 02h
		int 21h
		
		mov dl, " " ; вывод пробелов для того, чтобы таблица смотрелась не уродливо
		mov ah, 02h
		int 21h
		
		mov dl, " "
		mov ah, 02h
		int 21h
		
		mov dl, ":"
		mov ah, 02h
		int 21h
		
		mov dl, " "
		mov ah, 02h
		int 21h
		
		mov bx, offset digits ; такая же процедура составления шестнадцатиричного числа как и в выводе спецсимволов
		mov dl, byte ptr[bx + di]
		mov ah, 02h
		int 21h
		
		mov bx, offset digits
		mov dl, byte ptr[bx + si]
		mov ah, 02h
		int 21h
		
		mov dl, " "
		mov ah, 02h
		int 21h
		
		add si, 1
		cmp si, 16 ; точно также если si равен 16 значит пора переносить разряды
		je carry_digits
		back_carry_digits:
		xor ah, ah
		add [j], 1
		cmp [j], 32
		je exit
		
		mov ax, word ptr[j]
		mov bp, 8
		mov dx, 0
		div bp
		
		cmp dx, 0
		je cyc_out
		jmp cyc_in
	
carry_digits:
	mov si, 0
	add di, 1
	jmp back_carry_digits
	
exit:
	mov ax, 4c00h
	int 21h
code_s ends

end start