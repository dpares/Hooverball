PUBLIC DIBUJAR

MAX_PANT EQU 1999

CODIGO_D SEGMENT
        ASSUME CS:CODIGO_D

DIBUJAR PROC FAR
INICIO: PUSH BP ; Salvaguarda el registro BP
        MOV BP, SP ; BP apunta a la direccion actual
        PUSH AX
        PUSH BX
        PUSH SI ; Salvaguarda del resto de registros usados
        PUSH DI
        PUSH ES
        
        MOV AX,0B800h ;Direccion de memoria del monitor
        MOV ES,AX ;Registro de direccionamiento
        MOV BX,0 ;Registro usado para guardar la direcci¢n de pant[0][0]
        MOV SI,0 ;Registro usado para direccionar la posicion de escritura
        MOV DI,0 ;Registro usado para contar el numero de pasos dado
        MOV BX,SS:[BP+6] ; DS:[BX] apunta a pant[0][0]

BUCLE:  MOV AL, DS:[BX+DI]   ;Introduce en AL el caracter ASCII de la posicion DI de pant
        MOV ES:[SI], AL ; Imprime en pantalla el caracter                           
        ADD SI,2 ;Hay que incrementar de dos en dos SI para escribir letras
        CMP DI, MAX_PANT ; Si se escribe toda la pantalla, se termina.
        JE FIN
        INC DI ; Si no, se incrementa DI y se vuelve a ejecutar todo.
        JMP BUCLE

FIN:    POP ES
        POP DI
        POP SI ; Recuperaci¢n de registros
        POP BX
        POP AX
        POP BP
        RET
DIBUJAR ENDP
CODIGO_D ENDS
END
