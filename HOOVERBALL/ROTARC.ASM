EXTRN PONERCH: FAR ; Se usar  el procedimiento de poner caracter.
EXTRN curs_x:BYTE
EXTRN curs_y:BYTE  ;Etiquetas de los cursores
EXTRN bol1_x:BYTE 
EXTRN bol1_y:BYTE 
EXTRN bol2_x:BYTE 
EXTRN bol2_y:BYTE
EXTRN bol3_x:BYTE      ;Etiquetas de las cinco bolas
EXTRN bol3_y:BYTE 
EXTRN bol4_x:BYTE 
EXTRN bol4_y:BYTE 
EXTRN bol5_x:BYTE 
EXTRN bol5_y:BYTE 
PUBLIC ROTARC
MAX_COL EQU 80
MAX_FIL EQU 24

COD_R  SEGMENT
        ASSUME CS:COD_R

ROTARC  PROC FAR    ; Procedimiento rotar_cursor de aspiradora.cpp
INICIO: PUSH BP    ;Salvaguarda de BP
        MOV BP,SP
        PUSH AX
        PUSH BX ; Necesitaremos los seis registros.
        PUSH CX
        PUSH DX
        PUSH SI
        MOV DX, SS:[BP+8] ;Coordenadas cursor
        MOV AH, DH  ;x
        MOV AL, DL  ;y
        MOV DX, SS:[BP+6] ;Coordenadas aspiradora
        MOV BH, DH  ;x
        MOV BL, DL  ;y
        MOV CX, SS:[BP+10] ; Coordenadas bola
        MOV DX, SS:[BP+12] ; DX contiene el offset de pant[0][0]
        PUSH DX

        CMP AH,0
        JNE PAR1
        JMP NOESC
PAR1:   CMP AH,MAX_COL-1
        JNE PAR2
        JMP NOESC
PAR2:   CMP AL,0        ; As¡ evitamos que el cursor sobreescriba las paredes
        JNE PAR3
        JMP NOESC
PAR3:   CMP AL,MAX_FIL-1
        JNE BLA
        JMP NOESC
BLA:    CMP AH, CH
        JNE VERBLAS
        CMP AL, CL       ; As¡ evitamos que el cursor sobreescriba la bola
        JNE VERBLAS
        JMP NOESC
VERBLAS:MOV CH, DS:[bol1_x]
        MOV CL, DS:[bol1_y]
        CMP AH,CH
        JNE VERB2
        CMP AL, CL
        JNE VERB2
        JMP NOESC
VERB2:  MOV CH, DS:[bol2_x]
        MOV CL, DS:[bol2_y]
        CMP AH,CH
        JNE VERB3
        CMP AL, CL
        JNE VERB3
        JMP NOESC
VERB3:  MOV CH, DS:[bol3_x]
        MOV CL, DS:[bol3_y]
        CMP AH,CH                ;Evita que se borren las bolas extra
        JNE VERB4
        CMP AL, CL
        JNE VERB4
        JMP NOESC
VERB4:  MOV CH, DS:[bol4_x]
        MOV CL, DS:[bol4_y]
        CMP AH,CH
        JNE VERB5
        CMP AL, CL
        JNE VERB5
        JMP NOESC
VERB5:  MOV CH, DS:[bol5_x]
        MOV CL, DS:[bol5_y]
        CMP AH,CH
        JNE BORRC
        CMP AL, CL
        JNE BORRC
        JMP NOESC

BORRC:  MOV DX, SS:[BP+8]
        PUSH DX
        MOV SI, (' ')      ; Sustituir el asterisco por un espacio
        PUSH SI
        CALL FAR PTR PONERCH
        ADD SP, 4
                
NOESC:  MOV DX, 0 ;Necesitamos que valga 0 a la hora de hacer comparaciones
        CMP AH,BH ;Se comparan las variables x
        JE XIGUAL ;Si son iguales se indica en DX
        DEC BH    ;Se estudia ahora curs_x==asp_x-1
        CMP AH,BH
        JE XMENOR ;Si son iguales se indica de otra forma
        INC BH    ;Se recupera el valor de AL
        JMP CMPY;La opcion que quedaba era curs_x==asp_x+1. Entendemos que DH entonces vale 0.

XIGUAL: MOV DH,1
        JMP CMPY  ;Se pasa a estudiar y
XMENOR: MOV DH,2  ;Como en la otra opcion DH valdra 0, seguimos inmediatamente a comparar y

CMPY:   CMP AL,BL ;Se comparan las variables y
        JE YIGUAL ;Si son iguales se indica en DX
        DEC BL    ;Se estudia ahora curs_y==asp_y-1
        CMP AL,BL
        JE YMENOR ;Si son iguales se indica de otra forma
        INC BL    ;Se recupera el valor de BL
        JMP MODIF;La opcion que quedaba era curs_y==asp_y+1. Entendemos que DH entonces vale 0.

YIGUAL: MOV DL,1
        JMP MODIF  ;Se pasa a modificar el cursor
YMENOR: MOV DL,2  ;Pasamos a modificar el cursor al valer en el otro caso DL 0.

;Recordatorio: DH -> x. DL -> y. 00-> asp<curs. 01->asp==curs. 02->asp>curs.

MODIF:  CMP DX,0000H
        JE  ABJDER
        CMP DX,0001H
        JE  IGUDER
        CMP DX,0002H
        JE  ARRDER
        CMP DX,0100H
        JE  ABJIGU
        CMP DX,0102H ; El cursor nunca esta donde la aspiradora, no hay que comprobar 0101H
        JE  ARRIGU
        CMP DX,0200H
        JE  ABJIZQ
        CMP DX,0201H
        JE  IGUIZQ  ;El otro caso seria ya abajo abajo, que ponemos a continuacion

; Recordatorio: Sentido de las agujas del reloj. AH=curs_x. BH=curs_y.

ARRIZQ: INC AH ;Si esta arriba a la izquierda, de pone arriba
        JMP FIN
ARRIGU: INC AH ;Si esta arriba, se pone arriba a la derecha
        JMP FIN
ARRDER: INC AL ;Si esta arriba a la derecha, se pone a la derecha
        JMP FIN
IGUDER: INC AL ;Si esta a la derecha, se pone abajo a la derecha.
        JMP FIN
ABJDER: DEC AH ;Si esta abajo a la derecha, se pone abajo
        JMP FIN
ABJIGU: DEC AH ;Si esta abajo, se pone abajo a la izquierda
        JMP FIN
ABJIZQ: DEC AL ;Si esta abajo a la izquierda, se pone a la izquierda
        JMP FIN
IGUIZQ: DEC AL ;Si esta a la izquierda, se pone arriba a la izquierda
               ;Ya no hay mas opciones, asi que termina el procedimiento

FIN:    CMP AH,0
        JNE PAR5
        JMP NOESC2
PAR5:   CMP AH,MAX_COL-1
        JNE PAR6
        JMP NOESC2
PAR6:   CMP AL,0        ; As¡ evitamos que el cursor sobreescriba las paredes
        JNE PAR7
        JMP NOESC2
PAR7:   CMP AL,MAX_FIL-1
        JNE BLA2
        JMP NOESC2
BLA2:   CMP AH, CH
        JNE NBLA1
        CMP AL, CL       ; As¡ evitamos que el cursor sobreescriba la bola
        JNE NBLA1
        JMP NOESC2
NBLA1:  MOV CH, DS:[bol1_x]
        MOV CL, DS:[bol1_y]
        CMP AH,CH
        JNE NBLA2
        CMP AL, CL
        JNE NBLA2
        JMP NOESC2
NBLA2:  MOV CH, DS:[bol2_x]
        MOV CL, DS:[bol2_y]
        CMP AH,CH
        JNE NBLA3
        CMP AL, CL
        JNE NBLA3
        JMP NOESC2
NBLA3:  MOV CH, DS:[bol3_x]
        MOV CL, DS:[bol3_y]
        CMP AH,CH                ;Evita que se sobreescriban las bolas extra
        JNE NBLA4
        CMP AL, CL
        JNE NBLA4
        JMP NOESC2
NBLA4:  MOV CH, DS:[bol4_x]
        MOV CL, DS:[bol4_y]
        CMP AH,CH
        JNE NBLA5
        CMP AL, CL
        JNE NBLA5
        JMP NOESC2
NBLA5:  MOV CH, DS:[bol5_x]
        MOV CL, DS:[bol5_y]
        CMP AH,CH
        JNE DIBC
        CMP AL, CL
        JNE DIBC
        JMP NOESC2

DIBC:   PUSH AX ; Aqui van las nuevas coordenadas del cursor
        MOV DX, ('*')
        PUSH DX
        CALL FAR PTR PONERCH   ; Dibujo del cursor
        ADD SP, 4

NOESC2: ADD SP, 2 ; Para quitar el offset de pant tanto si se dibuja como si no
        MOV DS:[curs_x],AH
        MOV DS:[curs_y],AL ; Guardado de las coordenadas en memoria

        POP SI
        POP DX
        POP CX
        POP BX     ; Recuperaci¢n de registros
        POP AX
        POP BP
        RET 

ROTARC ENDP
COD_R ENDS
END
