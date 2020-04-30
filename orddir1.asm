PAGE 40,132

TITLE Ejemplo de Programa en Ensamblador

COMMENT * Este programa muestra en pantalla los valores de las variables ordenados ascendentemente*

;se inicializara el stack a continuacion

;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data' 
        TEXTO1 DB 0AH,0DH,"Inserte 10 numeros de 2 digitos separados por comas sin espacios y al final presione enter",0AH,0DH,"$"
        DATOS DB 30,32 DUP ("$")
              DB 0AH,0DH,"$"
        ORDEN DB 3,2 DUP ("$"),0AH,0DH,"$"
        TEXTO2 DB  0AH,0DH,"Los numeros son: ",0AH,0DH,"$"
        TEXTO3 DB 0AH,0DH,"INDIQUE LA FORMA EN QUE DESEA ORDENAR LOS NUMEROS (1)ASC (2)DESC",0AH,0DH,"$"
        TEXTO4 DB 0AH,0DH,"¿Desea salir del programa(0) o hacer otro ordenamiento(1)? ",0AH,0DH,"$"
        SALIDA DB 3,2 DUP ("$"),0AH,0DH,"$"

data ends

limpiarPantalla MACRO
       MOV AH,00H
       MOV AL,03H
       INT 10H
ENDM

tipoOrdenacion MACRO
       MOV AH,09H		;Funcio 09H para mostrar instrucciones de ordenamiento
       MOV DX, OFFSET TEXTO3
       INT 21H

       MOV AH,0AH
       MOV DX,OFFSET ORDEN
       INT 21H			;Lee la tecla
       MOV BL,ORDEN[SI]
ENDM

leerDatos MACRO
       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO1
       INT 21H

       MOV AH,0AH
       MOV DX,OFFSET DATOS
       INT 21H	
ENDM

incrementoIndices MACRO
      INC SI
      INC SI
      INC SI
      MOV DI,SI
      INC DI
      INC DI
      INC DI
ENDM

intercambioNum MACRO
       MOV DATOS[DI],BH
       MOV DATOS[DI+1],BL
       MOV DATOS[SI],DH
       MOV DATOS[SI+1],DL
ENDM

posicionarNum MACRO
       MOV BH,DATOS[SI]		;Posicion 2 del arreglo
       MOV BL,DATOS[SI+1]
       MOV DH, DATOS[DI]	;Posicion 5 del arreglo
       MOV DL, DATOS[DI+1]
ENDM

mostrarResultado MACRO
       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO2
       INT 21H

       MOV DX, OFFSET DATOS
       MOV AH,09H
       INT 21H
ENDM

saliroReiniciar MACRO
       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO4
       INT 21H

       MOV AH,0AH
       MOV DX,OFFSET SALIDA
       INT 21H			;Lee la tecla
ENDM


code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       PUSH DS
       SUB AX,AX
       PUSH AX
       MOV AX,SEG DATA	;Estas dos instrucciones siempre las van a poner
       MOV DS,AX
inicio:
       limpiarPantalla
       MOV CX,42
       MOV SI,2
       MOV DI,5
       leerDatos		;Lee la tecla
novalido:       
       tipoOrdenacion

       CMP BL,"2"		;Comparamos lo que introdujo el usuario para saber còmo desea el orden
       JE descendente
       CMP BL,"1"
       JE ascendente
       JMP novalido
ascendente:
       JMP ciclo

cambio_num:
      incrementoIndices


ciclo:
       posicionarNum
       CMP BX,DX
       JA cambio
       JMP ir_ciclo

cambio_num2:
      incrementoIndices

descendente:
ciclo2:
       posicionarNum
       CMP BX,DX
       JB cambio2
       JMP ir_ciclo2

cambio:
       CMP DI,32
       JE fin_ciclo
       intercambioNum
       JMP ir_ciclo

cambio2:
       CMP DI,32
       JE fin_ciclo
       intercambioNum
       JMP ir_ciclo2

ir_ciclo:
       CMP SI,29
       JE fin_ciclo
       CMP DI,29
       JE cambio_num
       INC DI
       INC DI
       INC DI
       LOOP ciclo


ir_ciclo2:
       CMP SI,29
       JE fin_ciclo
       CMP DI,29
       JE cambio_num2
       INC DI
       INC DI
       INC DI
       LOOP ciclo2
      
fin_ciclo:
       mostrarResultado

numinvalido:
       saliroReiniciar
       MOV BL,SALIDA[2]
       CMP BL,"0"
       JE salir
       CMP BL,"1"
       JE reinicio
       JMP numinvalido
reinicio:
       JMP inicio

salir:
       RET

prueba endp

code ends

END prueba