PAGE 40,132

TITLE Ejemplo de Programa en Ensamblador

COMMENT * Este programa encuentra el mayor y el menor valoy, al igual que la moda*

;se inicializara el stack a continuacion

;PUBLIC PROCEDIMIENTO

stack   segment para stack 'STACK'        
        db 64 dup ("STACK   ")        
stack   ends

data segment para memory 'data'  
       mayor db 0h
       menor db 0h
       moda db 0h
       vecesrepe db 0h   
       datos db 0B8h,0B1h,34h,0A3h,0A0h,42h,0Ch,8Dh,42h,0Ch
             db 0AEh,41h,79h,7Fh,0D6h,24h,92h,7Bh,1Ch,0DCh
             db 0FAh,8Bh,36h,5Fh,94h,0EDh,47h,0F0h,29h,2Ch
             db 61h,0E1h,0B1h,0A0h,0EEh,65h,30h,53h,4h,0CAh
             db 89h,48h,59h,5Fh,0ABh,0AEh,0A2h,0F8h,34h,0E3h
             db 1Dh,0C3h,8Ch,0E7h,0E3h,27h,25h,28h,0E5h,5Eh
             db 9Ch,2h,47h,36h,0CAh,0FCh,0D9h,83h,57h,4Fh
             db 0B7h,0A0h,0A0h,0C0h,70h,0Ch,4Eh,0AEh,0B1h,0F9h
             db 7Bh,8Fh,6Ch,0A5h,4Bh,1Eh,95h,0Ah,8h,6Fh
             db 5Eh,0D3h,6Ah,60h,4h,9Fh,11h,0C2h,0A3h,0B5h
data ends

code segment para 'code'
	assume cs:code,ss:stack,ds:data

prueba proc far       
       MOV AX,SEG DATA	;Estas dos instrucciones siempre las van a poner
       MOV DS,AX

       MOV CX,99
       MOV SI,0
       MOV DL,datos[SI]
       MOV mayor,DL
       MOV menor,DL
ciclo:
       INC SI
       CMP DL,datos[SI]	
       JBE sigue_menor
       CMP DL,datos[SI]		
       JA sigue_mayor		

sigue_mayor:
       MOV DH,datos[SI]
       CMP DH,menor
       JA ir_ciclo
       MOV menor,DH
       JMP ir_ciclo

sigue_menor:
       MOV DL,datos[SI]
       MOV mayor,DL
       JMP ir_ciclo
ir_ciclo:
       LOOP ciclo

       MOV CX,99		;Calcular la moda
       MOV BH,0
       MOV SI,0
       MOV AX,0
       MOV DX,0
       MOV BL,datos[SI]
       JMP salto

inicio:
       MOV CX,99		
       MOV BH,0
       INC AL
       CMP AL,99
       JA fin
       MOV DI,DX
       MOV DH,datos[DI]
       MOV DI,AX
       CMP datos[DI],DH
       JE num_igual
       INC DL
       MOV DH,0
       MOV SI,AX
       MOV BL,datos[SI]

salto:
ciclo2:
       INC SI
       CMP BL,datos[SI]
       JE aumentar
       JMP ir_ciclo2

aumentar:
       INC BH  
       JMP ir_ciclo2

ir_ciclo2:
       CMP CX,0
       JBE sig_num		
       LOOP ciclo2

sig_num:
       CMP BH,vecesrepe
       JA nueva_moda
       JMP inicio

nueva_moda:
       MOV vecesrepe,BH 
       MOV moda,BL   
       JMP inicio

num_igual:
       INC DL
       MOV DH,0
       JMP inicio

fin:

prueba endp

code ends

END prueba