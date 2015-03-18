EXTRN PONERCH: FAR ; Se usar  el procedimiento de poner caracter.
EXTRN curs_x:BYTE
EXTRN curs_y:BYTE  ;Etiquetas de los cursores
EXTRN asp_x:BYTE
EXTRN asp_y:BYTE
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
PUBLIC MOVASP
MAX_COL EQU 80
MAX_FIL EQU 24

COD_M  SEGMENT
        ASSUME CS:COD_M

MOVASP  PROC FAR    ; Procedimiento mover_aspiradora de aspiradora.cpp
INICIO: PUSH BP    ;Salvaguarda de BP
        MOV BP,SP
        SUB SP, 4 ;Hueco para las variables locales
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
        MOV CX, SS:[BP+10] ;Coordenadas bola 
        MOV DX, SS:[BP+12] ; Offset de pant[0][0]
        PUSH DX
        PUSH BX
        MOV DX, (' ')
        PUSH DX
        CALL FAR PTR PONERCH ; Borra la aspiradora
        ADD SP, 4

        CMP AH,0
        JE REB_IZQ ; Si rebota en la pared izquierda...
        CMP AH,MAX_COL-1
        JNE REB_Y ; Si no rebota horizontalmente, se estudia si lo hace verticalmente
REB_DER:SUB AH,2 ; El cursor pasa de derecha a izquierda
        JMP REB_Y
REB_IZQ:ADD AH,2 ; El cursor pasa de izquierda a derecha

REB_Y:  CMP AL,0
        JE REB_ARR ;Si rebota arriba...
        CMP AL,MAX_FIL-1
        JNE MOVIM ;Si no rebota verticalmente, se pasa ya a mover la aspiradora.
REB_ABJ:SUB AL,2 ; El cursor pasa de abajo a arriba
        JMP MOVIM
REB_ARR:ADD AL,2 ; El cursor pasa de arriba a abajo


MOVIM:  PUSH AX ; Contiene las coordenadas del cursor
        MOV DX, ('o')
        PUSH DX
        CALL FAR PTR PONERCH  ;Dibuja en la nueva posici¢n la aspiradora
        ADD SP, 4
        MOV DX, 0 ; Hace falta que est‚ a 0 para lo siguiente
        MOV SS:[BP-2], AH ; SS:[BP-2] = aux_x
        MOV SS:[BP-4], AL ; SS:[BP-4] = aux_y
                
        CMP AH,BH ;Se comparan las variables x
        JE XIGUAL ;Si son iguales se indica en DX
        DEC BH    ;Se estudia ahora curs_x==asp_x-1
        CMP AH,BH
        JE XMENOR ;Si son iguales se indica de otra forma
        INC BH    ;Se recupera el valor de AL
        JMP CMPY;La opcion que quedaba era curs_x==asp_x+1. Entendemos que DH entonces vale 0.

XIGUAL: MOV DH,1
        JMP CMPY  ;Se pasa a estudiar y
XMENOR: INC BH
        MOV DH,2  ;Como en la otra opcion DH valdra 0, seguimos inmediatamente a comparar y

CMPY:   CMP AL,BL ;Se comparan las variables y
        JE YIGUAL ;Si son iguales se indica en DX
        DEC BL    ;Se estudia ahora curs_y==asp_y-1
        CMP AL,BL
        JE YMENOR ;Si son iguales se indica de otra forma
        INC BL    ;Se recupera el valor de BL
        JMP MODIF;La opcion que quedaba era curs_y==asp_y+1. Entendemos que DH entonces vale 0.

YIGUAL: MOV DL,1
        JMP MODIF  ;Se pasa a modificar el cursor
YMENOR: INC BL
        MOV DL,2  ;Pasamos a modificar el cursor al valer en el otro caso DL 0.

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

ARRIZQ: DEC AL
        DEC AH  ;El cursor avanza en la misma direcci¢n, as¡ con todo
        JMP FIN
ARRIGU: DEC AL
        JMP FIN
ARRDER: DEC AL
        INC AH
        JMP FIN
IGUDER: INC AH
        JMP FIN
ABJDER: INC AL
        INC AH
        JMP FIN
ABJIGU: INC AL
        JMP FIN
ABJIZQ: INC AL
        DEC AH
        JMP FIN
IGUIZQ: DEC AH
               ;Ya no hay mas opciones, asi que termina el procedimiento

FIN:    CMP AH,0     ; Se estudia que el cursor no sobreescriba paredes
        JNE R_DER
        JMP FREAL
R_DER:  CMP AH,MAX_COL-1
        JNE R_ARR
        JMP FREAL
R_ARR:  CMP AL,0
        JNE R_ABJ
        JMP FREAL
R_ABJ:  CMP AL,MAX_FIL-1
        JNE BOL_X
        JMP FREAL
BOL_X:  CMP AH,CH
        JNE VERBLAS
BOL_Y:  CMP AL,CL    ; Ahora, que no sobreescriba bolas
        JNE VERBLAS
        JMP FREAL
VERBLAS:MOV CH, DS:[bol1_x]
        MOV CL, DS:[bol1_y]
        CMP AH,CH
        JNE VERB2
        CMP AL, CL
        JNE VERB2
        JMP FREAL
VERB2:  MOV CH, DS:[bol2_x]
        MOV CL, DS:[bol2_y]
        CMP AH,CH
        JNE VERB3
        CMP AL, CL
        JNE VERB3
        JMP FREAL
VERB3:  MOV CH, DS:[bol3_x]
        MOV CL, DS:[bol3_y]
        CMP AH,CH                ;Evita que se borren las bolas extra
        JNE VERB4
        CMP AL, CL
        JNE VERB4
        JMP FREAL
VERB4:  MOV CH, DS:[bol4_x]
        MOV CL, DS:[bol4_y]
        CMP AH,CH
        JNE VERB5
        CMP AL, CL
        JNE VERB5
        JMP FREAL
VERB5:  MOV CH, DS:[bol5_x]
        MOV CL, DS:[bol5_y]
        CMP AH,CH
        JNE D_CURS
        CMP AL, CL
        JNE D_CURS
        JMP FREAL

D_CURS: PUSH AX ;Aqui van las nuevas coordenadas del cursor
        MOV DX, ('*')
        PUSH DX
        CALL FAR PTR PONERCH   ; Dibujo del cursor
        ADD SP, 4

FREAL:  ADD SP, 2    ; Para quitar el offset de pant
        MOV DS:[curs_x],AH
        MOV DS:[curs_y],AL ; Guardado de las coordenadas en memoria
        MOV AH, SS:[BP-2]
        MOV AL, SS:[BP-4]
        MOV DS:[asp_x],AH  ; Guardado de coordenadas, pas ndolas desde los aux
        MOV DS:[asp_y],AL       

        POP SI
        POP DX
        POP CX
        POP BX     ; Recuperaci¢n de registros
        POP AX
        ADD SP, 4 ; Borrado de variables locales
        POP BP
        RET

MOVASP ENDP
COD_M ENDS
END
