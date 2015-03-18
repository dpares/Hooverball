EXTRN PONERCH:FAR
PUBLIC B_CAJA
EXTRN c5_x:BYTE
EXTRN c5_y:BYTE
EXTRN c10_x:BYTE
EXTRN c10_y:BYTE        ;Variables globales
EXTRN c25_1_x:BYTE
EXTRN c25_2_x:BYTE
EXTRN c25_y:BYTE

CODIG_B SEGMENT
       ASSUME CS:CODIG_B
B_CAJA PROC FAR
	 PUSH BP
         MOV BP, SP
         SUB SP,4 ; Sitio para dos variables locales
	 PUSH AX
         PUSH BX  ;Salvaguarda de registros
         PUSH CX
         MOV AX, SS:[BP+8] ; Mete en AX el offset de pant2[0][0]
         PUSH AX ; Usaremos el offset m s adelante
         MOV CX, SS:[BP+6] ; Mete en CX el tipo de la caja 

         CMP CX,1
         JE TIPO1
         CMP CX,2
         JE TIPO2
         CMP CX,3
         JE TIPO3

TIPO4:   MOV BH, DS:[c10_x]
         MOV SS:[BP-2], BH ; SS:[BP-2] es i (coord x)
         ADD BH, 12
         MOV BL, DS:[c10_y]
         MOV SS:[BP-4], BL ; SS:[BP-4] es j (coord y)
         ADD BL, 3 ; L¡mites que se usar n despu‚s en el bucle
         JMP PREBUCL
TIPO1:   MOV BH, DS:[c5_x]
         MOV SS:[BP-2], BH
         ADD BH, 30
         MOV BL, DS:[c5_y]
         MOV SS:[BP-4], BL 
         ADD BL, 4
         JMP PREBUCL
TIPO2:   MOV BH, DS:[c25_1_x]
         MOV SS:[BP-2], BH
         ADD BH, 10    ; Todos los l¡mites valen 1 m s que en C, para evaluar en el caso de que sean iguales
         MOV BL, DS:[c25_y]
         MOV SS:[BP-4], BL
         ADD BL, 2
         JMP PREBUCL
TIPO3:   MOV BH, DS:[c25_2_x]
         MOV SS:[BP-2], BH
         ADD BH, 10
         MOV BL, DS:[c25_y]
         MOV SS:[BP-4], BL 
         ADD BL, 2

PREBUCL: MOV AH,SS:[BP-2] ;Usamos AH y AX para poder agilizar el bucle
         MOV AL,SS:[BP-4]
         MOV CX, (' ') ; Se usar  en el bucle para borrar.

BUCLE:   CMP AL,BL
         JE FIN
         CMP AH,BH
         JE INCX
         PUSH AX
         PUSH CX
         CALL FAR PTR PONERCH ; Borra el caracter.
         ADD SP,4
         INC AH
         JMP BUCLE

INCX:    INC AL
         MOV AH,SS:[BP-2]
         JMP BUCLE

FIN:     ADD SP, 2 ; Se quita el offset de pant
         POP CX
         POP BX
         POP AX
         ADD SP,4
	 POP BP
         RET ; Devuelve el control al procedimiento principal y borra las variables de la pila

B_CAJA ENDP
CODIG_B ENDS
END
