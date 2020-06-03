PAGE 40,132

TITLE Contador

COMMENT * Este programa es un contador, el cual cuenta de forma infinita o por tiempo dependiendo de la opcion elegida por el usuario*


stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data'     
       TEXTO DB 0AH,0DH,"Contador: ",0AH,0DH,"$"
       VAR1 DB 40 DUP("0"),0DH,"$"
       TEXTO2 DB 0AH,0DH,"Minutos: ",0AH,0DH,"$"
       TEXTO3 DB "¿Desea que sea por tiempo(1) o infinito(0)? ",0AH,0DH,"$"
       ELECCION DB 2 DUP("0")
       DUR DB "0"
       SEGUNDOS DB "?"
       CRONO DW "00","[","00",":","00","]","$"

data ends

cronometro MACRO		;Macro para dar formato al cronómetro
       MOV AH,2CH		;Se utiliza la int 2CH para obtener el reloj del sistema
       INT 21H
       MOV BX,CRONO[8]		;Pasamos la posición 8 de la variable CRONO a BX
       MOV CX,CRONO[4]		;Pasamos la posición 4 de la variable CRONO a CX
       CMP DH,SEGUNDOS		;Comparamos si los segundos del sistema (guardados en DH) son iguales al valor guardado en la variable SEGUNDOS
       JNE revisar
       JMP salir
revisar:
       MOV SEGUNDOS,DH		;Pasamos el dato contenido en DH a la variable SEGUNDOS para cambiar los segundos y poder tener un control del incremento del tiempo
       CMP BH,39H		;Revisamos si BH llegó a 9 para realizar el incrmento a 10 o si ya pasó un minuto
       JE sumseg
       INC BH			;Si no ha llegado a 9 se le suma 1 al registro para incrementar los segundos (usar INC)
       JMP salir
sumseg:
       CMP BL,35H		;Se revisa si BL llegó a 5, si ya llegó a ese valor, quiere decir que es 59 el dato de los segundos contenidos en BX y ya se llegó al minuto
       JE minuto		
       INC BL			;Se incrementa en 1 el registro BL porque no ha llegado al valor 5
       MOV BH,30H		;Se pone en 0 BH porque ya se llegó a las decenas en los segundos
       JMP salir
minuto:
       MOV BL,30H
       MOV BH,30H
       CMP CH,39H
       JE summin
       ADD CH,01H		;Se incrementan los minutos
       JMP salir
summin:
       INC CL
       MOV CH,30H
       JMP salir
salir:
       MOV CRONO[8],BX		;Se pasan los datos de BX a la variable CRONO en la posición 8
       MOV CRONO[4],CX		;Se pasan los datos de CX a la variable CRONO en la posición 4
       MOV AH,09H
       MOV DX, OFFSET CRONO
       INT 21H			;Se imprime la variable CRONO para mostrar los segundos y minutos
ENDM

code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       PUSH DS
       SUB AX,AX
       PUSH AX
       MOV AX,SEG DATA	
       MOV DS,AX

       MOV AH,00H		;Se limpia la pantalla
       MOV AL,03H
       INT 10H

       MOV AH,09		;Se solicita al usuario la forma en cómo va a ejecutarse el contador (por tiempo o infinitamente)
       MOV DX, OFFSET TEXTO3
       INT 21H

       MOV AH,0AH		;Se guarda el número ingresado por el usuario en la variable ELECCION
       MOV DX, OFFSET ELECCION
       INT 21H
       CMP ELECCION[2],"1"	;Se revisa si el usuario pidió que sea por tiempo el conteo
       JE portiempo
       JMP infinito		
portiempo:
       MOV AH,09
       MOV DX, OFFSET TEXTO2	;Se le pide al usuario que ingrese los minutos que quiere que tarde el contador
       INT 21H

       MOV AH,0AH
       MOV DX, OFFSET DUR	;Se guardan los minutos de duración en la variable DUR
       INT 21H
       CMP DUR[2],"5"		;Se revisa si el valor es mayor a 5, de ser mayor se vuelve a pedir al usuario que ingrese los minutos
       JA portiempo

       MOV AH,2CH		;Se guardan los segundos actuales del sistema
       INT 21H
       MOV SEGUNDOS,DH
infinito:			;Se realiza este salto si el usuario pide un conteo infinito
       MOV AH,09H
       MOV DX, OFFSET TEXTO
       INT 21H

       MOV AH,09H
       MOV DX, OFFSET VAR1
       INT 21H
       MOV DI,0

acomodoIndice:			;En esta parte se recorre todo el arreglo para mover DI a la última posición del arreglo
       CMP VAR1[DI],0DH		;Se compara con 0DH para saber si ya llegó al final
       JE salirAcomodo
       INC DI
       JMP acomodoIndice
salirAcomodo:
       DEC DI
       MOV SI,DI		;Se respalda la posición contenida DI en SI 
ciclo:				;Inicia el ciclo del contador
       MOV AL,VAR1[SI]		;Se mueve el valor contenido en Var1[SI] al registro AL
       INC AL			;Se le suma 1
       CMP AL,"9"		;Se compara si ya llegó al 9 para incrementar el siguiente dato del arreglo
       JA reinicio
       MOV VAR1[SI],AL		;Si no ha superado el valor 9, entonces se mueve a la variable VAR1

       MOV AH,09H		;Se imprime la variable VAR1
       MOV DX, OFFSET VAR1
       INT 21H

       CMP ELECCION[2],"0"	;Se revisa la ección del usuario (Conteo por tiempo[1] o infinito[0])
       JE ciclo
       cronometro		;Se llama a la macro del cronómetro
       MOV CX,CRONO[4]		;Se compara si ya se llegó al minuto solicitado por el usuario guardado en la variable DUR
       MOV CL,DUR[2]
       CMP CL,CH
       JE fin			;Si ya llegó al valor solicitado por el usuario, se sale del programa
       JMP ciclo

reinicio:
       MOV VAR1[SI],"0"		;Sí el dato contenido en SI superó el 9, entonces se le pone un 0 para que vuelva a contar
       DEC SI			;Se decrementa el índice para ir a la siguiente posición
       MOV AL,VAR1[SI]		;Se pasa al registro AL
       INC AL			;Se le suma un 1
       CMP AL,"9"		;Se verifica si ya superó el valor 9
       JA reinicio
       MOV VAR1[SI],AL
       MOV SI,DI		;Se regresa al la última posición del arreglo
       JMP ciclo
fin:
       
RET

prueba endp

code ends

END prueba
