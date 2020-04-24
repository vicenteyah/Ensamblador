PAGE 40,132

TITLE Ejemplo de Programa en Ensamblador

COMMENT * Este programa muestra en pantalla la suma de los valores ingresados por el usuario*

;se inicializara el stack a continuacion

;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data' 
        TEXTO1 DB 0AH,0DH,"Inserte 2 numeros de 2 digitos separados por un signo de mas, sin espacios y al final presione enter",0AH,0DH,"$"
        DATOS DB 7,8 DUP ("$")
              DB 0AH,0DH,"$"
        RESPUESTA DB 6 DUP ("$"),0AH,0DH,"$"
        TEXTO2 DB  0AH,0DH,"Los numeros son: ",0AH,0DH,"$"
        TEXTO3 DB  0AH,0DH,"La respuesta es: ",0AH,0DH,"$"
        TEXTO4 DB 0AH,0DH,"¿Desea salir del programa(0) o hacer otra suma(1)? ",0AH,0DH,"$"
        SALIDA DB 3,2 DUP ("$"),0AH,0DH,"$"

data ends

code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       PUSH DS
       SUB AX,AX
       PUSH AX
       MOV AX,SEG DATA	;Estas dos instrucciones siempre las van a poner
       MOV DS,AX
inicio:
       MOV AH,00H
       MOV AL,03H
       INT 10H
     
       MOV AH,09H		;Funcio 09H para mostrar instrucciones de ordenamiento
       MOV DX, OFFSET TEXTO1
       INT 21H

       MOV DX, OFFSET DATOS
       MOV AH,0AH
       INT 21H

       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO2
       INT 21H

       MOV DX, OFFSET DATOS
       MOV AH,09H
       INT 21H

       MOV AH,DATOS[2]		
       MOV AL,DATOS[3]

       MOV CH,DATOS[5]		
       MOV CL,DATOS[6]
       
       ADD AL,CL		
       AAA			;Ajusta la suma y expresa como BCD descompensado
       OR AX,3030H		;ADD AX,0030H
       				;SUB AX,3000H
       MOV RESPUESTA[2],AL

       MOV AL,AH
       MOV AH,00
       ADD AL,CH
       AAA
       OR AX,3030H
       MOV RESPUESTA[1],AL
       MOV RESPUESTA[0],AH
       ;XCHG AH,AL
       ;MOV RESPUESTA,AX

       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO3
       INT 21H

       MOV DX, OFFSET RESPUESTA
       MOV AH,09H
       INT 21H

       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO4
       INT 21H

       MOV AH,0AH
       MOV DX,OFFSET SALIDA
       INT 21H			;Lee la tecla
       MOV BL,SALIDA[2]
       CMP BL,"1"
       JNE salir
       JMP inicio

salir:
       RET

prueba endp

code ends

END prueba
