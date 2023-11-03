;Program that prints 2 messages in different points of the emulator screen

;The first in the default position and the second in the specified
;Algo changes the color atributes of the background ant text


PAGE 60, 132
TITLE VIDEO_EXAMPLE
.MODEL SMALL
.STACK 64

.DATA
    msg1 DB 'POSICION 1', '$'
    msg2 DB 'POSICION 2', '$'
    
.CODE 
MAIN PROC NEAR
    MOV AX, @DATA
    MOV DS, AX
    
    ;BORRA PANTALLA Y CAMBIA ATRIBUTOS COLOR
    MOV AH, 06H  ;funcion recorrido de pantalla
    MOV AL, 00H  ;numero de lineas a desplazar
    MOV BH, 71H  ;atributos de color fondo y texto
    MOV CX, 00   ;00:00 renglon / columna inicial
    MOV DH, 24   ;renglon final
    MOV DL, 80   ;columna final
    INT 10H
    
    ;IMPRIME MENSAJE 1
    MOV AH, 09H             ;funcion imprimir string
    MOV DX, OFFSET msg1  ;carga mensaje
    INT 21H
    
    ;POSICIONA CURSOR
    MOV AH, 02H  ;funcion posicionar cursor
    MOV BH, 00H  ;numero de pagina 0
    MOV DH, 08   ;renglon 8
    MOV DL, 20   ;columna 20
    INT 10H
    
    ;IMPRIME MENSAJE 2
    MOV AH, 09H             ;funcion imprimir string
    MOV DX, OFFSET msg2  ;carga mensaje
    INT 21H
    
    MOV AH, 4CH
    INT 21H
    ENDP MAIN

END MAIN