PUBLIC BORRAR

MAX_PANTX2 EQU 3998

CODIGO_B SEGMENT
        ASSUME CS:CODIGO_B

BORRAR PROC FAR
INICIO: PUSH BP ; Salvaguarda el registro BP
        MOV BP, SP ; BP apunta a la direccion actual
        PUSH AX
        PUSH SI ; Salvaguarda del resto de registros usados
        PUSH ES

        MOV AX,0B800h ;Direccion de memoria del monitor
        MOV ES,AX ;Registro de direccionamiento
        MOV AX, (' ') ;Caracter espacio que ser  usado para borrar
        MOV SI,0 ;Registro usado para direccionar la posicion de escritura

BUCLE:  MOV ES:[SI], AL ; Imprime en pantalla el caracter                           
        ADD SI,2 ;Hay que incrementar de dos en dos SI para escribir letras
        CMP SI, MAX_PANTX2 ; Si se escribe toda la pantalla, se termina.
        JE FIN
        JMP BUCLE

FIN:    POP ES
        POP SI ; Recuperaci¢n de registros
        POP AX
        POP BP
        RET
BORRAR ENDP
CODIGO_B ENDS
END
