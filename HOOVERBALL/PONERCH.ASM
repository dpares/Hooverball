PUBLIC PONERCH

MAX_COL EQU 80

CODIGO_P SEGMENT
        ASSUME CS:CODIGO_P

PONERCH PROC FAR
INICIO: PUSH BP ; Salvaguarda el registro BP
        MOV BP, SP ; BP apunta a la direccion actual
        PUSH AX
        PUSH BX
        PUSH CX ; Registros que se van a usar
        PUSH SI
        MOV BX, 0; BX almacenara las coordenadas
        MOV AX,MAX_COL ; Guarda el numero de elementos por fila en AX
        MOV CX, 0; CX guarda la letra y sirve de auxiliar para la suma
        MOV SI, 0; SI almacena la posici¢n dentro de pant.

        MOV BX,SS:[BP+8] ; Guarda las coordenadas del elemento en BX, primero x, y despu‚s
        MUL BL ; Multiplica la posici¢n vertical por MAX_COL
        MOV SI, AX ; Guarda en SI el desplazamiento de y
        MOV CL, BH ; Necesario para la siguiente suma
        ADD SI, CX ; Guarda en SI el desplazamiento relativo a las coordenadas.
        MOV CX, SS:[BP+10] ; Guara en CX el desplazamiento de pant[0][0]
        ADD SI, CX ; Ahora suma al desplazamiento anterior el de pant[0][0]
        MOV CL,SS:[BP+6] ; Se guarda en CL la letra ...
        MOV DS:[SI], CL ; Y se pone el caracter en la posici¢n correspondiente.

        POP SI
        POP CX  ;Recuperaci¢n de registros
        POP BX
        POP AX
        POP BP
        RET;Vuelta a ASPIRA

PONERCH ENDP
CODIGO_P ENDS
END
