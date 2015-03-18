EXTRN NALEAT:FAR
PUBLIC D_CAJA
EXTRN c5_x:BYTE
EXTRN c5_y:BYTE
EXTRN c10_x:BYTE
EXTRN c10_y:BYTE        ;Variables globales
EXTRN c25_1_x:BYTE
EXTRN c25_2_x:BYTE
EXTRN c25_y:BYTE
MAX_COL EQU 80
CO5_X EQU 25 ; Coordenada x inicial de la esquina superior izquierda de la caja original de 5
CO5_Y EQU 7 ; Coordenada y del mismo punto de la misma caja.
CO25_1_X EQU 9 ; Coordenada x del mismo punto de la primera caja de 25
CO25_2_X EQU 62 ; Coordenada x del mismo punto de la segunda caja de 25
CO25_Y EQU 3 ; Coordenada y del mismo punto de las dos cajas de 25
CO10_X EQU 34 ; Coordenada x del mismo punto de la caja original de 10
CO10_Y EQU 13 ; Coordenada y del mismo punto de la caja original de la misma caja.


CODIG_D SEGMENT
       ASSUME CS:CODIG_D
D_CAJA PROC FAR
	 PUSH BP
         MOV BP, SP
         SUB SP,14 ; Sitio para variables locales
	 PUSH AX
         PUSH BX  ;Salvaguarda de registros
         PUSH CX
         PUSH DX
         PUSH SI
         PUSH DI
         MOV SI, SS:[BP+10] ; Mete en SI el offset de pant2[0][0]
         PUSH SI ; Usaremos el offset m s adelante
         MOV DI, SS:[BP+8] ; Mete en DI el offset de pant[0][0]
         MOV CX, SS:[BP+6] ; Mete en CX el tipo de la caja 

         CMP CX,1
         JNE VTIPO2
         JMP TIPO1
VTIPO2:  CMP CX,2
         JNE VTIPO3
         JMP TIPO2
VTIPO3:  CMP CX,3
         JNE TIPO4
         JMP TIPO3

TIPO4:   CALL FAR PTR NALEAT
         MOV AL, AH
         MOV AH, 0
         MOV BL, MAX_COL
         SUB BL, 15
         DIV BL
         ADD AH, 2   ; Para evitar que est‚ en el borde
         MOV DS:[c10_x], AH
         MOV BH, DS:[c10_x]
         MOV SS:[BP-2], BH ; SS:[BP-2] es i (coord x)
         ADD BH, 12
         MOV SS:[BP-6], BH ; Limite X de la caja
         MOV BL, DS:[c10_y]
         MOV SS:[BP-4], BL ; SS:[BP-4] es j (coord y)
         ADD BL, 3 ; L¡mites que se usar n despu‚s en el bucle
         MOV SS:[BP-8], BL ; Limite Y de la caja
         MOV CH, CO10_X
         MOV CL, CO10_Y
         MOV SS:[BP-10], CH
         MOV SS:[BP-12], CL
         JMP PREBUCL
TIPO1:   CALL FAR PTR NALEAT
         MOV BX, AX
         MOV AL, BH
         ADD AL, 33
         MOV AH, 0      ;Por si el resultado es negativo
         MOV CL, 27
         MUL CL
         MOV AH, 0
         MOV BL, MAX_COL
         SUB BL, 32
         DIV BL
         ADD AH, 2   ; Para evitar que est‚ en el borde
         MOV DS:[c5_x], AH
         MOV BH, DS:[c5_x]
         MOV SS:[BP-2], BH ; SS:[BP-2] es i (coord x)
         ADD BH, 30
         MOV SS:[BP-6], BH ; Limite X de la caja
         MOV BL, DS:[c5_y]
         MOV SS:[BP-4], BL ; SS:[BP-4] es j (coord y)
         ADD BL, 4 ; L¡mites que se usar n despu‚s en el bucle
         MOV SS:[BP-8], BL ; Limite Y de la caja
         MOV CH, CO5_X
         MOV CL, CO5_Y
         MOV SS:[BP-10], CH
         MOV SS:[BP-12], CL
         JMP PREBUCL
TIPO2:   CALL FAR PTR NALEAT
         MOV BX, AX
         MOV AL, BH
         SUB AL, 90
         MOV AH, 0      ;Por si el resultado es negativo
         MOV CL, 33
         MUL CL
         MOV BL, MAX_COL
         SUB BL, 52
         MOV AH, 0
         DIV BL
         ADD AH, 2   ; Para evitar que est‚ en el borde
         MOV DS:[c25_1_x], AH
         MOV BH, DS:[c25_1_x]
         MOV SS:[BP-2], BH ; SS:[BP-2] es i (coord x)
         ADD BH, 10
         MOV SS:[BP-6], BH ; Limite X de la caja
         MOV BL, DS:[c25_y]
         MOV SS:[BP-4], BL ; SS:[BP-4] es j (coord y)
         ADD BL, 2 ; L¡mites que se usar n despu‚s en el bucle
         MOV SS:[BP-8], BL ; Limite Y de la caja
         MOV CH, CO25_1_X
         MOV CL, CO25_Y
         MOV SS:[BP-10], CH
         MOV SS:[BP-12], CL
         JMP PREBUCL
TIPO3:   CALL FAR PTR NALEAT
         MOV BX, AX
         MOV AL, BH
         ADD AL, 73
         MOV AH, 0      ;Por si el resultado es negativo
         MOV CL, 55
         MUL CL
         MOV AH, 0
         MOV BL, MAX_COL
         SUB BL, 65
         DIV BL
         ADD AH, 42   ; Para evitar que est‚ en el borde
         MOV DS:[c25_2_x], AH
         MOV BH, DS:[c25_2_x]
         MOV SS:[BP-2], BH ; SS:[BP-2] es i (coord x)
         ADD BH, 10
         MOV SS:[BP-6], BH ; Limite X de la caja
         MOV BL, DS:[c25_y]
         MOV SS:[BP-4], BL ; SS:[BP-4] es j (coord y)
         ADD BL, 2 ; L¡mites que se usar n despu‚s en el bucle
         MOV SS:[BP-8], BL ; Limite Y de la caja
         MOV CH, CO25_2_X
         MOV CL, CO25_Y
         MOV SS:[BP-10], CH
         MOV SS:[BP-12], CL
         JMP PREBUCL
PREBUCL: MOV BX, 0
         MOV CX, 0

BUCLE:   MOV AH, SS:[BP-2]
         MOV AL, SS:[BP-4]
         MOV BH, SS:[BP-6]
         MOV BL, SS:[BP-8]
         ADD AX, CX
         CMP AL, BL
         JE FIN
         CMP AH, BH
         JE INCX
         MOV AH, SS:[BP-10]
         MOV AL, SS:[BP-12]
         ADD AX, CX
         MOV DX, AX
         MOV AX, MAX_COL
         MUL DL
         MOV BX, AX
         MOV DL, DH
         MOV DH, 0
         ADD BX, DX
         MOV DX, DS:[DI+BX]   ; Se guarda el caracter de la caja original
         MOV SS:[BP-14], DX
         MOV AH, SS:[BP-2]
         MOV AL, SS:[BP-4]
         ADD AX, CX
         MOV DX, AX
         MOV AX, MAX_COL
         MUL DL
         MOV BX, AX
         MOV DL, DH
         MOV DH, 0
         ADD BX, DX
         MOV DX, SS:[BP-14]
         MOV DS:[SI+BX], DL  ; Y se pone as¡ la letra en pant2
         INC CH
         JMP BUCLE

INCX:    INC CL
         MOV CH, 0
         JMP BUCLE

FIN:     ADD SP, 2 ; Se quita el offset de pant
         POP DI
         POP SI
         POP DX
         POP CX
         POP BX
         POP AX
         ADD SP, 14
	 POP BP
         RET ; Devuelve el control al procedimiento principal y borra las variables de la pila

D_CAJA ENDP
CODIG_D ENDS
END
