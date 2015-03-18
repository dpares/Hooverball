PUBLIC ENCESTA
EXTRN c5_x: BYTE
EXTRN c5_y: BYTE
EXTRN c10_x: BYTE
EXTRN c10_y: BYTE
EXTRN c25_1_x: BYTE
EXTRN c25_2_x: BYTE
EXTRN c25_y: BYTE

CODIGO_EN SEGMENT
        ASSUME CS:CODIGO_EN

ENCESTA PROC FAR
        PUSH BP
        MOV BP, SP
        PUSH AX ; Registro que guarda las coordenadas de la bola
        PUSH SI ; Registro usado para direccionar las direcciones de memoria
        PUSH BX ; Registro usado para las variables locales
        PUSH CX ; Lo mismo que BX
        PUSH DX ; Registro usado en la comparaci¢n
        MOV AX, SS:[BP+6] ; AH= Coordenada X. AL= Coordenada Y.
        MOV CX, 0 ; Si no est  en ninguna caja, canasta=false
        MOV BX, 0

COMP_5: MOV DH, DS:[c5_x]
        CMP AH, DH
        JNAE COMP_251 ; if(bol_x>=c5_x)&&...
        ADD DH, 29
        CMP AH, DH
        JNBE COMP_251 ; (bol_x<=c5_x+29)&&...
        MOV DL, DS:[c5_y]
        CMP AL, DL
        JNAE COMP_251 ; (bol_y>=c5_y)&&...
        ADD DL, 3
        CMP AL, DL
        JNBE COMP_251 ; (bol_y<=c5_y+3)){
        MOV CX, 1 ; canasta=true
        MOV BH, 5 ; punt=5
        MOV BL, 1 ; t_caja=1}
        JMP FIN

COMP_251: MOV DH, DS:[c25_1_x]
        CMP AH, DH  ; Lo mismo para c25_1
        JNAE COMP_252
        ADD DH, 9
        CMP AH, DH
        JNBE COMP_252
        MOV DL, DS:[c25_y]
        CMP AL, DL
        JNAE COMP_252
        ADD DL, 1
        CMP AL, DL
        JNBE COMP_252
        MOV CX, 1 ; canasta=true
        MOV BH, 25 ; punt=25
        MOV BL, 2 ; t_caja=2
        JMP FIN

COMP_252: MOV DH, DS:[c25_2_x]
        CMP AH, DH  ; Lo mismo para c25_2
        JNAE COMP_10
        ADD DH, 9
        CMP AH, DH
        JNBE COMP_10
        MOV DL, DS:[c25_y]
        CMP AL, DL
        JNAE COMP_10
        ADD DL, 1
        CMP AL, DL
        JNBE COMP_10
        MOV CX, 1 ; canasta=true
        MOV BH, 25 ; punt=25
        MOV BL, 3 ; t_caja=3
        JMP FIN


COMP_10:MOV DH, DS:[c10_x]
        CMP AH, DH    ; Ahora se repite todo para c10.
        JNAE FIN
        ADD DH, 11
        CMP AH, DH
        JNBE FIN
        MOV DL, DS:[c10_y]
        CMP AL, DL
        JNAE FIN
        ADD DL, 2
        CMP AL, DL
        JNBE FIN
        MOV CX, 1 ; canasta=true
        MOV BH, 10 ; punt=10
        MOV BL, 4 ; t_caja=4

FIN:    MOV SI, SS:[BP+12]
        MOV AX, CX  ; Guardado de canasta
        MOV DS:[SI], AL
        MOV SI, SS:[BP+10]
        MOV AL, BH    ; Guardado de punt
        MOV DS:[SI], AL
        MOV SI, SS:[BP+8]
        MOV AL, BL     ; Guardado de t_caja
        MOV DS:[SI], AL
        POP DX
        POP CX
        POP BX       ;Recuperaci¢n de registros
        POP SI
        POP AX
        POP BP
        RET
ENCESTA ENDP
CODIGO_EN ENDS
END
