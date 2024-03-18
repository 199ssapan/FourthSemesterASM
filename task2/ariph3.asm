data_s segment para public
    a dw 1234h;
    b dw 123h;
    sum dw 0;
    sum_2 dw 0,0
    c dw 0,0,0,0
data_s ends

stack_s segment stack
    dw 128 dup(0)
stack_s ends

code_s segment

assume cs:code_s, ds:data_s, ss:stack_s

start:

    mov ax, data_s
    mov ds, ax
    mov ax, stack_s
    mov ss, ax
    
    xor cx, cx
    xor bx, bx    
    
    mov ax, word ptr[a]
    add ax, word ptr[b]
    mov word ptr[sum], ax
    
    imul ax
    mov word ptr[sum_2+2], dx
    mov word ptr[sum_2], ax
                       
    mov ax,word ptr [sum_2]
    imul word ptr [sum]
    mov di,ax
    mov si,dx
 
    mov ax,word ptr [sum_2+2]
    mul word ptr [sum]
    add si,ax
    adc cx,dx
 
    mov word ptr [c],di
    mov word ptr [c+2],si 
    mov word ptr [c+4],cx 
    
    mov ax, 4c00h
    int 21h    
code_s ends

end start