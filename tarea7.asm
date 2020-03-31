PAGE 40,132

TITLE Ejemplo de Programa en Ensamblador

COMMENT * Este programa muestra en pantalla los valores de las variables ordenados ascendentemente*

;se inicializara el stack a continuacion

;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data' 
        TEXTO1 DB "Inserte 10 numeros de dos digitos separados por comas sin espacios",0AH,0DH,"$"
        DATOS DB 30,32 DUP ("$"),0AH,0DH,"$"
        TEXTO2 DB "Los numeros son: ",0AH,0DH,"$"

data ends

code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       PUSH DS
       SUB AX,AX
       PUSH AX
       MOV AX,SEG DATA	;Estas dos instrucciones siempre las van a poner
       MOV DS,AX

       MOV AH,00H
       MOV AL,03H
       INT 10H
     
       MOV CX,42
       MOV SI,2
       MOV DI,5
       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO1
       INT 21H

       MOV AH,0AH
       MOV DX,OFFSET DATOS
       INT 21H			;Lee la tecla
       JMP ciclo

cambio_num:
      INC SI
      INC SI
      INC SI
      MOV DI,SI
      INC DI
      INC DI
      INC DI

ciclo:
       ;MOV BX, OFFSET DATOS
       MOV BH,DATOS[SI]		;Posicion 2 del arreglo
       MOV BL,DATOS[SI+1]
       MOV DH, DATOS[DI]	;Posicion 5 del arreglo
       MOV DL, DATOS[DI+1]
       CMP BX,DX
       JE ir_ciclo
       JA cambio
       JMP ir_ciclo

cambio:
       CMP DI,32
       JE fin_ciclo
       MOV DATOS[DI],BH
       MOV DATOS[DI+1],BL
       MOV DATOS[SI],DH
       MOV DATOS[SI+1],DL
       JMP ir_ciclo

ir_ciclo:
       CMP SI,29
       JE fin_ciclo
       CMP DI,29
       JE cambio_num
       INC DI
       INC DI
       INC DI
       LOOP ciclo
      
fin_ciclo:
       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO2
       INT 21H

       MOV DX, OFFSET DATOS
       MOV AH,09H
       INT 21H


       RET

prueba endp

code ends

END prueba