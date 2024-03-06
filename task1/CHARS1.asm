data_s segment para public
str db "Hello, asm!", 0Ah, "$"
str1 db "New string:", 0Ah, "$"
data_s ends

stack_s segment para stack
db 256 dup("?")
stack_s ends

code_s segment para 

assume cs:code_s, ds:data_s, ss:stack_s 

start:
  mov ax, data_s ; ax bx cx dx 
  mov ds, ax
  mov ax, stack_s
  mov ss, ax
  
  mov si, offset str ;
  lea bx, [si + 2]      ; запись адреса третьего символа в регистр bx
  ;mov al, "R"    
  mov byte ptr [bx], "R"     ; запись содержимого регистра al по адресу который лежит в bx
  
  mov dx, offset str  ; вывод строки с измененным символом
  mov ah, 09h
  int 21h
  
  add di, 1
  lea bx, [si + 3]  ;получение адреса смивола, лежащего за изменившемся
  mov dl, [bx]  ; запись символа для дальнейшего применения функции  02h
  mov ah, 02h
  int 21h
  
  mov ax, 4c00h
  int 21h

code_s ends
end start