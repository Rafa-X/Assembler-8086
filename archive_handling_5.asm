;Program that make simple archive handling operations
;using the INT 21H

;Conditions:
;- only fixed routes in vars to prevent changes in other directories 


TITLE archive_handling
.MODEL SMALL
ORG 100H

.DATA
    row  db 0  ;variable para posicionar cursor 
    
    fname  db "Rafael Delgadillo Ramirez$"
    handle dw ?  ;manejador de archivo
    
    ;ascii de la ruta y nombres de los ficheros
    directorio0 db "C:\emu8086\MyBuild", 0, '$'
    directorio1 db "C:\emu8086\MyBuild\dir1", 0, '$'
    directorio2 db "C:\emu8086\MyBuild\dir1\dir2", 0, '$'
    ;ascii de la ruta y nombre del archivo 
    archive db "C:\emu8086\MyBuild\dir1\dir2\1erNombre.txt", 0, '$'    
    
    error db "Error en la ejecucion.$"
    
.CODE
MAIN PROC NEAR        
    MOV AX, @DATA
    MOV DS, AX
    
  DIRECTORIOS:
    ;directorio del archivo
    mov ah, 39h         ;crea directorio que apunta DS:DX
    lea dx, directorio1 ;direccion de memoria de variable directorio                                                
    int 21h
    call IMPRIME_RUTA
    
    ;directorio vacio
    mov ah, 39h         ;crea directorio que apunta DS:DX
    lea dx, directorio2 ;direccion de memoria de variable directorio                                                
    int 21h
    call IMPRIME_RUTA             
    
  CREAR: 
    mov ah, 3Ch         ;creara archivo al que DS:DX apunta
    mov cx, 00H         ;atributos del archivo: normal
    lea dx, archive     ;direccion de memoria de variable
    int 21h
    JC SALIR       ;si hubo error
    mov handle, ax ;si no hubo error
    call IMPRIME_RUTA
    
  ESCRIBIR:
    mov ah,40h        ;escribe en archivo valores que apunta DS:DX
    mov bx,handle     ;mover handfile
    mov cx,25         ;num de caracteres a grabar
    lea dx,fname      ;carga direccion de memoria de nombre
    int 21h
    jc SALIR ;Si hubo error
    call IMPRIME_RUTA
  
  CIERRA:  
    mov bx, handle    ;carga manejador de archivo
    mov ah, 3Eh       ; cierra archivo que manejador especifica,
    int 21h           ; actualiza el directorio y se remueven
                      ; los buffers internos del archivo 
    jc SALIR  ;si hubo error                                                                       
  
  BORRA:    
    ;archivo
    mov ah, 41h       ;funcion borrar archivo
    lea dx, archive   ;carga direccion de memoria de archivo
    int 21h
    jc SALIR ;Si hubo error 
    
    ;dir2
    mov ah, 3Ah          ;funcion borra fichero
    lea dx, directorio2  ;carga direccion de memoria de fichero
    int 21h
    jc SALIR ;Si hubo error
    
    ;dir1
    mov ah, 3Ah          ;funcion borra fichero                
    lea dx, directorio1  ;carga direccion de memoria de fichero
    int 21h
    jc SALIR ;Si hubo error
    
  REGRESA:
    mov ah, 3Bh           ;cambio de directorio, apunta DS:DX 
    lea dx, directorio0   ;carga direccion de memoria de fichero                                               
    int 21h
    call IMPRIME_RUTA
    jc SALIR  ;si error
    jmp FIN   ;si todo bien
  
  SALIR:
    MOV AH, 09H
    LEA DX, error
    INT 21H
    
  FIN:
    MOV AH, 4CH
    INT 21H

MAIN ENDP                                        

;------------------------------------------------
IMPRIME_RUTA PROC NEAR
    ;IMPRIME RUTA
    MOV AH,09
    INT 21h
    
    ;POSICIONA CURSOR
    INC row
    MOV AH, 02H  ;funcion posicionar cursor
    MOV BH, 00H  ;numero de pagina 0
    MOV DH, row  ;renglon
    MOV DL, 0    ;columna
    INT 10H
    
    ret
IMPRIME_RUTA ENDP

END MAIN