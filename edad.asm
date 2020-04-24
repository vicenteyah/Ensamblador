PAGE 40,132

TITLE Primer Programa en Ensamblador

COMMENT * Este programa le pide al usuario que ingrese su edad y le dice si es mayor o menor de edad*

;se inicializara el stack a continuacion


;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data' 
       TEXTO DB 0AH,0DH,"Ingrese su edad y presione enter: ",0AH,0DH,"$"
       TEXTO2 DB 0AH,0DH,"Usted es mayor de edad ",0AH,0DH,"$"
       TEXTO4 DB 0AH,0DH,"Usted es menor de edad ",0AH,0DH,"$"
       TEXTO3 DB 0AH,0DH,"¿Desea terminar el programa(0) o realizar la operacion de nuevo(1)?",0AH,0DH,"$"
       VALOR DB 3,3 DUP (0)
             DB 0AH,0DH,"$"
       TAM1 DB 2 DUP ("$")
            DB 0AH,0DH,"$"
       SALIDA DB 2,2 DUP ("$")
       RESULTADO DB 6 DUP ("$"),0AH,0DH,"$"
data ends

code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       PUSH DS
       SUB AX,AX
       PUSH AX
       MOV AX,SEG DATA	
       MOV DS,AX
       
INICIO:
       MOV AH,00H
       MOV AL,03H
       INT 10H

       MOV AH,09H		;Pedimos al usuario que ingrese su edad
       MOV DX, OFFSET TEXTO
       INT 21H 
      
       MOV AH,0AH
       MOV DX, OFFSET VALOR
       INT 21H
 
       MOV AH,09H
       MOV DX, OFFSET VALOR[2]
       INT 21H

       MOV CL,VALOR[1]
       MOV TAM1,CL
       MOV AH,VALOR[2]
       MOV AL,VALOR[3]

       CMP TAM1,01H
       JE UNO
       JMP OPERACION

UNO:
       MOV AH,00		
       MOV AL,VALOR[2]

OPERACION:
       CMP AX,"18"
       JAE MAYOREDAD
       JB MENOREDAD

MAYOREDAD:
       MOV AH,09H
       MOV DX, OFFSET TEXTO2
       INT 21H
       JMP FIN

MENOREDAD:
       MOV AH,09H
       MOV DX, OFFSET TEXTO4
       INT 21H
       JMP FIN

FIN:
       MOV AH,09H
       MOV DX, OFFSET TEXTO3
       INT 21H

       MOV AH,0AH
       MOV DX, OFFSET SALIDA
       INT 21H
       MOV BL,SALIDA[2]
       CMP BL,"1"
       JNE SALIR
       JMP INICIO

SALIR:
       RET
prueba endp

code ends

END prueba