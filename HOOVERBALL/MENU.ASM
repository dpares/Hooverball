EXTRN BORRAR: FAR
PUBLIC MENU

DAT1 SEGMENT
        titulo DB "______  __                                    ______          ____________"     
               DB "___  / / /______ ______ ___   _______ ___________  /_ ______ ____  /___  /"     
               DB "__  /_/ / _  __ \_  __ \__ | / /_  _ \__  ___/__  __ \_  __ `/__  / __  / "     
               DB "_  __  /  / /_/ // /_/ /__ |/ / /  __/_  /    _  /_/ // /_/ / _  /  _  /  "     
               DB "/_/ /_/   \____/ \____/ _____/  \___/ /_/     /_.___/ \__,_/  /_/   /_/   "     

        op1 DB "+-------------+"
            DB "|    JUGAR    |"
            DB "+-------------+"
        op2 DB "+-------------+"
            DB "|INSTRUCCIONES|"
            DB "+-------------+"
        op3 DB "+-------------+"
            DB "|    SALIR    |"
            DB "+-------------+"

        info DB "+--------------------------------------------------------------------+"
             DB "| Hooverball es un juego arcade donde el unico objetivo es conseguir |"
             DB "|            la mayor puntuaci¢n posible en dos niveles.             |"
             DB "|                                                                    |"
             DB "| -Primer nivel: Atrapa bolas con tu aspiradora giratoria            |"
             DB "|       -Controles: Espacio  -> Avanzar hacia donde apunte el cursor |"
             DB "|                                            (mantener)              |"
             DB "|                   Pulsador -> Dejar 5 bolas, perder 10 seg         |"
             DB "| -Segundo nivel: Encesta las bolas obtenidas anteriormente          |"
             DB "|                 aprovechando hasta cinco rebotes                   |"
             DB "|       -Controles: Espacio   -> Lanzar bola                         |"
             DB "|                   Izda/Dcha -> Mover aspiradora                    |"
             DB "|                   Z/X       -> Elegir direcci¢n tiro               |"
             DB "|                   Pulsador  -> Reiniciar contador rebotes perdiendo|"
             DB "|                                dos bolas al fallar (1 pulsacion)   |"
             DB "|                   Pulsador  -> Poner cajas en su posicion original.|"
             DB "|                                Se pierde una bola (2 pulsaciones)  |"
             DB "|          (CLICK DERECHO PARA VOLVER AL MENU PRINCIPAL)             |"
             DB "+--------------------------------------------------------------------+"
                                                                          

DAT1 ENDS

CODE SEGMENT
        ASSUME CS:CODE, DS:DAT1
MENU PROC FAR
        PUSH BX
        PUSH CX
        PUSH SI
        PUSH DI
        PUSH DS
        PUSH ES

        MOV AX, DAT1
        MOV DS, AX
        MOV AX, 0B800H
        MOV ES, AX

PONTOD: MOV AX,80 ; Numero de elementos por fila
        MOV BX, 2
        MUL BX  ; Coordenada y de la primera letra del t¡tulo(x2)
        MOV SI, AX
        ADD SI, BX ; Coordenada x de la primera letra del t¡tulo(x2)
        MOV BX, 0 ; Contador
        MOV DI, 0
        MOV CX, 0
D_TITLE:MOV AL, titulo[DI+BX]
        MOV ES:[SI], AL
        ADD SI,2; As¡, la posici¢n de escritura va de dos en dos
        INC BX
        CMP BX, 74 ; Numero de caracteres por fila
        JNE D_TITLE
        ADD DI, 74
        MOV BX, 0
        INC CX
        ADD SI, 12 ; Para pasar a la siguiente fila
        CMP CX, 5 ; Numero de filas (menos una, al ser la primera 0)
        JNE D_TITLE

D_BOTON:MOV AX, 80
        MOV BX, 18
        MUL BX ; Fila 9
        MOV SI, AX
        ADD SI, 64 ; Columna 32
        MOV BX, 0
        MOV DI, 0
        MOV CX, 0
D_OPTI1:MOV AL, op1[DI+BX]
        MOV ES:[SI], AL
        ADD SI, 2
        INC BX
        CMP BX, 15
        JNE D_OPTI1
        INC CX
        MOV BX, 0
        ADD DI, 15
        ADD SI, 130
        CMP CX, 3
        JNE D_OPTI1

        MOV AX, 80
        MOV BX, 26
        MUL BX ; Fila 13
        MOV SI, AX
        ADD SI, 64 ; Columna 32
        MOV BX, 0
        MOV DI, 0
        MOV CX, 0
D_OPTI2:MOV AL, op2[DI+BX]
        MOV ES:[SI], AL
        ADD SI, 2
        INC BX
        CMP BX, 15
        JNE D_OPTI2
        INC CX
        MOV BX, 0
        ADD DI, 15
        ADD SI, 130
        CMP CX, 3
        JNE D_OPTI2

        MOV AX, 80
        MOV BX, 34
        MUL BX ; Fila 17
        MOV SI, AX
        ADD SI, 64 ; Columna 32
        MOV BX, 0
        MOV DI, 0
        MOV CX, 0
D_OPTI3:MOV AL, op3[DI+BX]
        MOV ES:[SI], AL
        ADD SI, 2
        INC BX
        CMP BX, 15
        JNE D_OPTI3
        INC CX
        MOV BX, 0
        ADD DI, 15
        ADD SI, 130
        CMP CX, 3
        JNE D_OPTI3

REC_CURS:MOV AX,1
        INT 33H   ; Muestra el cursor del rat¢n

B_RATON:MOV AX,5
        MOV BX,0
        INT 33H    ; ¨Se ha pulsado el bot¢n izquierdo?
        CMP BX,1
        JAE DONDE
        JMP B_RATON

DONDE:  MOV AX, 2
        INT 33H
        MOV AX,3
        INT 33H      ; ¨Donde estaba el cursor cuando se puls¢?
        MOV AX,CX
        MOV BL, 8
        DIV BL
        MOV CH,AL   ; CH tiene la posicion horizontal del cursor y CL la vert.
        MOV AX, DX  ; Hay que dividir por 8 ya que devuelve valores en 600*200
        DIV BL
        MOV CL, AL

        CMP CH, 32
        JB REC_CURS
        CMP CH, 46   ; Las cajas est n en 32<=X<=46
        JA REC_CURS

C_JUG:  CMP CL, 9
        JB REC_CURS ; Si est  encima de C_JUG no est  en ninguna caja
        CMP CL, 11
        JA C_INFO
        MOV CX, 0
        JMP FIN

C_INFO: CMP CL, 13
        JB REC_CURS ; Si est  encima de C_INFO entonces est  entre las dos cajas
        CMP CL, 15
        JA C_SALIR
        MOV AX, 80
        MOV BL, 12 ; Fila 6
        MUL BL
        MOV SI, AX
        ADD SI, 10 ; Columna 5
        MOV BX, 0
        MOV CX, 0
        MOV DI, 0

D_INFO: MOV AL, info[DI+BX]
        MOV ES:[SI], AL
        ADD SI, 2
        INC BX
        CMP BX, 70
        JNE D_INFO
        INC CX
        MOV BX, 0
        ADD DI, 70
        ADD SI, 20
        CMP CX, 19
        JNE D_INFO

B_DER:  MOV AX,5
        MOV BX,1
        INT 33H    ; ¨Se ha pulsado el bot¢n derecho?
        CMP BX,1
        JB B_DER
        CALL FAR PTR BORRAR
        JMP PONTOD


C_SALIR:CMP CL, 17
        JAE OPTI_LS
        JMP REC_CURS
OPTI_LS:CMP CL, 19   ; Estudio del l¡mite superior
        JBE ACT_CX   ; Ya no hay nada debajo
        JMP REC_CURS

ACT_CX: MOV CX, 1
        JMP FIN

FIN:    MOV AX, 2     ; Dejar de mostrar cursor del rat¢n
        INT 33H
        MOV AX, CX
        POP ES
        POP DS
        POP DI
        POP SI   ; Recuperaci¢n de registros
        POP CX
        POP BX
        RET

MENU ENDP
CODE ENDS
END
