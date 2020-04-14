PAGE 40,132

TITLE Ejemplo de Programa en Ensamblador

COMMENT * Este programa realiza el promedio de velocidad, fuerza y trabajo*

;se inicializara el stack a continuacion

;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data'     
       masa db 23h,14h,1Eh,28h,32h
       distancia db 14h,3Ch,28h,1Eh,2Dh
       tiempo db 2h,4h,4h,3h,3h
       fuerza dw 0h,0h,0h,0h,0h
       aceleracion db 0Ah
       velocidad dw 0
       fuerzaprom dw 0
       trabajo dw 0
   
data ends

code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       MOV AX,SEG DATA	;Estas dos instrucciones siempre las van a poner
       MOV DS,AX
       
       MOV CL,5h
       MOV AH,0			;Se halla la velocidad 1
       MOV AL,distancia[0]
       MOV BL,tiempo[0]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       MOV AH,0
       MOV velocidad,AX
       
       MOV AH,0			;Se halla la velocidad 2
       MOV AL,distancia[1]
       MOV BL,tiempo[1]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       MOV AH,0	
       ADC velocidad,AX

       MOV AH,0			;Se halla la velocidad 3
       MOV AL,distancia[2]
       MOV BL,tiempo[2]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       MOV AH,0
       ADC velocidad,AX

       MOV AH,0			;Se halla la velocidad 4
       MOV AL,distancia[3]
       MOV BL,tiempo[3]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       MOV AH,0
       ADC velocidad,AX

       MOV AH,0			;Se halla la velocidad 5
       MOV AL,distancia[4]
       MOV BL,tiempo[4]
       DIV BL 			;El cociente esta en AL y el residuo en AH
       DIV CL
       MOV AH,0
       ADC velocidad,AX
       
       MOV AX,0			;Se saca la fuerza
       MOV AL,masa[0]
       MUL aceleracion		;AL se multiplica por el contenido de aceleracion
       DIV CL   
       MOV fuerza[0],AX
       MOV fuerzaprom,AX		;Pasamos el resultado a la variable fuerza

       MOV AX,0			;Se saca la fuerza 2
       MOV AL,masa[1]
       MUL aceleracion		
       DIV CL  
       MOV fuerza[2],AX 
       ADC fuerzaprom,AX	

       MOV AX,0			;Se saca la fuerza 3
       MOV AL,masa[2]
       MUL aceleracion		
       DIV CL   
       MOV fuerza[4],AX
       ADC fuerzaprom,AX	

       MOV AX,0			;Se saca la fuerza 4
       MOV AL,masa[3]
       MUL aceleracion		
       DIV CL
       MOV fuerza[6],AX   
       ADC fuerzaprom,AX	

       MOV AX,0			;Se saca la fuerza 5
       MOV AL,masa[4]
       MUL aceleracion		
       DIV CL   
       MOV fuerza[8],AX
       ADC fuerzaprom,AX

       MOV AX,0			;Se saca el trabajo 1
       MOV AX,fuerza[0]	
       DIV CL			;Se divide entre 5	
       MOV BL,distancia[0]
       MUL BL
       MOV trabajo,AX

       MOV AX,0			;Se saca el trabajo 2
       MOV AX,fuerza[2]	
       DIV CL				
       MOV BL,distancia[1]
       MUL BL
       ADC trabajo,AX

       MOV AX,0			;Se saca el trabajo 3
       MOV AX,fuerza[4]	
       DIV CL				
       MOV BL,distancia[2]
       MUL BL
       ADC trabajo,AX

       MOV AX,0			;Se saca el trabajo 4
       MOV AX,fuerza[6]	
       DIV CL				
       MOV BL,distancia[3]
       MUL BL
       ADC trabajo,AX

       MOV AX,0			;Se saca el trabajo 5
       MOV AX,fuerza[8]	
       DIV CL				
       MOV BL,distancia[4]
       MUL BL
       ADC trabajo,AX

prueba endp

code ends

END prueba