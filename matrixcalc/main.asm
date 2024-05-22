.386

arg1 equ 4
arg2 equ 6
arg3 equ 8
arg4 equ 10

var1 equ -2
var2 equ -4
var3 equ -6
var4 equ -8
var5 equ -10
var6 equ -12

stack segment para stack
db 65530 dup(?)
stack ends

data1 segment para public
matr1 dw 30000 dup(?) ; матрица
n1 dw ? ; число строк в матрице
m1 dw ? ; число столбцов в матрице
error_ db "Error!", 0dh, 0ah, "$"
file1name db 40 dup ("?")
file3name db "file3.txt", 0
file1_descr dw 0
file3_descr dw 0
tmp1 db ("a")
num_buf db 7 dup ("?")
minus1 db "-"
spacebar db " "
newline db 13, 10
op_ dw 0
data1 ends

data2 segment para public
matr2 dw 30000 dup(?) ; матрица
n2 dw ? ; число строк в матрице
m2 dw ? ; число столбцов в матрице
file2name db 40 dup ("?")
file2_descr dw 0
tmp2 db ("b")
data2 ends

code segment para public use16

assume cs:code,ss:stack,ds:data1,es:data2

include strings.inc
include files.inc
include atoiitoa.inc
include ariph.inc

_exit0:
	mov ax, 4c00h
	int 21h
	
_exit255:
	mov ax, data1
	mov ds, ax
	mov dx, offset error_
	mov ah, 09h
	int 21h
	mov ax, 4cffh
	int 21h
	
; void readm1(int c_buffer, void* segmentAddres, int file_descr)   
; читает матрицу в сегмент по адресу segmentAddres, преобразуя считанные строки в числа
ReadMatrix proc near
	
    push bp
    mov bp, sp
	sub sp, 2
	xor si, si
	mov word ptr[bp + var1], 1
	mov ax, [bp + arg2]
	mov ds, ax
	jmp write_0
	end_num:
	xor bx, bx
	
	cmp word ptr[bp + var1], -1
	jne womin
		neg di
		mov word ptr[bp + var1], 1
	womin:
	
	mov word ptr[bx + si], di
	
	add si, 2
	cmp ax, 0
	je end_write
	
	write_0:
	xor di, di
	atoi_cycle:
		mov bx, [bp + arg3]
		mov cx, 1
		mov ah, 3fh
		mov dx, [bp + arg1]
		int 21h
		
		cmp ax, 0
		je end_num
		
		mov bx, [bp + arg1]
		mov bx, [bx]
		xor bh, bh
		cmp bl, " "
		je end_num
		
		cmp bl, 10
		je atoi_cycle
		
		cmp bl, 13
		je end_num
		
		cmp bl, "-"
		
		jne noneg1
			mov word ptr[bp + var1], -1
			jmp atoi_cycle
		noneg1:
		
		mov ax, di
		mov cx, 10
		mul cx
		mov bx, [bp + arg1]
		mov bx, [bx]
		xor bh, bh
		sub bx, 30h
		add ax, bx
		mov di, ax
		
		
		jmp atoi_cycle

	end_write:
	
	push [bp + arg3]
	call close_file
	add sp, 2
	
    mov sp, bp
    pop bp
	
    ret
ReadMatrix endp

;void ReadNM(char* n, char* m, int file_descr, char* tmp_buf)
ReadNM:
	push bp
	mov bp, sp
	xor si, si
	jmp next_num1
	endnum1:
		mov bx, [bp + arg1]
		mov [bx], di
		
		jmp next_num1
	endnum2:
		mov bx, [bp + arg2]
		mov [bx], di
		
		jmp endwritenm
	next_num1:
	xor di, di
	atoi_cycle1:
		mov bx, [bp + arg3]
		mov cx, 1
		mov ah, 3fh
		mov dx, [bp + arg4]
		int 21h
		mov bx, [bp + arg4]
		mov bx, [bx]
		xor bh, bh
		cmp bl, " "
		je endnum1
		
		cmp bl, 13
		je atoi_cycle1
		
		cmp bl, 10
		je endnum2
		
		mov ax, di
		mov cx, 10
		mul cx
		mov bx, [bp + arg4]
		mov bx, [bx]
		xor bh, bh
		sub bx, 30h
		add ax, bx
		mov di, ax
		
		
		jmp atoi_cycle1
	endwritenm:
	mov sp, bp
	pop bp
	ret
	
get_op:
	push bp
	mov bp, sp
	
	mov ah, 01h
	int 21h
	mov bx, [bp + arg1]
	mov byte ptr[bx], al
	
	mov dx, offset newline
	mov cx, 2
	mov ah, 40h
	mov bx, 1
	int 21h
	
	mov sp, bp
	pop bp
	ret
	
print_num:
	push bp
	mov bp, sp
	sub sp, 2
	mov ax, word ptr[bp + arg1]
	mov [bp + var1], ax
	cmp ax, 0
	jnl norm11
		mov ah, 40h
		mov bx, [bp + arg2]
		mov cx, 1
		mov dx, offset minus1
		int 21h
		mov ax, [bp + var1]
		neg ax
		neg word ptr[bp + var1]
	norm11:
	
	push ax
	call get_len
	add sp, 2
	
	push ax
	mov dx, offset num_buf
	push dx
	push [bp + var1]
	call _itoa
	add sp, 6
	
	mov dx, offset num_buf
	push dx
	call _strlen
	add sp, 2
	
	mov cx, ax
	mov ah, 40h
	mov bx, [bp + arg2]
	mov dx, offset num_buf
	int 21h
	
	mov sp, bp
	pop bp
	ret



start: ; вызов функции calc (модифицировать главную функцию программы не требуется)
    mov ax, data1
    mov ds, ax
    mov ax, data2
    mov es, ax
    mov ax, stack
    mov ss, ax
	
	mov dx, offset file3name ; перезапись файла или создание нового
	push 0
	push dx
	call rewrite_make_file
	add sp, 4
	mov [file3_descr], ax
	
	push word ptr [file3_descr]
	call close_file
	add sp, 2
	
	mov dx, offset file3name
	push 1
	push dx
	call get_file_descriptor
	add sp, 4
	
	mov [file3_descr], ax
	
	mov dx, offset file1name
	push dx
	call get_file_name
	add sp, 2
	
	mov dx, offset file1name
	push 0
	push dx
	call get_file_descriptor
	add sp, 4
	
	mov ds:[file1_descr], ax
	
	mov dx, offset tmp1
	push dx
	push word ptr[file1_descr]
	mov dx, offset m1
	push dx
	mov dx, offset n1
	push dx
	call ReadNM
	add sp, 8
	
	push ds:[file1_descr]
	push ds
	mov dx, offset tmp1
	push dx
	call ReadMatrix
	add sp, 6
	
	mov dx ,offset op_
	push dx
	call get_op
	add sp, 2
	
	mov bx, offset op_
	mov bx, [bx]
	cmp bl, "+"
	je okay_op
	cmp bl, "-"
	je okay_op
	cmp bl, "*"
	je okay_op
	cmp bl, "d"
	je okay_op
	jmp _exit255
	okay_op:
	
	mov bx, offset op_
	mov bx, [bx]
	cmp bl, "d"
	jne no_det
	mov ax, word ptr[n1]
	cmp ax, word ptr[m1]
	jne _exit255
	
	push [file3_descr]
	call _getdet
	add sp, 2
	jmp _exit0
	
	no_det:
	push ds
	
	mov ax, es
	mov ds, ax
	
	mov dx, offset file2name
	push dx
	call get_file_name
	add sp, 2
	
	pop ds
	
	push ds
	mov ax, es
	mov ds, ax
	
	mov dx, offset file2name
	push 0
	push dx
	call get_file_descriptor
	add sp, 4
	
	mov es:[file2_descr], ax
	pop ds
	
	push ds
	mov ax, es
	mov ds, ax
	
	mov dx, offset tmp2
	push dx
	push word ptr[file2_descr]
	mov dx, offset m2
	push dx
	mov dx, offset n2
	push dx
	call ReadNM
	add sp, 8
	
	pop ds
	
	
	push ds
	mov ax, es
	mov ds, ax
	
	push es:[file2_descr]
	push es
	mov dx, offset tmp2 ;es
	push dx
	call ReadMatrix
	add sp, 6
	
    pop ds
	int 3
	cmp byte ptr[op_], "*"
	je ok_op
	cmp byte ptr[op_], "+"
	je ok_op
	cmp byte ptr[op_], "-"
	jne _exit255
	ok_op:
	mov bx, offset op_
	mov bx, [bx]
	push bx
	push word ptr[file3_descr]
	call _calc
	add sp, 4
	call _exit0
	;доделать ошибку с операцией
	;там где вывод числа заменить на print_num
	go_mul:
	mov ax, word ptr[m1]
	cmp ax, word ptr[n2]
	jne _exit255
	push word ptr[file3_descr]
	call _mult
	add sp, 2
	call _exit0

	
code ends

end start