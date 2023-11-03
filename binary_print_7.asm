;Program that prints a binary number as a string
;Use functions from the INT 21H to print and INT 10H to place the cursor on screen

;Conditions:
;   -Only less than 8 bit binary number


TITLE ACTIVIDAD7
.MODEL SMALL
ORG 100H

.DATA           
    reinicio db 1  ;n+1 veces que imprimira las secuencias
    
    bin db 00000001b  ;numero binario de 8 bits
    str db 8 dup('0'), '$' ;buffer para la cadena de caracteres
    
    row DB 1 ;renglon para posicionar cursor
    col DB 0 ;columna para posicionar cursor
    
.CODE
MAIN PROC NEAR 
    MOV AX, @DATA
    MOV DS, AX  
       
  CONVERSION:
    mov si, 7    ;inicializa el indice para guardar cadena,
                 ;guarda de izquierda a derecha
    mov al, bin  ;carga numero binario
    
    call CONVERT  ;imprime binario en pantalla
    
  DEZPLAZA:
    shl bin, 1  ;desplaza izq una vez imprime el binario
    
    ;evalua si imprimio secuencia completa
    clc                ;reinicia bandera para evaluar comparacion
    cmp bin, 00000000b ;numero maximo desplazado
    je REINICIA        ;salta a loop para hacer otra secuencia
     
    jmp CONVERSION
    
  REINICIA: ;evalua si imprime o no otra secuencia
    cmp reinicio, 0  ;evalua si imprimira otra secuencia
    jz TERMINA       ;NO imprime
    
    dec reinicio     ;decrementa cantidad de secuencias
    add bin, 1b      ;"restablece" valor binario
    mov row, 1       ;restablece renglon para cursor
    add col, 12      ;aumenta columna para cursor
    jnz CONVERSION   ;SI imprime
    
  TERMINA:  
    mov ax, 4C00H
    int 21h
    
MAIN ENDP

;-------------------------------------------
CONVERT PROC NEAR
    mov cx, 8  ;establece contador para bucle
    
  INICIO:
    shr al, 1  ;desplazamiento a la derecha
               ;saca bit menos significativo y se guarda en CF
    
    jc  one   ;salta si desplazamiento saco un 1
    jnc zero  ;salta si desplazamiento saco un 0
    
    one:
        mov str[si], '1'  ;indexa el valor como cadena
        jmp fin
    zero:
        mov str[si], '0'  ;indexa el valor como cadena
        jmp FIN
    
    FIN:    
        dec si  ;decrementa indice
        LOOP INICIO
        
    ;imprime valor binario
    call CURSOR  ;posiciona cursor
    mov ah, 09h  ;funcion imprimir cadena
    lea dx, str  ;carga direccion de binario como cadena
    int 21h
    RET
    
CONVERT ENDP

;-------------------------------------------
CURSOR PROC NEAR
    MOV AH, 02H  ;funcion posicionar cursor
    MOV BH, 00H  ;numero de pagina 0
    MOV DH, row  ;renglon
    MOV DL, col  ;columna
    INT 10H
    
    INC row      ;incrementa posicion de renglon
    RET
CURSOR ENDP

END MAIN