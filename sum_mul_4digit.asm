;Program that receives 2 positive numbers, and print the sum and
;multiplication between them, displays results up to 4 digits

;Conditions:
;- only positive numbers
;- numbers of maximum 2 digits


TITLE 2NUMS_OPS
.MODEL SMALL
.STACK 100H

.DATA
    u db 0     ;unidades para escanear numero
    d db 0     ;decenas  para escanear numero
    num1 DB ?  ;numero ingresado 1
    num2 DB ?  ;numero ingresado 2
    suma DW ?  ;resultado suma
    mult DW ?  ;resultado multiplicacion
    
    msg  DB 10,13,17,'Ingrese un numero: ','$'
    msgs DB 10,13,17,'Suma: ','$'
    msgm DB 10,13,17,'Multiplicacion: ','$'

.CODE
MAIN PROC NEAR
    MOV AX, DATA
    MOV DS, AX
    CALL LEE_NUM  ;obtiene los numeros por teclado
    
    ;SUMA
    MOV AL, num1    
    ADD AL, num2
    MOV suma, AX
 
    ;MULTIPLICACION
    MOV AL, num1
    MOV BL, num2
    MUL BL
    MOV mult, AX 
    
    ;IMPRESION RESULTADOS
    mov ah,09h   ;imprime mensaje suma
    lea dx,msgs  
    int 21h
    MOV AX, suma ;carga valor para impresion
    CALL IMPRESION
    
    mov ah,09h   ;imprime mensaje multiplicacion
    lea dx,msgm  
    int 21h
    MOV AX, mult ;carga valor para impresion
    CALL IMPRESION 
    
    MOV AH, 4CH
    INT 21H
MAIN ENDP 

;-----------------------------------------------------------------
LEE_NUM PROC NEAR
    CALL SCAN_NUM ;obtiene el numero y lo guarda en AL
    MOV num1, AL
    CALL SCAN_NUM ;obtiene el numero y lo guarda en AL
    MOV num2, AL
    RET
LEE_NUM ENDP
;-----------------------------------------------------------------
SCAN_NUM PROC NEAR
    mov ah,09h
    lea dx,msg  
    int 21h 
    
    mov ah,01h       ;Introduzco las decenas
    int 21h       
    sub al,30h       ;ajusta ascii sumando 30h
    mov d,al    
    
    mov ah,01h       ;Introduzco las unidades
    int 21h       
    sub al,30h       ;ajusta ascii sumando 30h
    mov u,al
    
    mov al,d         
    mov bl,10        ;multiplica para ajustar decena y suma unidad
    mul bl           ; al = d * 10
    add al,u         ; al = d * 10  + u
    RET        
SCAN_NUM ENDP
;-----------------------------------------------------------------
IMPRESION PROC NEAR
    ;Convertir el nUmero a caracteres ASCII
    mov cx, 10        ; Dividir por 10 para obtener digitos
    mov bx, 0         ; BX se utilizara para construir el numero ASCII
    
    ; Loop para extraer digitos
    extraer_digitos:
        xor dx, dx       ; Limpiar DX para la division
        div cx           ; Divide AX por 10, el cociente en AL, el residuo en AH
        add dl, '0'      ; Convertir el residuo a ASCII
        push dx          ; Empujar el digito en la pila
        inc bx           ; Incrementar contador de digitos
        
        test ax, ax      ; Verificar si quedan digitos
        jnz extraer_digitos
    
    ; Imprimir los digitos en orden inverso
    imprimir_digitos:
        pop dx           ; Pop digito de la pila
        mov ah, 2        ; Funcion 2 de la interrupcion 21h (imprimir caracter)
        int 21h          ; Llamar a la interrupcion 21h
        dec bx           ; Decrementar contador de digitos
        jnz imprimir_digitos ; Repetir si quedan digitos
        
    RET
IMPRESION ENDP
;-----------------------------------------------------------------

END MAIN