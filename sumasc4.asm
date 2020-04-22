PAGE 40,132

TITLE Primer Programa en Ensamblador

COMMENT * Este programa suma dos números de distintos tamaños (mínimo 2 dígitos, máximo 4 dígitos cada número)*

;se inicializara el stack a continuacion


;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data' 
       TEXTO DB 0AH,0DH,"Ingrese un valor de maximo 4 digitos sin espacio y presione enter: ",0AH,0DH,"$"
       TEXTO2 DB 0AH,0DH,"El resultado de la suma es: ",0AH,0DH,"$"
       TEXTO3 DB 0AH,0DH,"¿Desea terminar el programa(0) o realizar una nueva suma(1)?",0AH,0DH,"$"
       TEXTO4 DB 0AH,0DH,"Ingrese otro valor de maximo 4 digitos sin espacio y presione enter: ",0AH,0DH,"$"
       VALOR DB 5,5 DUP (0)
             DB 0AH,0DH,"$"
       TAM1 DB 2 DUP ("$")
            DB 0AH,0DH,"$"
       TAM2 DB 2 DUP ("$")
            DB 0AH,0DH,"$"
       VALOR2 DB 5,5 DUP (0)
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

       MOV AH,09H		;Pedimos al usuario que ingrese el primer valor
       MOV DX, OFFSET TEXTO
       INT 21H 
      
       MOV AH,0AH
       MOV DX, OFFSET VALOR
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET VALOR[2]
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET TEXTO4	;Pedimos al usuario que ingrese el segundo valor
       INT 21H 
      
       MOV AH,0AH
       MOV DX, OFFSET VALOR2
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET VALOR2[2]
       INT 21H

       MOV CL,VALOR[1]
       MOV TAM1,CL
       MOV AH,VALOR[4]		;Acomodamos el primer valor
       MOV AL,VALOR[5]
       MOV BH,VALOR[2]
       MOV BL,VALOR[3]

       MOV CL,VALOR2[1]
       MOV TAM2,CL
       MOV CH,VALOR2[2]		;Acomodamos el segundo valor
       MOV CL,VALOR2[3]
       MOV DH,VALOR2[4]
       MOV DL,VALOR2[5]

       CMP TAM1,03H
       JE TRES
       CMP TAM1,02H
       JE DOS
       JMP SUMA
TRES:
       MOV BH,00
       MOV BL,VALOR[2]
       MOV AH,VALOR[3]		;Acomodamos el primer valor
       MOV AL,VALOR[4]
       JMP SUMA

DOS:
       MOV AH,VALOR[2]		;Acomodamos el primer valor
       MOV AL,VALOR[3]
       MOV BH,00
       MOV BL,00

SUMA:
       CMP TAM2,04H
       JNE DIFERENTES
SUMA2:
       ADD AL,DL
       AAA
       OR AX,3030H
   
       MOV RESULTADO[4],AL

       MOV AL,AH
       MOV AH,00
       ADD AL,DH
       AAA
       OR AX,3030H
       MOV RESULTADO[3],AL

       ADD AH,BL
       MOV AL,AH
       MOV AH,00
       ADD AL,CL
       AAA
       OR AX,3030H
       MOV RESULTADO[2],AL

       ADD AH,BH
       MOV AL,AH
       MOV AH,00
       ADD AL,CH
       AAA
       OR AX,3030H
       MOV RESULTADO[1],AL
       MOV RESULTADO[0],AH
       JMP FIN_SUMA

DIFERENTES:
       CMP TAM2,03H
       JE TRES2
       CMP TAM2,02H
       JE DOS2
       JMP SUMA2
TRES2:
       MOV DH,VALOR2[3]		;Acomodamos el primer valor
       MOV DL,VALOR2[4]
       MOV CH,00
       MOV CL,VALOR2[2]
       JMP SUMA2

DOS2:
       MOV DH,VALOR2[2]		;Acomodamos el primer valor
       MOV DL,VALOR2[3]
       MOV CH,00
       MOV CL,00
       JMP SUMA2

FIN_SUMA:
       MOV AH,09H
       MOV DX, OFFSET TEXTO2
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET RESULTADO
       INT 21H


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
