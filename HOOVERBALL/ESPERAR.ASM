PUBLIC ESPERAR

COD_E SEGMENT
      ASSUME CS: COD_E
ESPERAR PROC FAR
        PUSH BP
        MOV BP, SP
        PUSH AX
        PUSH CX
        PUSH SI
        PUSH ES

        MOV AX, SS:[BP+6] ; AX contiene el retardo deseado
        MOV CL, 55
        DIV CL       ; Conversi¢n a ticks
        MOV CX, 40H
        MOV ES, CX
        MOV SI, 6CH
        MOV CX, ES:[SI]
        MOV AH, 0
        ADD CX, AX
ESPERA1:MOV DX, ES:[SI]
        CMP DX, CX
        JLE ESPERA1
        
FIN:    POP ES
        POP SI
        POP CX
        POP AX
        POP BP
        RET
ESPERAR ENDP
COD_E ENDS
END
