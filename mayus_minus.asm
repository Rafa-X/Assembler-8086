;Program that change the tipography of 2 strings declared in variables, 
; convert uppercase to lowercase and viceversa, and print them in screen
; in different positions

;To see the changes in live see the vars section during emulation


PAGE 60,132
TITLE PROG6.EXE
.MODEL SMALL
;_____________________________________
.STACK 64
.DATA
mayus DB 'CAMBIAR A MINUSCULAS','$'
minus DB 'cambiar a mayusculas','$'

row DB 0  ;row for cursor
col DB 0  ;column for cursor

;_____________________________________
.CODE
MAIN PROC NEAR

    MOV AX, @DATA
    MOV DS, AX
    
    ;PRINT INITIAL STATE
    CALL IMPRIMIR
    
    ;CONVERT
    CALL ALTERNAR-MAYUSCULAS-MINUSCULAS
    CALL ALTERNAR-MINUSCULAS-MAYUSCULAS
    
    ;POSITIONS CURSOR AND PRINT STRINGS
    MOV row, 6  ;change row for cursor
    MOV col, 2  ;change column for cursor
    CALL CURSOR ;positions cursor
    CALL IMPRIMIR
                     
    MOV AX,4C00H
    INT 21H 
    
MAIN ENDP

;---------------------------------------
ALTERNAR-MAYUSCULAS-MINUSCULAS PROC NEAR  
    ;CAMBIA MAYUSCULAS POR MINUSCULAS
    LEA BX, mayus        
    MOV CX,20          
    OTRO: 
        MOV AH, [BX]     ;move letter to convert
        CMP AH,41H       ;compare if blank space  
        JB OTRO2         ;jump if blank space  
        CMP AH,5AH         
        JA OTRO2           
        OR AH,00100000B  ;convert letter  
        MOV [BX], AH     ;saves converted letter  
    OTRO2: 
        INC BX           ;increases alternated letters
        LOOP OTRO                  
    RET                    
ALTERNAR-MAYUSCULAS-MINUSCULAS ENDP

;---------------------------------------
ALTERNAR-MINUSCULAS-MAYUSCULAS PROC NEAR 
    ;CAMBIA MINUSCULAS POR MAYUSCULAS
    LEA BX, minus        
    MOV CX, 20         
    OTRO3: 
        MOV AH,[BX]       ;move letter to convert      
        CMP AH, 61H       ;compare if blank space      
        JB OTRO4          ;jump if blank space         
        CMP AH, 7AH                                    
        JA OTRO4                                       
        AND AH,11011111B  ;convert letter              
        MOV [BX], AH      ;saves converted letter      
    OTRO4:                                             
        INC BX            ;increases alternated letters
        LOOP OTRO3
    RET 
ALTERNAR-MINUSCULAS-MAYUSCULAS ENDP

;---------------------------------------
IMPRIMIR PROC NEAR
    ;IMPRIMIR CADENAS
    MOV AH, 09H
    LEA DX, mayus
    INT 21H
    
    inc row  ;increases row pos
    inc col  ;increases column pos
    CALL CURSOR
    
    MOV AH, 09H
    LEA DX, minus
    INT 21H
    RET
IMPRIMIR ENDP

;---------------------------------------
CURSOR PROC NEAR    
    ;POSICIONA CURSOR
    MOV AH, 02H  ;function position cursor
    MOV BH, 00H  ;screen page number 0 (default screen)
    MOV DH, row  ;row 
    MOV DL, col  ;column
    INT 10H
    RET
CURSOR ENDP

END MAIN