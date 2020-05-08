PAGE 40,132

TITLE Ejemplo de Programa en Ensamblador

COMMENT * Este programa muestra en pantalla los valores de las variables ordenados ascendentemente*

;se inicializara el stack a continuacion

;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data' 
        TEXTO1 DB 0AH,0DH,"Inserte 50 numeros de 2 digitos separados por comas sin espacios y al final presione enter"
               DB 0AH,0DH,"$"
        DATOS DB 302 DUP ("$")
              DB 0AH,0DH,"$"
        VALORES DB 151,153 DUP ("$")
              DB 0AH,0DH,"$"
        NUMVAL DB 3,2 DUP ("$"),0AH,0DH,"$"
        VALORES2 DB 151,153 DUP ("$")
              DB 0AH,0DH,"$"
        NUMVAL2 DB 3,2 DUP ("$"),0AH,0DH,"$"
        ORDEN DB 3,2 DUP ("$"),0AH,0DH,"$"
        DATOSIMP DB 30 DUP ("$"),0AH,0DH,"$"
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
       MOV BX,0
       MOV SI,2
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
       MOV DX,OFFSET VALORES
       INT 21H	

       MOV AH,09H		;Funcio 09H para mostrar instrucciones
       MOV DX, OFFSET TEXTO1
       INT 21H

       MOV AH,0AH
       MOV DX,OFFSET VALORES2
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

       MOV CX,10
       MOV SI,0
       MOV DI,0
       MOV AL,0
OTROGRUPO:
       PUSH CX
       MOV CX,30
       MOV DI,0
OTRODATO:
       MOV AL,DATOS[SI]
       MOV DATOSIMP[DI],AL
       INC SI
       INC DI
       CMP DI,30
       JE DIEZVAL		;Si es igual, entonces se pone el enter
       JMP CICLAR

DIEZVAL:
       MOV DATOSIMP[DI],0AH
       INC DI
       MOV DATOSIMP[DI],0DH
       INC DI
       MOV DX, OFFSET DATOSIMP
       MOV AH,09H
       INT 21H
CICLAR:
       LOOP OTRODATO
       POP CX
       LOOP OTROGRUPO

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
       
       leerDatos		;Lee la tecla
       MOV AX,0
       MOV AL,VALORES[1]
       MOV BL,VALORES2[1]
       ADD AL,BL
       ADC AH,0
       MOV CX,AX
       ADD CX,0FFH
       MOV DI,0
       MOV SI,2
PASARVAL:
       MOV AL,VALORES[SI]
       CMP AL,0DH
       JE NHMD			;No Hay Mas Datos (NHMD)
       MOV DATOS[DI],AL
       INC SI
       INC DI
       JMP PASARVAL
NHMD:
       MOV SI,2
PASARVAL2:
       MOV AL,VALORES2[SI]
       CMP AL,0DH
       JE NHMD2	
       MOV DATOS[DI],AL
       INC SI
       INC DI
       JMP PASARVAL2
       
NHMD2:
novalido:      
       tipoOrdenacion

       CMP BL,"2"		;Comparamos lo que introdujo el usuario para saber còmo desea el orden
       JE descendente
       CMP BL,"1"
       JE ascendente
       JMP novalido
ascendente:
       MOV SI,0
       MOV DI,3 

ciclo:
       posicionarNum
       CMP BX,DX
       JA cambio
       JMP ir_ciclo
salto2:
       LOOP ciclo2
descendente:
       MOV SI,0
       MOV DI,3 
ciclo2:
       posicionarNum
       CMP BX,DX
       JB cambio2
       JMP ir_ciclo2
salto:
       LOOP ciclo
cambio:
       CMP BX,2424H
       JE fin_ciclo
       CMP DX,2424H
       JE ir_ciclo
       intercambioNum
       JMP ir_ciclo
cambio2:
       CMP BX,2424H
       JE fin_ciclo
       intercambioNum
       JMP ir_ciclo2
cambio_num:
      incrementoIndices
       JMP ciclo
cambio_num2:
      incrementoIndices
      JMP ciclo2
ir_ciclo:
       CMP BX,2424H
       JE fin_ciclo
       CMP DX,2424H
       JE cambio_num
       INC DI
       INC DI
       INC DI
       JMP salto
ir_ciclo2:
       CMP BX,2424H
       JE fin_ciclo
       CMP DX,2424H
       JE cambio_num2
       INC DI
       INC DI
       INC DI
       JMP salto2
      
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