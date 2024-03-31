.386

stack_s segment para stack
db 256 dup(?)
stack_s ends

data_s segment para public
copy dw 0
crc16 dw 0
string db "String"
strlen dw 0
count db 0
str1 dd 0
data_s ends

code_s segment para use16

assume cs:code_s, ds:data_s, ss:stack_s

start:
	mov ax, data_s
	mov ds, ax
	mov ax, stack_s
	mov ss, ax
	
	mov bx, offset strlen
	mov dx, offset string
	sub bx, dx
	mov [strlen], bx
	
	mov cx, [strlen]
	xor si, si
	xor ax, ax
	xor dx, dx
	mov [copy], ax
	dec si
	
cycle_string:
	inc si
	cmp si, [strlen]
	je convert
	
	mov bx, offset string
	mov dl, byte ptr[bx + si]
	shl dx, 8
	xor ax, dx
	mov [copy], ax
	mov [count], 0
	cycle_bits:
		nop
		mov [copy], ax
		cmp [count], 8
		je next
		and [copy], 08000h
		cmp [copy], 0
		jne step1
		shl ax, 1
		mov [copy], ax
		back:
		inc [count]
		jmp cycle_bits
		next:
		loop cycle_string
		jmp convert
	
step1:
	shl ax, 1
	xor ax, 01021h
	mov [copy], ax
	jmp back
convert:
	and ax, 0ffffh
	mov [crc16], ax
	mov cx, 4
	mov bx, word ptr[crc16]
	
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
	jmp exit1
	
below1:
	add dl, "0"
	jmp jmp_back
ab_eq:
	sub dl, 10
	add dl, "A"
	jmp jmp_back
	
exit1:
	mov dx, offset str1
	mov bx, 1
	mov cx, 4
	mov ah, 40h
	int 21h
	mov ax, 4c00h
	int 21h
	mov ax, 4c00h
	int 21h
code_s ends
end start