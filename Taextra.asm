PAGE 40,132

TITLE Ejemplo de Programa en Ensamblador

COMMENT * Este programa realiza el promedio de velocidad, fuerza y trabajo*

;se inicializara el stack a continuacion

;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data'     
       masa db 31h,1h,0A3h,0Ah,5h
       distancia db 50h,3Ch,28h,1Eh,3Ch
       tiempo db 4h,4h,4h,3h,3h
       velocidad dw 0
   
data ends

code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       MOV AX,SEG DATA	;Estas dos instrucciones siempre las van a poner
       MOV DS,AX
       
       MOV CL,5h                ;Se inicializa CL con 5 para realizar el promedio
       MOV AH,0			;Se halla la velocidad 1
       MOV AL,distancia[0]
       MOV BL,tiempo[0]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       MOV velocidad,AX
       
       MOV AH,0			;Se halla la velocidad 2
       MOV AL,distancia[1]
       MOV BL,tiempo[1]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       ADC velocidad,AX

       MOV AH,0			;Se halla la velocidad 3
       MOV AL,distancia[2]
       MOV BL,tiempo[2]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       ADC velocidad,AX

       MOV AH,0			;Se halla la velocidad 4
       MOV AL,distancia[3]
       MOV BL,tiempo[3]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       ADC velocidad,AX

       MOV AH,0			;Se halla la velocidad 5
       MOV AL,distancia[4]
       MOV BL,tiempo[4]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       ADC velocidad,AX


prueba endp

code ends

END prueba
