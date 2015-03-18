EXTRN PONERCH: FAR ; Se usar  el procedimiento de poner caracter.
EXTRN curs_x:BYTE
EXTRN curs_y:BYTE  ;Etiquetas de los cursores
EXTRN bol_x:BYTE
EXTRN bol_y:BYTE
PUBLIC MOVBOL
MAX_COL EQU 80
MAX_FIL EQU 24

COD_MB  SEGMENT
        ASSUME CS:COD_MB

MOVBOL  PROC FAR    ; Procedimiento mover_bola de aspiradora.cpp
INICIO: PUSH BP    ;Salvaguarda de BP
        MOV BP,SP
        SUB SP, 4 ;Hueco para las variables locales
        PUSH AX
        PUSH BX
        PUSH CX  ; Necesitaremos los seis registros
        PUSH DX
        PUSH SI
        PUSH DI
        MOV CX, SS:[BP+8] ;Coordenadas cursor. CH = curs_x, CL = curs_y
        MOV BX, SS:[BP+6] ;Coordenadas bola. BH = bol_x, BL = bol_y
        MOV AX, MAX_COL ; Necesario para multiplicar luego
        MOV DX, SS:[BP+12] ; Offset de pant2[0][0]
        MOV DI, SS:[BP+10] ; Offset de rebote
        MOV SI, DX
        MUL CL ; Necesario para calcular la coordenada y
        ADD SI, AX
        MOV AH, 0
        MOV AL, CH     ; Calculo del desplazamiento
        ADD SI, AX

COMP_1: MOV AL, ('|')
        CMP DS:[SI], AL  ;¨Rebota en pared vertical?
        JNE COMP_2
        MOV AL, 1
        MOV DS:[DI], AL ; Rebote = true
        MOV AH, CH
        DEC AH
        CMP BH, AH ; Si la bola viene por la izquierda y rebota...
        JNE SIG1
        SUB CH, 2   ; Se cambia la direccion del cursor
        JMP MOVIM
SIG1:   ADD AH, 2
        CMP BH, AH ; Si viene por la derecha...
        JNE COMP_2
        ADD CH, 2
        JMP MOVIM

COMP_2: MOV AL, ('-')
        CMP DS:[SI], AL  ;  ¨Rebota en pared horizontal?
        JNE COMP_3
        MOV AL, 1
        MOV DS:[DI], AL ; Rebote = true
        MOV AL, CL
        DEC AL
        CMP BL, AL ; Si la bola viene por arriba y rebota...
        JNE SIG2
        SUB CL, 2   ; Se cambia la direccion del cursor
        JMP MOVIM
SIG2:   ADD AL, 2
        CMP BL, AL ; Si viene por debajo...
        JNE COMP_3
        ADD CL, 2
        JMP MOVIM

COMP_3: MOV AL, ('+')
        CMP DS:[SI], AL  ;      ¨Rebota en la esquina?
        JNE MOVIM
        MOV AL, 1
        MOV DS:[DI], AL ; Rebote = true
        MOV AL, CL
        DEC AL
        CMP BL, AL ; Si la bola viene por arriba y rebota...
        JNE SIG3
        SUB CL, 2   ; Se cambia la direccion del cursor
        JMP MOVIM
SIG3:   ADD AL, 2
        CMP BL, AL ; Si viene por debajo...
        JNE MOVIM
        ADD CL, 2

MOVIM:  PUSH DX
        PUSH BX
        MOV AX, (' ')
        PUSH AX
        CALL FAR PTR PONERCH ; Borra la bola
        ADD SP, 4
        MOV SS:[BP-2], CH ; SS:[BP-2] = aux_x
        MOV SS:[BP-4], CL ; SS:[BP-4] = aux_y
        MOV DX, 0
                
        CMP CH,BH ;Se comparan las variables x
        JE XIGUAL ;Si son iguales se indica en DX
        DEC BH    ;Se estudia ahora curs_x==bol_x-1
        CMP CH,BH
        JE XMENOR ;Si son iguales se indica de otra forma
        INC BH    ;Se recupera el valor de BL
        JMP CMPY;La opcion que quedaba era curs_x==bol_x+1. Entendemos que DH entonces vale 0.

XIGUAL: MOV DH,1
        JMP CMPY  ;Se pasa a estudiar y
XMENOR: MOV DH,2  ;Como en la otra opcion DH valdra 0, seguimos inmediatamente a comparar y

CMPY:   CMP CL,BL ;Se comparan las variables y
        JE YIGUAL ;Si son iguales se indica en DX
        DEC BL    ;Se estudia ahora curs_y==bol_y-1
        CMP CL,BL
        JE YMENOR ;Si son iguales se indica de otra forma
        INC BL    ;Se recupera el valor de BL
        JMP MODIF;La opcion que quedaba era curs_y==bol_y+1. Entendemos que DH entonces vale 0.

YIGUAL: MOV DL,1
        JMP MODIF  ;Se pasa a modificar el cursor
YMENOR: MOV DL,2  ;Pasamos a modificar el cursor al valer en el otro caso DL 0.

;Recordatorio: DH -> x. DL -> y. 00-> bol<curs. 01->bol==curs. 02->bol>curs.

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

; Recordatorio: Sentido de las agujas del reloj. CH=curs_x. CH=curs_y.

ARRIZQ: DEC CL
        DEC CH  ;El cursor avanza en la misma direcci¢n, as¡ con todo
        JMP FIN
ARRIGU: DEC CL
        JMP FIN
ARRDER: DEC CL
        INC CH
        JMP FIN
IGUDER: INC CH
        JMP FIN
ABJDER: INC CL
        INC CH
        JMP FIN
ABJIGU: INC CL
        JMP FIN
ABJIZQ: INC CL
        DEC CH
        JMP FIN
IGUIZQ: DEC CH
               ;Ya no hay mas opciones, asi que termina el procedimiento

FIN:    MOV DS:[curs_x],CH
        MOV DS:[curs_y],CL ; Guardado de las coordenadas en memoria
        MOV AH, SS:[BP-2]
        MOV AL, SS:[BP-4]
        MOV DS:[bol_x],AH  ; Guardado de coordenadas, pas ndolas desde los aux
        MOV DS:[bol_y],AL
        PUSH AX
        MOV AX, (169)   ; Impresion de la bola en su nueva posicion
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 6

        POP DI
        POP SI
        POP DX
        POP CX
        POP BX     ; Recuperaci¢n de registros
        POP AX
        ADD SP, 4 ; Borrado de variables locales
        POP BP
        RET

MOVBOL ENDP
COD_MB ENDS
END
