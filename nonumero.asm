PAGE 40,132

TITLE Primer Programa en Ensamblador

COMMENT * Este programa indica al usuario que ingrese un número (10 dígitos máximo), cada tres dígitos se agrega una coma al número*

;se inicializara el stack a continuacion


;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data' 
       TEXTO DB 0AH,0DH,"Ingrese un numero de maximo 10 digitos",0AH,0DH,"$"
       TEXTO2 DB 0AH,0DH,"El resultado es:",0AH,0DH,"$"
       DATO DB 15,15 DUP ("$")
            DB 0AH,0DH,"$"
       TEXTO3 DB 0AH,0DH,"¿Desea salir del programa(0) o hacer otra suma(1)? ",0AH,0DH,"$"
       SALIDA DB 3,2 DUP ("$"),0AH,0DH,"$"

data ends

code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       PUSH DS
       SUB AX,AX
       PUSH AX
       MOV AX,SEG DATA	
       MOV DS,AX
inicio:
       MOV AH,00H
       MOV AL,03H
       INT 10H
NAN:   
       MOV AH,09H
       MOV DX, OFFSET TEXTO
       INT 21H

       MOV AH,0AH
       MOV DX, OFFSET DATO
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET DATO
       INT 21H

       MOV CX,10
       MOV SI,2
       MOV BL,DATO[1]
       ADD BL,01
       MOV BH,00
CICLO:
       MOV AL,DATO[SI]
       CMP AL,"0"
       JB NAN
       CMP AL,"9"
       JA NAN
       INC SI
       CMP SI,BX
       JA FINARREGLO
       LOOP CICLO

FINARREGLO:
       MOV CX,10
       MOV SI,2
       ADD BL,01
CICLO2:
       MOV AL,DATO[SI]
       CMP SI,5
       JE COMA
       CMP SI,9
       JE COMA
       ADD BL,01
       CMP SI,13
       JE COMA
       INC SI
       CMP SI,BX
       JA FINAL
       LOOP CICLO2
       JMP FINAL
COMA:
       MOV DI,SI
       PUSH CX
       MOV CL,DATO[DI]
       MOV CH,DATO[DI]
       MOV CL,","
       MOV DATO[DI],CL
CICLO3:
       INC DI
       MOV CL,DATO[DI]
       MOV DATO[DI],CH
       INC DI
       MOV CH,DATO[DI]
       MOV DATO[DI],CL
       CMP DI,BX
       JBE CICLO3
       INC SI
       POP CX
       JMP CICLO2

FINAL:
       MOV AH,09H
       MOV DX,OFFSET TEXTO2
       INT 21H

       MOV AH,09H
       MOV DX,OFFSET DATO
       INT 21H

       MOV AH,09H		
       MOV DX, OFFSET TEXTO3
       INT 21H

       MOV AH,0AH
       MOV DX,OFFSET SALIDA
       INT 21H			
       MOV BL,SALIDA[2]
       CMP BL,"1"
       JNE salir
       JMP inicio
salir:
       RET

prueba endp

code ends

END prueba
