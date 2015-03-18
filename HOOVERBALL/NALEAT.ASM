PUBLIC NALEAT ;Genera dos numeros aleatorios: Uno en AH y otro en AL

COD_NA SEGMENT
        ASSUME CS:COD_NA
NALEAT PROC FAR
INICIO: PUSH BX
        PUSH CX
        PUSH ES
        MOV AX, 40H
        MOV ES, AX
        MOV AX, ES:[6CH] ; Guarda los ticks en AX, se usar n para generar los n£meros
        MOV AH, 0
        MOV BL, 22
        DIV BL ;MAX_FIL-2. En AH esta AL MOD 22
        MOV CH, AH ; Se guarda en CH el resultado de momento
        MOV AX, ES:[6CH]
        SUB AL, 47
        MOV BL, 3
        MUL BL             ; Para que las coordenadas difieran
        MOV AH, 0
        MOV BL, 78
        DIV BL ;MAX_COL-2. En AH esta AL MOD 72
        MOV AL, CH ; Ya se tienen dos coordenadas aleatorias en AX
        INC AH
        INC AL ; Para evitar que valgan 0. Por eso lo hacemos con MAX-2

FIN:    POP ES
        POP CX
        POP BX
        RET
ENDP NALEAT
COD_NA ENDS
END INICIO

