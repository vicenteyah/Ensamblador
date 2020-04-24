PAGE 40,132

TITLE Primer Programa en Ensamblador

COMMENT * Examen unidad 2*

;se inicializara el stack a continuacion


;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data' 
       TEXTO DB 0AH,0DH,"Ingrese un valor de l 0 al 9 y presione enter: ",0AH,0DH,"$"
       TEXTO2 DB 0AH,0DH,"El resultado de la suma es: ",0AH,0DH,"$"
       TEXTO3 DB 0AH,0DH,"¿Desea terminar el programa(0) o reiniciar el programa(1)?",0AH,0DH,"$"
       TEXTO4 DB 0AH,0DH,"Ingrese otro valor del 0 al y presione enter: ",0AH,0DH,"$"
       TEXTO5 DB 0AH,0DH,"El promedio es: ",0AH,0DH,"$"
       VALOR DB 2,2 DUP (0)
             DB 0AH,0DH,"$"
       NOMBREVALOR DB 15,15 DUP("$")
              DB 0AH,0DH,"$"
       RESULTADOSUMA DB 3,3 DUP("$"),0AH,0DH,"$"
       VALOR2 DB 2,2 DUP (0)
             DB 0AH,0DH,"$"
       SALIDA DB 2,2 DUP ("$")
       RESULTADO DB 2 DUP ("$"),0AH,0DH,"$"
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
       MOV AH,00H		;Limpiamos la pantalla del CMD
       MOV AL,03H
       INT 10H

       MOV AH,09H		;Pedimos al usuario que ingrese el primer valor
       MOV DX, OFFSET TEXTO
       INT 21H 
      
       MOV AH,0AH		;Leemos el primer valor
       MOV DX, OFFSET VALOR
       INT 21H

       MOV AH,09H		;Mostramos el primer valor
       MOV DX, OFFSET VALOR
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET TEXTO4	;Pedimos al usuario que ingrese el segundo valor
       INT 21H 
      
       MOV AH,0AH		;Leemos el segundo valor
       MOV DX, OFFSET VALOR2
       INT 21H

       MOV AH,09H		;Mostramos el segundo valor
       MOV DX, OFFSET VALOR2
       INT 21H

       MOV AL,VALOR[2]		;Acomodamos los valores en los registros AL y BL
       MOV BL,VALOR2[2]
       MOV AH,00		;Limpiamos el registro AH para evitar que la suma y el ajuste nos den un valor erróneo
       ADD AL,BL		;Realizamos la suma de los registros
       AAA			;Realizamos el ajuste
       MOV BX,AX
       OR BX,3030H		;Sumamos 3030 al registro AX para tener los valores ASCII del resultado de la suma
       MOV RESULTADOSUMA[0],BH	;Mandamos la suma a la variable RESULTADOSUMA
       MOV RESULTADOSUMA[1],BL

       MOV BX,00H		;Limpiamos el registro BX
       MOV BL,02		;Mandamos un 2 al BL, el cual será nuestro divisor debido a que sólo son dos valores que se ingresan
       AAD			;Ajustamos antes de la división
       DIV BL			;Realizamos la división
       OR AX,3030H
       MOV RESULTADO,AL		;Movemos el cociente que se encuentra en AL a la variable RESULTADO

       MOV DH,RESULTADOSUMA[0]	;Pasamos los valores de la variable RESULTADOSUMA al registro DX para poder convertirlo a letra
       MOV DL,RESULTADOSUMA[1]     
       CMP DH,"1"		;Revisamos si la suma dio un número de dos dígitos, si es así entonces agregamos la palabra dieci al inicio, a excepción de cuando sean valores menores a 16 como el once
       JE DIECI
       JMP UNVALOR		;Si la suma dio como resultado un número de un dígito, entonces procedemos a insertar su nombre depnediendo del número

DIECI:
      MOV NOMBREVALOR[0],"D"
      MOV NOMBREVALOR[1],"I"
      MOV NOMBREVALOR[2],"E"
      MOV NOMBREVALOR[3],"C"
      MOV NOMBREVALOR[4],"I"
      CMP DL,"6"
      JAE DIECITANTO
      JMP DOSVALORES
DIECITANTO:
      CMP DL,"6"
      JE DIECISEIS
      CMP DL,"7"
      JE DIECISIETE
      CMP DL,"8"
      JE DIECIOCHO
      CMP DL,"9"
      JE DIECINUEVE
      JMP FINAL
DIECISEIS:
      MOV NOMBREVALOR[5],"S"
      MOV NOMBREVALOR[6],"E"
      MOV NOMBREVALOR[7],"I"
      MOV NOMBREVALOR[8],"S"
      JMP FINAL
DIECISIETE:
      MOV NOMBREVALOR[5],"S"
      MOV NOMBREVALOR[6],"I"
      MOV NOMBREVALOR[7],"E"
      MOV NOMBREVALOR[8],"T"
      MOV NOMBREVALOR[9],"E"
      JMP FINAL
DIECIOCHO:
      MOV NOMBREVALOR[5],"O"
      MOV NOMBREVALOR[6],"C"
      MOV NOMBREVALOR[7],"H"
      MOV NOMBREVALOR[8],"O"
      MOV NOMBREVALOR[9],24H
      JMP FINAL
DIECINUEVE:
      MOV NOMBREVALOR[5],"N"
      MOV NOMBREVALOR[6],"U"
      MOV NOMBREVALOR[7],"E"
      MOV NOMBREVALOR[8],"V"
      MOV NOMBREVALOR[9],"E"
      JMP FINAL

UNVALOR:			;Este salto se realiza en caso de que la suma sea un número de un dígito
      CMP DL,"0"
      JE CERO
      CMP DL,"1"
      JE UNO
      CMP DL,"2"
      JE DOS
      CMP DL,"3"
      JE TRES
      CMP DL,"4"
      JE CUATRO
      JMP OTROSNUM
CERO:				;Movemos la letra que debe ir en la posición que corresponde para formar el nombre del número
      MOV NOMBREVALOR[0],"C"
      MOV NOMBREVALOR[1],"E"
      MOV NOMBREVALOR[2],"R"
      MOV NOMBREVALOR[3],"O"
      MOV NOMBREVALOR[4],24H
      JMP FINAL
UNO:
      MOV NOMBREVALOR[0],"U"
      MOV NOMBREVALOR[1],"N"
      MOV NOMBREVALOR[2],"O"
      MOV NOMBREVALOR[3],24H
      JMP FINAL
DOS:
      MOV NOMBREVALOR[0],"D"
      MOV NOMBREVALOR[1],"O"
      MOV NOMBREVALOR[2],"S"
      MOV NOMBREVALOR[3],24H
      JMP FINAL
TRES:
      MOV NOMBREVALOR[0],"T"
      MOV NOMBREVALOR[1],"R"
      MOV NOMBREVALOR[2],"E"
      MOV NOMBREVALOR[3],"S"
      MOV NOMBREVALOR[4],24H
      JMP FINAL
CUATRO:
      MOV NOMBREVALOR[0],"C"
      MOV NOMBREVALOR[1],"U"
      MOV NOMBREVALOR[2],"A"
      MOV NOMBREVALOR[3],"T"
      MOV NOMBREVALOR[4],"R"
      MOV NOMBREVALOR[5],"O"
      MOV NOMBREVALOR[6],24H
      JMP FINAL
CINCO:
      MOV NOMBREVALOR[0],"C"
      MOV NOMBREVALOR[1],"I"
      MOV NOMBREVALOR[2],"N"
      MOV NOMBREVALOR[3],"C"
      MOV NOMBREVALOR[4],"O"
      MOV NOMBREVALOR[5],24H
      JMP FINAL
OTROSNUM:
      CMP DL,"5"
      JE CINCO
      CMP DL,"6"
      JE SEIS
      CMP DL,"7"
      JE SIETE
      CMP DL,"8"
      JE OCHO
      CMP DL,"9"
      JE NUEVE
      JMP FINAL
SEIS:
      MOV NOMBREVALOR[0],"S"
      MOV NOMBREVALOR[1],"E"
      MOV NOMBREVALOR[2],"I"
      MOV NOMBREVALOR[3],"S"
      MOV NOMBREVALOR[4],24H
      JMP FINAL
SIETE:
      MOV NOMBREVALOR[0],"S"
      MOV NOMBREVALOR[1],"I"
      MOV NOMBREVALOR[2],"E"
      MOV NOMBREVALOR[3],"T"
      MOV NOMBREVALOR[4],"E"
      JMP FINAL
OCHO:
      MOV NOMBREVALOR[0],"O"
      MOV NOMBREVALOR[1],"C"
      MOV NOMBREVALOR[2],"H"
      MOV NOMBREVALOR[3],"O"
      MOV NOMBREVALOR[4],24H
      JMP FINAL
NUEVE:
      MOV NOMBREVALOR[0],"N"
      MOV NOMBREVALOR[1],"U"
      MOV NOMBREVALOR[2],"E"
      MOV NOMBREVALOR[3],"V"
      MOV NOMBREVALOR[4],"E"
      MOV NOMBREVALOR[5],24H
      JMP FINAL
DOSVALORES:
      CMP DL,"0"
      JE DIEZ
      CMP DL,"1"
      JE ONCE
      CMP DL,"2"
      JE DOCE
      CMP DL,"3"
      JE TRECE
      JMP OTROSVAL
DIEZ:
      MOV NOMBREVALOR[0],"D"
      MOV NOMBREVALOR[1],"I"
      MOV NOMBREVALOR[2],"E"
      MOV NOMBREVALOR[3],"Z"
      MOV NOMBREVALOR[4],24H
      JMP FINAL
ONCE:
      MOV NOMBREVALOR[0],"O"
      MOV NOMBREVALOR[1],"N"
      MOV NOMBREVALOR[2],"C"
      MOV NOMBREVALOR[3],"E"
      MOV NOMBREVALOR[4],24H
      JMP FINAL
DOCE:
      MOV NOMBREVALOR[0],"D"
      MOV NOMBREVALOR[1],"O"
      MOV NOMBREVALOR[2],"C"
      MOV NOMBREVALOR[3],"E"
      MOV NOMBREVALOR[4],24H
      JMP FINAL
TRECE:
      MOV NOMBREVALOR[0],"T"
      MOV NOMBREVALOR[1],"R"
      MOV NOMBREVALOR[2],"E"
      MOV NOMBREVALOR[3],"C"
      MOV NOMBREVALOR[4],"E"
      MOV NOMBREVALOR[5],24H
      JMP FINAL

OTROSVAL:
      CMP DL,"4"
      JE CATORCE
      CMP DL,"5"
      JE QUINCE

CATORCE:
      MOV NOMBREVALOR[0],"C"
      MOV NOMBREVALOR[1],"A"
      MOV NOMBREVALOR[2],"T"
      MOV NOMBREVALOR[3],"O"
      MOV NOMBREVALOR[4],"R"
      MOV NOMBREVALOR[5],"C"
      MOV NOMBREVALOR[6],"E"
      JMP FINAL
QUINCE:
      MOV NOMBREVALOR[0],"Q"
      MOV NOMBREVALOR[1],"U"
      MOV NOMBREVALOR[2],"I"
      MOV NOMBREVALOR[3],"N"
      MOV NOMBREVALOR[4],"C"
      MOV NOMBREVALOR[5],"E"
      MOV NOMBREVALOR[6],24H
      JMP FINAL
FINAL:
       MOV AH,09H
       MOV DX, OFFSET TEXTO2
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET NOMBREVALOR
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET TEXTO5
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
