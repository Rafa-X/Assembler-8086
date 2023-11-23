;Variables 10,13,17 = (10,13 Posicion X,Y) (17 Simbolo)

TITLE PROYECTO
.MODEL SMALL
.STACK 100H

.DATA     
    num1 DW ?  ;input number 1
    num2 DW ?  ;input number 2
    u db 0     ;units of the inputed numbers
    d db 0     ;dozens of the inputed numbers
    
    summ DW ?  ;sum result
    subb DW ?  ;substract result
    mull DW ?  ;multiplication result
    divv DB ?  ;division result
    poww DW ?  ;power result    
    
    row DB ?   ;cursor row
    col DB ?   ;cursor column
    
    menu DB          '  CALCULADORA'    ,
         DB 10,13,16,' 1.Sum'           ,
         DB 10,13,16,' 2.Substract'     ,
         DB 10,13,16,' 3.Multiplication',
         DB 10,13,16,' 4.Division'      ,
         DB 10,13,16,' 5.Potencia'      , 
         DB 10,13,16,' 0.Exit program'  ,
         DB 10,13,16,' Seleccion: '     ,'$'
         
    opt  DB ?  ;menu option selected
    
    msgn1 DB 10,13,17,' Enter the number 1: ','$'
    msgn2 DB 10,13,17,' Enter the number 2: ','$'
    msg1  DB 10,13,17,' Sum: $'
    msg2  DB 10,13,17,' Substract: $'     
    msg3  DB 10,13,16,' Multiplication: $'                        
    msg4  DB 10,13,16,' Division: $'                              
    msg5  DB 10,13,16,' Potencia: $'
    msgdiv DB 10,13,17,' No se puede dividir entre 0 $'                              

.CODE                
MAIN PROC NEAR       
    MOV AX, DATA
    MOV DS, AX
    
  START:
    CALL CLEAN   ;clean the screen and position the cursor on 0,0
    MOV row, 0
    MOV col, 0
    CALL CURSOR
    
    MOV AH, 09H   ;function print string
    LEA DX, menu  ;prints the menu
    INT 21H
    
    MOV AH, 01H  ;function get char from keyboard
    INT 21H
    SUB AL, 30H  ;convert the input from ascii to decimal
    MOV opt, AL  ;move the input to var
    
    ;make a comparison to check if exit or an invalid option
    CMP opt, 0   
    JE FIN
      
    
    ;if option is not 0, ask for the numbers to calculate with
    ; and then continue with the option comparisons
    CALL READ_NUMS
      
    CMP opt, 1   
    JE OPT1      
    CMP opt, 2   
    JE OPT2
    CMP opt, 3
    JE OPT3
    CMP opt, 4
    JE OPT4
    CMP opt, 5
    JE OPT5   
    
  OPT1:             ;call the proc of the selected operation
    CALL PROC_SUM
    JMP START       ;loop to the menu
  OPT2:
    CALL PROC_SUB
    JMP START
  OPT3:
    CALL PROC_MUL
    JMP START
  OPT4:
    CALL PROC_DIV
    JMP START
  OPT5:
    CALL PROC_POW
    JMP START  
    
  FIN:
    MOV AH, 4CH  ;end program
    INT 21H     
MAIN ENDP 

;------------------------------------------------
READ_NUMS PROC NEAR
    MOV row, 9
    MOV col, 1
    CALL CURSOR  ;position the cursor
    
    MOV AH, 09H        ;function print string 
    LEA DX, msgn1      ;string asking for number
    INT 21H
    CALL INPUT_NUMBER  ;user input numbers to calculate
    MOV num1, AX       ;move the inputed number to var
    
    MOV AH, 09H  
    LEA DX, msgn2
    INT 21H      
    CALL INPUT_NUMBER  
    MOV num2, AX
    
  FIN_R:
    RET
READ_NUMS ENDP

;------------------------------------------------
INPUT_NUMBER PROC NEAR        
    mov ax, 0
    
    mov ah,01h   ;function get char from keyboard
    int 21h      
    sub al,30h   ;convert input from ascii to decimal
    mov d,al     ;dozens - saves in var 
    
    mov ah,01h   
    int 21h
    cmp al, 0Dh  ;compare the digit with hex for ENTER keyboard
    je ONE       ;if enter pressed, means its a one digit number     
    sub al,30h   ;convert input from ascii to decimal
    mov u,al     ;units - saves in var
    jmp TWO      ;if reach this point means is a two digit number
     
  ONE:
    mov ah, 0
    mov al, d    ;add the only digit
    jmp FIN_I
  
  TWO:
    mov al,d     
    mov bl,10    ;Multiply to set dozens and then add units
    mul bl       ; al = d * 10 + u
    add al,u      
    
  FIN_I:  
    RET 
INPUT_NUMBER ENDP

;------------------------------------------------
PROC_SUM PROC NEAR
    ;SUM
    MOV AX, num1    
    ADD AX, num2
    MOV summ, AX
    
    ;PRINT RESULT
    MOV AH, 09H  ;print the name of operation
    LEA DX, msg1  ;name of operation to print
    INT 21H
    
    MOV AX, summ  ;load in AX the operation result
    CALL PRINT_RESULT  ;print the operation result
        
    RET
PROC_SUM ENDP

;------------------------------------------------
PROC_SUB PROC NEAR
    ;SUBSTRACT
    MOV AX, num1    
    SUB AX, num2
    MOV subb, AX
    
    ;PRINT RESULT
    MOV AH, 09H  ;print the name of operation
    LEA DX, msg2  ;name of operation to print
    INT 21H
    
    MOV AX, subb  ;load in AX the operation result
    CALL PRINT_RESULT  ;print the operation result
        
    RET
PROC_SUB ENDP

;------------------------------------------------
PROC_MUL PROC NEAR
    ;MULTIPLICATION
    MOV AX, num1    
    MOV BX, num2
    MUL BX
    MOV mull, AX
    
    ;PRINT RESULT
    MOV AH, 09H  ;print the name of operation
    LEA DX, msg3  ;name of operation to print
    INT 21H
    
    MOV AX, mull  ;load in AX the operation result
    CALL PRINT_RESULT  ;print the operation result
        
    RET
PROC_MUL ENDP

;------------------------------------------------
PROC_DIV PROC NEAR
    ;DIVISION
    MOV AX, num1    
    MOV BX, num2
    CMP BX, 0
    JE DIV0
    DIV BL
    MOV divv, AL
    
    ;PRINT RESULT
    MOV AH, 09H  ;print the name of operation
    LEA DX, msg4 ;name of operation to print
    INT 21H
    
    MOV AH, 0    ;to avoid errors during printing
    MOV AL, divv  ;load in AX the operation result
    CALL PRINT_RESULT  ;print the operation result
    
  DIV0:
    MOV AH, 09H
    LEA DX, msgdiv
    INT 21H
    
    mov ah, 01H  ;function get char from keyboard
    int 21h      ; used as an standby to see the result      
    RET
PROC_DIV ENDP

;------------------------------------------------
PROC_POW PROC NEAR
    ;POWER
    MOV AX, num1   ;number to calculate   
    SUB num2, 1
    MOV CX, num2   ;times to power the number
    MOV BX, num1   ;power value
    
  POWER:
    MUL BX
    LOOP POWER
    MOV poww, AX
    
    ;PRINT RESULT
    MOV AH, 09H  ;print the name of operation
    LEA DX, msg5  ;name of operation to print
    INT 21H
    
    MOV AX, poww  ;load in AX the operation result
    CALL PRINT_RESULT  ;print the operation result
        
    RET
PROC_POW ENDP

;------------------------------------------------
;------------------------------------------------
PRINT_RESULT PROC NEAR
    mov cx, 10  ;divide by 10 to obtain one digit at time
    mov bx, 0   ;counter for the extracted digits
    
    ;extract the numbers individually as digits
    EXTRACT:
        xor dx, dx   ;clear DX to store the next division
        div cx       ;DX / 10, quotient in AL, residue in AH
        add dl, '0'  ;onvertir el residuo a ASCII
        push dx      ;push the digit in the stack
        inc bx       ;increase the digit counter
        
        test ax, ax  ;check if there are more digits in AX
        jnz EXTRACT  ;repeat if there are more
    
    ;print the digits
    PRINT:
        pop dx     ;pop the digit from the stack
        mov ah, 2  ;function print char
        int 21h    
        dec bx     ;decrease the digits counter
        jnz PRINT  ;repeat if there are more digits in stack
        
    mov ah, 01H  ;function get char from keyboard
    int 21h      ; used as an standby to see the result
        
    RET
PRINT_RESULT ENDP

;------------------------------------------------
CURSOR PROC NEAR
    MOV AH, 02H  ;function locate cursor
    MOV BH, 00H  ;console page number 0
    MOV DH, row  ;row
    MOV DL, col  ;column
    INT 10H
    
    INC row      ;increase the row position
    RET
CURSOR ENDP

;------------------------------------------------
CLEAN PROC NEAR
    MOV AX,0600H  ;function clean screen
    MOV BH,30     ;text and backcolor color atributes 
    MOV CX,0000   ;CH:CL = row-columns initials  
    MOV DX,184FH  ;DH:DL = row-columns finals   
    INT 10H
RET
CLEAN ENDP

END MAIN