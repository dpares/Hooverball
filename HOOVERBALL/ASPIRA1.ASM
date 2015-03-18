EXTRN MENU:FAR ; Nombre del procedimiento que llama y gestiona el men£
EXTRN DIBUJAR:FAR ; Nombre del procedimiento usado para dibujar la pantalla
EXTRN ESPERAR:FAR ; Procedimiento de espera
EXTRN PONERCH:FAR ; Procedimiento para escribir un caracter
EXTRN ROTARC:FAR ; Procedimiento para rotar el cursor
EXTRN MOVASP:FAR ; Procedimiento para mover la aspiradora
EXTRN BORRAR:FAR ; Procedimiento para borrar la pantalla
EXTRN B_CAJA:FAR ; Procedimiento bara borrar una caja
EXTRN D_CAJA:FAR ; Procedimiento bara dibujar una caja
EXTRN MOVBOL:FAR ; Procedimiento para mover la bola en el segundo nivel
EXTRN ENCESTA:FAR ; Procedimiento que comprueba si una bola ha sido encestada.
EXTRN NALEAT:FAR ; Procedimiento que genera coordenadas aleatorias
PUBLIC curs_x
PUBLIC curs_y 
PUBLIC asp_x
PUBLIC asp_y
PUBLIC bol_x
PUBLIC bol_y
PUBLIC c5_x
PUBLIC c5_y          ; Variables globales usadas en otros procedimientos
PUBLIC c10_x
PUBLIC c10_y
PUBLIC c25_1_x
PUBLIC c25_2_x
PUBLIC c25_y
PUBLIC bol1_x 
PUBLIC bol1_y 
PUBLIC bol2_x 
PUBLIC bol2_y 
PUBLIC bol3_x       ;Usados en el pulsador durante el primer nivel.
PUBLIC bol3_y 
PUBLIC bol4_x 
PUBLIC bol4_y 
PUBLIC bol5_x 
PUBLIC bol5_y 

MAX_FIL EQU 24 ; Numero de filas
MAX_COL EQU 80 ; Numero de columnas
MAX_PANT EQU 1999 ; Numero total de elementos, (MAX_FIL+1)*MAX_COL -1
CO5_X EQU 25 ; Coordenada x inicial de la esquina superior izquierda de la caja original de 5
CO5_Y EQU 7 ; Coordenada y del mismo punto de la misma caja.
CO25_1_X EQU 9 ; Coordenada x del mismo punto de la primera caja de 25
CO25_2_X EQU 62 ; Coordenada x del mismo punto de la segunda caja de 25
CO25_Y EQU 3 ; Coordenada y del mismo punto de las dos cajas de 25
CO10_X EQU 34 ; Coordenada x del mismo punto de la caja original de 10
CO10_Y EQU 13 ; Coordenada y del mismo punto de la caja original de la misma caja.

DATOS SEGMENT ; Segmento de datos
        asp_x DB 40 ; Coordenada x de la aspiradora (Primera dimension del array)
        asp_y DB 12 ; Coordenada y de la aspiradora (Segunda dimension del array)
        curs_x DB 40 ; Coordenada x del cursor
        curs_y DB 11 ; Coordenada y del cursor
        bol_x DB ? ; Coordenada x de la bola
        bol_y DB ? ; Coordenada y de la bola
        acurs_x DB ? ; Coordenada x auxiliar usada en el segundo nivel
        acurs_y DB ? ; Coordenada y auxiliar para borrar el cursor

        prim_puls DB 0 ; Usado para ver si la aspiradora esta en movimiento o no
        bolas DB 0 ; Muestra cuantas bolas se han recogido/quedan por usar
        tiempo DB 31 ; Segundos que quedan para que termine la seccion de recolecta
        segundos DW 0 ; Se usara de contador para el tiempo. Llega a 990.
        puntos DW 0 ; Indica los puntos obtenidos en la segunda fase.
        punt DB 0 ; Indicador auxiliar de puntos
        nivel DB 0 ; Indicador de en qu‚ nivel se est 

        rebote DB 0 ; Usado para averiguar cuando la bola rebota.
        botes DB 5 ; Maximo numero de botes que puede dar una bola antes de desaparecer
        canasta DB 0 ; Indica si una bola se ha encestado
        t_caja DB ? ; Tipo de caja a dibujar.

        c5_x DB CO5_X ; Coordenada x inicial de la esquina superior izquierda de la caja de 5
        c5_y DB CO5_Y ; Coordenada y inicial del mismo punto de la misma caja
        c25_1_x DB CO25_1_X ; Coordenada x inicial de la esquina superior izquierda de la primera caja de 25 
        c25_2_x DB CO25_2_X ; Coordenada x inicial de la esquina superior izquierda de la segunda caja
        c10_x DB CO10_X ; Coordenada x inicial de la esquina superior izquierda de la caja de 10
        c10_y DB CO10_Y ; Coordenada y inicial del mismo punto de la misma caja.
        c25_y DB CO25_Y ; Coordenada y de las dos cajas de 25

        pant DB '+',MAX_COL-2 DUP ('-'),'+' ;Pantalla del primer nivel 
             DB MAX_FIL-2 DUP('|', MAX_COL-2 DUP (' '), '|')
             DB '+',MAX_COL-2 DUP ('-'),'+'
             DB 5 DUP (' '), "Tiempo:   ", 20 DUP (' '), "Bolas:  0", 36 DUP(' ')

        pant2 DB '+',MAX_COL-2 DUP ('-'),'+'; Pantalla del segundo nivel
              DB 2 DUP('|', MAX_COL-2 DUP (' '), '|')
              DB "|        |   25   |                                           |   25   |       |"
              DB "|        +--------+                                           +--------+       |"
              DB 2 DUP('|', MAX_COL-2 DUP (' '), '|')
              DB "|                        |              5             |                        |"
              DB "|                        |                            |                        |"
              DB "|                        |                            |                        |"
              DB "|                        +----------------------------+                        |" 
              DB 2 DUP('|', MAX_COL-2 DUP (' '), '|')
              DB "|                                 |    10    |                                 |"
              DB "|                                 |          |                                 |"
              DB "|                                 +----------+                                 |"
              DB 7 DUP('|', MAX_COL-2 DUP (' '), '|')
              DB '+',MAX_COL-2 DUP ('-'),'+'
              DB 5 DUP (' '), "Puntuacion:   0", 15 DUP (' '), "Bolas:   ", 36 DUP(' ')
        sig_niv DB "Siguiente nivel.$" ;Mensaje entre los dos niveles
        cierre DB "Fin de la partida. ­Gracias por jugar!$"    ;Mensaje tras terminar la partida
        bol1_x DB 0
        bol1_y DB 0
        bol2_x DB 0
        bol2_y DB 0
        bol3_x DB 0      ;Usados en el pulsador durante el primer nivel.
        bol3_y DB 0
        bol4_x DB 0
        bol4_y DB 0
        bol5_x DB 0
        bol5_y DB 0
        bolasx DB 0 ; Indica si hay que reconocer las nuevas bolas o no
        rti_pr DD ?   ;Almacenan las rutinas
        rti_pr2 DD ?
        click DB 0    ;Indica el estado del pulsador
        ticks DW 0    ;Usado en la rutina de tiempo
        contp DB 0    ;Usado en la rutina de pulsador y tiempo
        b_extra DB 0  ;Advierte si se ha usado el "rebote" del pulsador en el nivel 2
DATOS ENDS

PILA SEGMENT STACK ; Segmento de pila
        DB 2048 DUP ('?')
PILA ENDS

CODIGO SEGMENT ; Segmento de codigo
        ASSUME CS: CODIGO, DS: DATOS, SS: PILA

INICIO: MOV AX, DATOS
        MOV DS, AX    ;Hace que DS apunte a DATOS
        MOV AX, 0
        MOV ES, AX

        MOV AX, WORD PTR ES:[28*4]   
        MOV DX, WORD PTR ES:[28*4+2]
        MOV WORD PTR DS:[rti_pr], AX     ;Cambio de rutina timer
        MOV WORD PTR DS:[rti_pr+2], DX
        CLI
        MOV WORD PTR ES:[28*4], OFFSET rti_time
        MOV WORD PTR ES:[28*4+2], SEG rti_time
        STI
        MOV AX, WORD PTR ES:[15*4]   
        MOV DX, WORD PTR ES:[15*4+2]
        MOV WORD PTR DS:[rti_pr2], AX     ;Cambio de rutina pulsador
        MOV WORD PTR DS:[rti_pr2+2], DX
        CLI
        MOV WORD PTR ES:[15*4], OFFSET rti_puls
        MOV WORD PTR ES:[15*4+2], SEG rti_puls
        STI
        MOV DX, 37AH
        IN AL, DX
        OR AL, 00010000B   ;   Cambio de un bit para que acepte pulsaciones??
        OUT DX, AL
        MOV DX, 21H
        IN AL, DX ; Cambio de la m scara IMR para aceptar el pulsador
        AND AL, 01111111B
        OUT DX, AL

PREPAR: MOV AX, 0
        INT 33H
        MOV CH,00111011b
        MOV CL,00001100b      
        MOV AH, 1     ; Hacer que el cursor no aparezca en pantalla
        INT 10H
        CMP AX, 0
        JNE HAY_RAT
        SUB SP, 2 ; Para que al final no haya un desequilibrio en la pila
        JMP FIN

HAY_RAT:CALL FAR PTR BORRAR; Borra la pantalla
        CALL FAR PTR MENU; Menu de inicio
        CMP AX, 0
        JE EMPEZ
        SUB SP, 2 ; Para evitar desequilibrio al final
        JMP FIN

EMPEZ:  LEA AX, DS:[pant] ; Guarda en AX el offset de pant.
        PUSH AX ; Guarda en AX la referencia a pant.
        CALL FAR PTR DIBUJAR ; Se dibujan los bordes de la pantalla.
        ; El offset de pant se deja en la pila, ya que har  falta a menudo
        MOV AX, 2000 ; Esperar 2 segundos antes de continuar
        PUSH AX
        CALL FAR PTR ESPERAR
        ADD SP, 2
        MOV AH, DS:[asp_x]
        MOV AL, DS:[asp_y] ;Guardado de coordenas
        PUSH AX ;Se almacenan ambas en AX
        MOV AX, ('o')  ;Se guarda tambi‚n en AX el car cter
        PUSH AX
        CALL FAR PTR PONERCH  ;Dibujo del car cter en el array pant
        ;Se hace exactamente lo mismo con el cursor...
        ADD SP, 4
        MOV AH, DS:[curs_x]
        MOV AL, DS:[curs_y]
        PUSH AX
        MOV AX, ('*')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4   ; Y ahora con la bola...
        CALL FAR PTR NALEAT; Coordenadas aleatorias
        MOV DS:[bol_x], AH
        MOV DS:[bol_y], AL
        PUSH AX
        MOV AX, (169) ;S¡mbolo de marca registrada
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4
        CALL FAR PTR DIBUJAR ; Se dibuja la pantalla tras los cambios
        MOV AX, 2000
        PUSH AX
        CALL FAR PTR ESPERAR
        ADD SP, 2
        MOV DS:[nivel], 1
        JMP FBUCLE1

BUCLE1: CALL FAR PTR DIBUJAR
        MOV AH,1  ;¨Se ha pulsado alguna tecla?
        INT 16H
        JZ VERBARR
        JMP PMOV
VERBARR:MOV AL, DS:[prim_puls]
        CMP AL, 1
        JNE ROTAR
        JMP MOVER
ROTAR:  MOV AH,DS:[bol_x]
        MOV AL,DS:[bol_y]
        PUSH AX
        MOV AH,DS:[curs_x]
        MOV AL,DS:[curs_y]
        PUSH AX
        MOV AH,DS:[asp_x]
        MOV AL,DS:[asp_y]
        PUSH AX
        CALL FAR PTR ROTARC
        ADD SP, 6
        MOV AX, 55
        PUSH AX
        CALL FAR PTR ESPERAR
        ADD SP, 2
        MOV AX, DS:[segundos]
        SUB AX, 55
        MOV DS:[segundos], AX
        JMP FBUCLE1
PMOV:   MOV AH, 0
        INT 16H    ; Hay que hacerlo as¡ ya que si no, el buffer no se vac¡a
        CMP AH, 1
        JNE ESPACIO
        JMP FIN
ESPACIO:CMP AH, 57
        JE PRPULS
        JMP FBUCLE1 ; Si no se ha pulsado espacio ni escape, se ignora
        
PRPULS: MOV AL, DS:[prim_puls]
        CMP AL, 0
        JE PONE1
        MOV DS:[prim_puls], 0 ; Si estaba a 1, es que se ha pulsado para parar
        JMP FBUCLE1
PONE1:  MOV DS:[prim_puls], 1 ; Se pone a 1 prim_puls y se empieza a mover
MOVER:  MOV AH,DS:[bol_x]
        MOV AL,DS:[bol_y]
        PUSH AX
        MOV AH,DS:[curs_x]
        MOV AL,DS:[curs_y]
        PUSH AX
        MOV AH,DS:[asp_x]
        MOV AL,DS:[asp_y]
        PUSH AX
        CALL FAR PTR MOVASP
        ADD SP, 6
        MOV AX, 55
        PUSH AX
        CALL FAR PTR ESPERAR
        ADD SP, 2
        MOV AX, DS:[segundos]
        SUB AX, 55
        MOV DS:[segundos], AX
COLIS:  MOV AH, DS:[bol_x]
        MOV AL, DS:[bol_y]
        MOV BH, DS:[asp_x]
        MOV BL, DS:[asp_y]
        CMP AH, BH
        JE COLISY
        JMP COLISXT
COLISY: CMP AL, BL
        JNE COLISXT
        JMP NEWBOL
COLISXT:MOV AL, DS:[bolasx]          ;Esto se modificara
        CMP AL, 1
        JE COLX1
        JMP FBUCLE1
COLX1:  MOV AH, DS:[bol1_x]
        MOV AL, DS:[bol1_y]
        CMP AH, BH
        JE COLY1                ;Hace falta modificar los aleatorios para que
        JMP COLX2               ;no sean iguales y controlar que cuando todos
COLY1:  CMP AL, BL              ;valgan 0, bolasx valga 0.
        JNE COLX2
        MOV DS:[bol1_x], 0
        MOV DS:[bol1_y], 0
        JMP MASPUNT
COLX2:  MOV AH, DS:[bol2_x]
        MOV AL, DS:[bol2_y]
        CMP AH, BH
        JE COLY2
        JMP COLX3
COLY2:  CMP AL, BL
        JNE COLX3
        MOV DS:[bol2_x], 0
        MOV DS:[bol2_y], 0
        JMP MASPUNT
COLX3:  MOV AH, DS:[bol3_x]
        MOV AL, DS:[bol3_y]
        CMP AH, BH
        JE COLY3
        JMP COLX4
COLY3:  CMP AL, BL
        JNE COLX4
        MOV DS:[bol3_x], 0
        MOV DS:[bol3_y], 0
        JMP MASPUNT
COLX4:  MOV AH, DS:[bol4_x]
        MOV AL, DS:[bol4_y]
        CMP AH, BH
        JE COLY4
        JMP COLX5
COLY4:  CMP AL, BL
        JNE COLX5
        MOV DS:[bol4_x], 0
        MOV DS:[bol4_y], 0
        JMP MASPUNT
COLX5:  MOV AH, DS:[bol5_x]
        MOV AL, DS:[bol5_y]
        CMP AH, BH
        JE COLY5
        JMP FBUCLE1
COLY5:  CMP AL, BL
        JNE IRABAJ
        MOV DS:[bol5_x], 0
        MOV DS:[bol5_y], 0
        JMP MASPUNT
IRABAJ: JMP FBUCLE1

MASPUNT:MOV AL, DS:[bolas]
        INC AL
        MOV DS:[bolas], AL
        JMP ESCPUNT

NEWBOL: MOV AL, DS:[bolas]
        INC AL
        MOV DS:[bolas], AL
        CALL FAR PTR NALEAT ; Generamos nuevas coordenadas
        MOV DS:[bol_x], AH
        MOV DS:[bol_y], AL
        PUSH AX
        MOV DX, (169)
        PUSH DX              ; Se escribe la nueva bola
        CALL FAR PTR PONERCH
        ADD SP, 4
ESCPUNT:MOV DL, 24
        MOV DH, 43
        PUSH DX
        MOV DH, 0
        MOV AH, 0
        MOV AL, DS:[bolas]    ;Escritura de las bolas
        MOV DL, 10
        DIV DL
        MOV DL, AH
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        CMP AL, 0
        JNE D_DECEN
        JMP FBUCLE1
D_DECEN:MOV DH, 42
        MOV DL, 24
        PUSH DX
        MOV DH, 0
        MOV DL, AL
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        JMP FBUCLE1
FBUCLE1:MOV AL, DS:[tiempo]
        CMP AL, 0
        JE NIVEL2
        MOV AX, DS:[segundos]
        CMP AX, 0
        JE TIME
        JMP BUCLE1
TIME:   MOV DS:[segundos], 990
        MOV AL, DS:[tiempo]
        DEC AL
        MOV DS:[tiempo], AL
        MOV DH, 13
        MOV DL, 24
        PUSH DX
        MOV AH, 0 ;AL tiene DS:[tiempo]
        MOV DX, 10
        DIV DL
        CMP AL, 0
        JE D_ESP
        MOV DL,AL
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH ;Escritura del tiempo
        ADD SP, 4
        JMP D_UNID
D_ESP:  MOV DL, (' ')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
D_UNID: MOV DH, 14
        MOV DL, 24
        PUSH DX
        MOV DH, 0
        MOV DL, AH
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        JMP BUCLE1

NIVEL2: MOV DS:[nivel], 0
        MOV DS:[ticks], 0
        MOV DS:[contp], 0    ;As¡ se evita que una pulsaci¢n de antes
        MOV DS:[click], 0    ;tenga lugar aqu¡
        MOV DS:[prim_puls], 0
        ADD SP, 2
        CALL FAR PTR BORRAR
        MOV DH, 12
        MOV DL, 30    ;Sit£a el cursor en (30, 12)
        MOV BX, 0
        MOV AH, 2
        INT 10H
        LEA DX, DS:[sig_niv]    
        MOV AH, 9            ;Escribe la cadena almacenada en sig_niv
        INT 21H
        MOV AX, 2000
        PUSH AX
        CALL FAR PTR ESPERAR
        ADD SP, 2
        LEA DI, DS:[pant2] ;Offset de pant2
        LEA SI, DS:[pant]
        MOV BX, 0
        PUSH DI
COPIAR: CMP BX, MAX_PANT
        JE CAJALEAT
        MOV CL, DS:[DI+BX]
        MOV DS:[SI+BX], CL  ;Se copia pant2 en pant1
        INC BX
        JMP COPIAR
CAJALEAT:MOV AH, 0
        MOV AL, 1
SUSTCAJ:CMP AL, 5
        JE CONT2
        PUSH AX
        CALL FAR PTR B_CAJA
        ADD SP, 2
        LEA DX, DS:[pant]
        PUSH DX                ;Actualizaci¢n de las cajas
        PUSH AX
        CALL FAR PTR D_CAJA
        ADD SP, 4
        INC AL
        JMP SUSTCAJ
CONT2:  CALL FAR PTR DIBUJAR
        MOV AX, 2000
        PUSH AX
        CALL FAR PTR ESPERAR
        ADD SP, 2
        MOV AH, 40
        MOV AL, 22
        MOV DS:[asp_x], AH
        MOV DS:[asp_y], AL ;Nuevas coordenadas de la aspiradora
        PUSH AX
        MOV AX, ('o')
        PUSH AX
        CALL FAR PTR PONERCH   ;Dibujo de la aspiradora
        ADD SP, 4
        MOV AH, 41
        MOV AL, 21
        MOV DS:[curs_x], AH
        MOV DS:[curs_y], AL ;Nuevas coordenadas del cursor
        MOV DS:[acurs_x], AH
        MOV DS:[acurs_y], AL ;Cursor auxiliar
        MOV DS:[bol_x], 40
        MOV DS:[bol_y], 22 ;La bola ahora est  dentro de la aspiradora
ESC_BOL:MOV DL, 24
        MOV DH, 43
        PUSH DX
        MOV DH, 0
        MOV AH, 0
        MOV AL, DS:[bolas]
        MOV DL, 10              ;Escritura de las bolas
        DIV DL
        MOV DL, AH
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        CMP AL, 0
        JNE D_DEC2
        MOV DS:[nivel], 2
        JMP VACBUFF
D_DEC2: MOV DH, 42
        MOV DL, 24
        PUSH DX
        MOV DH, 0
        MOV DL, AL
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        MOV DS:[nivel], 2
        JMP VACBUFF ; Escribe las bolas, la aspiradora, etc.

VACBUFF:MOV AH, 1
        INT 16H
        JNZ C_TCLA
        JMP FBUCLE2
C_TCLA: MOV AH, 0
        INT 16H
        JMP VACBUFF

BUCLE2: MOV AL, DS:[bolas]
        CMP AL, 0
        JNE TECLAS
        JMP ADIOS
TECLAS: MOV AH,1  ;¨Se ha pulsado alguna tecla?
        INT 16H
        JZ  BUCLE2 ; Si no, vuelve a preguntarse
        MOV AH, 0
        INT 16H    ;Obtencion de la tecla
        CMP AH, 75
        JNE ES_DER
IZDA:   MOV AH, DS:[asp_x]
        CMP AH, 2
        JNE SIZDA
        JMP BUCLE2     ;No avanza m s si est  en el l¡mite
SIZDA:  DEC AH
        MOV DS:[asp_x], AH
        MOV AL, DS:[curs_x]
        DEC AL
        MOV DS:[curs_x], AL
        JMP FBUCLE2
ES_DER: CMP AH, 77
        JNE ES_Z
DCHA:   MOV AH, DS:[asp_x]
        CMP AH, MAX_COL-3
        JNE SDCHA
        JMP BUCLE2     ;No avanza m s si est  en el l¡mite
SDCHA:  INC AH
        MOV DS:[asp_x], AH
        MOV AL, DS:[curs_x]
        INC AL
        MOV DS:[curs_x], AL
        JMP FBUCLE2
ES_Z:   CMP AH, 44
        JNE ES_X
ZETA:   MOV AH, DS:[curs_x]
        MOV AL, DS:[asp_x]
        DEC AL
        CMP AH, AL
        JNE SZETA
        JMP BUCLE2     ;No avanza m s si est  en el l¡mite
SZETA:  SUB AH,2       ;Para que nunca est‚ en el centro el cursor
        MOV DS:[curs_x], AH
        JMP FBUCLE2
ES_X:   CMP AH, 45
        JNE ES_ESP
EQUIS:  MOV AH, DS:[curs_x]
        MOV AL, DS:[asp_x]
        INC AL
        CMP AH, AL
        JNE SEQUIS
        JMP BUCLE2     ;No avanza m s si est  en el l¡mite
SEQUIS: ADD AH,2
        MOV DS:[curs_x], AH
        JMP FBUCLE2
ES_ESP: CMP AH, 57
        JNE ES_ESC
        MOV DS:[prim_puls], 1   ;Advierte que la bola ha sido lanzada
        JMP LANZAM
ES_ESC: CMP AH, 1
        JE FINALIZ
        JMP TECLAS  
FINALIZ:JMP FIN
LANZAM:MOV AL, DS:[botes]
        CMP AL, 0
        JNE RLANZAM
        JMP FLANZAM
RLANZAM:MOV AL, DS:[canasta]
        CMP AL, 1
        JE FLANZAM
        LEA DX, DS:[rebote]
        PUSH DX
        MOV AH, DS:[curs_x]
        MOV AL, DS:[curs_y]
        PUSH AX
        MOV AH, DS:[bol_x]
        MOV AL, DS:[bol_y]
        PUSH AX
        CALL FAR PTR MOVBOL
        ADD SP, 6
        CALL FAR PTR DIBUJAR
        LEA DX, DS:[canasta]
        PUSH DX
        LEA DX, DS:[punt]
        PUSH DX
        LEA DX, DS:[t_caja]
        PUSH DX
        MOV AH, DS:[bol_x]
        MOV AL, DS:[bol_y]
        PUSH AX ; AX tiene las coordenadas de las bolas ya actualizadas
        CALL FAR PTR ENCESTA
        ADD SP, 8
        MOV AX, 55
        PUSH AX
        CALL FAR PTR ESPERAR
        ADD SP, 2
        MOV AL, DS:[rebote]
        CMP AL, 0
        JNE MNSBTS
        JMP LANZAM
MNSBTS: MOV AH, DS:[botes]
        DEC AH
        MOV DS:[botes], AH
        MOV DS:[rebote], 0
        JMP LANZAM
FLANZAM:MOV DS:[b_extra], 0
        MOV DS:[prim_puls], 0
        MOV DS:[botes], 5
        MOV AL, DS:[bolas]
        DEC AL
        MOV AH, DS:[b_extra]     ;Si tras "rebotar" se falla, se pierde
        CMP AH, 1                ;otra bola m s.
        JNE SOLUNA
        MOV AH, DS:[canasta]
        CMP AH, 1
        JE SOLUNA
        CMP AL, 0
        JE SOLUNA                ;Para evitar que se produzcan bolas negativas
        DEC AL
SOLUNA: MOV DS:[bolas], AL
        MOV DL, 24
        MOV DH, 43
        PUSH DX
        MOV DH, 0
        MOV AH, 0    ;Escritura de las bolas, AL tiene ya el numero de bolas
        MOV DL, 10
        DIV DL
        MOV DL, AH
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        MOV DH, 42
        MOV DL, 24
        PUSH DX
        CMP AL, 0
        JNE D_DEC3
        MOV DX, (' ')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        JMP REC_ASP
D_DEC3: MOV DH, 0
        MOV DL, AL
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
REC_ASP:MOV AH, DS:[asp_x]
        INC AH
        MOV DS:[curs_x], AH
        MOV AL, DS:[asp_y]       ;La aspiradora y el cursor vuelven a su sitio
        DEC AL
        MOV DS:[curs_y], AL
        MOV AL, DS:[canasta]
        CMP AL, 1
        JE ACTPUNT
        JMP FBUCLE2
ACTPUNT:MOV BL, DS:[punt]
        MOV AX, DS:[puntos]
        MOV BH, 0
        ADD AX, BX
        MOV DS:[puntos], AX
        MOV DH, 18
        MOV DL, 24
        PUSH DX
        MOV AX, DS:[puntos]
        MOV DX, 100
        DIV DL
        CMP AL, 0
        JE D_ESP1
        MOV DL,AL
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH         ;Escritura de los puntos
        ADD SP, 4
        JMP D_DECN2
D_ESP1: MOV DL, (' ')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
D_DECN2:MOV DH, 19
        MOV DL, 24
        PUSH DX
        CMP AL, 1
        JE CIEN   ; Para que no se escriba un espacio si los puntos superaban los cien
        MOV DX, 10
        MOV AL, AH
        MOV AH, 0
        DIV DL
        CMP AL, 0
        JE D_ESP2
CIEN:   MOV DL, AL
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        JMP D_UND2
D_ESP2: MOV DL, (' ')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
D_UND2: MOV DH,20
        MOV DL,24
        PUSH DX
        MOV DH, 0
        MOV DL, AH
        ADD DL, ('0')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4

FBUCLE2:MOV AH,DS:[bol_x]
        MOV AL,DS:[bol_y]
        PUSH AX
        MOV AX,(' ')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4
        MOV BH,DS:[asp_x]         ;Actualizacion del movimiento
        MOV BL,DS:[asp_y]
        PUSH BX
        MOV AX, ('o')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4
        MOV AH, DS:[acurs_x]
        MOV AL, DS:[acurs_y]
        PUSH AX
        MOV AX, (' ')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP,4
        MOV DS:[bol_x], BH
        MOV DS:[bol_y], BL
        MOV BL, DS:[curs_y]
        MOV BH, DS:[curs_x]  ;Actualiza el cursor
        PUSH BX
        MOV DX, ('_')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        MOV DS:[acurs_x],BH
        MOV DS:[acurs_y],BL
        MOV AH, DS:[canasta]
        CMP AH, 1
        JNE VOLVB2
ACTCAJA:MOV AH, 0
        MOV AL, DS:[t_caja]
        PUSH AX
        CALL FAR PTR B_CAJA
        ADD SP, 2
        LEA DX, DS:[pant]
        PUSH DX                ;Actualizaci¢n de las cajas
        MOV AH, 0
        MOV AL, DS:[t_caja]
        PUSH AX
        CALL FAR PTR D_CAJA
        ADD SP, 4
        MOV DS:[canasta], 0
VOLVB2: CALL FAR PTR DIBUJAR
        JMP BUCLE2
ADIOS:  CALL FAR PTR BORRAR
        MOV DH, 10    ;Muestra las cadenas de despedida
        MOV DL, 20
        MOV AH, 2
        MOV BX, 0
        INT 10H
        LEA DX, DS:[cierre]
        MOV AH, 9
        INT 21H
        MOV AX, 2000
        PUSH AX
        CALL FAR PTR ESPERAR
        ADD SP, 2
FIN:    MOV DS:[nivel], 0
        ADD SP, 2
        MOV CH,00001011b
        MOV CL,00001100b      
        MOV AH, 1     ; Volver a mostrar el cursor
        INT 10H
        CALL FAR PTR BORRAR
        MOV DX, 21H
        IN AL, DX
        OR AL, 10000000B
        OUT DX, AL
        MOV DX, 37AH
        IN AL, DX
        AND AL, 11101111b
        OUT DX, AL
        MOV AX, WORD PTR DS:[rti_pr2]       ;Recuperacion de las rutinas anteriores
        MOV DX, WORD PTR DS:[rti_pr2+2]
        CLI
        MOV WORD PTR ES:[15*4], AX
        MOV WORD PTR ES:[15*4+2], DX
        STI
        MOV AX, WORD PTR DS:[rti_pr]
        MOV DX, WORD PTR DS:[rti_pr+2]
        CLI
        MOV WORD PTR ES:[28*4], AX
        MOV WORD PTR ES:[28*4+2], DX
        STI
        MOV AX, 4C00H
        INT 21H    ;Devuelve el control al DOS y termina el programa.

rti_puls PROC FAR
       PUSH AX
       PUSH BX
       PUSH CX
       PUSH DX
       PUSH ES
       PUSH DS
       PUSH SI
       PUSH DI
       MOV AX, DATOS
       MOV DS, AX
       MOV AL, DS:[nivel]
       CMP AL, 0
       JE EOI
       MOV AL, DS:[click]
       CMP AL, 2
       JNE PROSEG
       JMP EOI
PROSEG:CMP AL, 0
       JNE MASCONT
       MOV DS:[click], 1
       MOV DS:[contp], 1
       JMP EOI
MASCONT:MOV AH, DS:[contp]
       INC AH
       MOV DS:[contp], AH
EOI:   MOV AL, 20H
       OUT 20H, AL   ;EndOfInterruption
       POP DI
       POP SI
       POP DS
       POP ES
       POP DX
       POP CX
       POP BX
       POP AX
       IRET
rti_puls ENDP

rti_time PROC FAR
       PUSH AX
       PUSH BX
       PUSH CX
       PUSH DX
       PUSH DS
       PUSH ES
       PUSH SI
       PUSH DI
       MOV AX, DATOS
       MOV DS, AX
       MOV AL, DS:[click]
       CMP AL, 2
       JNE NEXTT
       MOV AL, DS:[contp]
       CMP AL, 0
       JE PONCRO
       DEC AL
       MOV DS:[contp], AL
       JMP FINN
PONCRO:MOV DS:[click], 0
       JMP FINN
NEXTT: CMP AL, 1
       JE HAYPULS
       JMP FINN
HAYPULS:MOV AX, 40H
       MOV ES, AX
       MOV AX, ES:[6CH]
       MOV CX, DS:[ticks]
       CMP CX, 0
       JNE ESHORA
       ADD AX, 5
       MOV DS:[ticks], AX
       JMP FINN
ESHORA:CMP CX, AX
       JE ACCION
       JMP FINN

ACCION:MOV DS:[ticks], 0
       MOV AL, DS:[contp]
       CMP AL, 5
       JBE UNCLIC
       JMP DOBLEC

UNCLIC:MOV DS:[click],0
       MOV DS:[contp],0
       MOV AL, DS:[nivel]
       CMP AL,1
       JE TTRANS

HLANZAM:MOV AL, DS:[prim_puls]
        CMP AL, 1
        JE HAYMOV    ;Esto solo tiene sentido si se est  en un lanzamiento
        JMP FINN
HAYMOV: MOV AL, DS:[b_extra]
        CMP AL, 1
        JNE SEGUIR   ;No se puede hacer dos veces en un solo lanzamiento
        JMP FINN
SEGUIR: LEA DX, DS:[pant2]
        PUSH DX
        MOV AL, DS:[botes]
        ADD AL, 5
        MOV DS:[botes], AL
        MOV DS:[b_extra], 1
        MOV AL, DS:[curs_x]
        MOV AH, DS:[bol_x]
        INC AL
        CMP AH, AL
        JE DERCH ; Si ya estaba avanzando a la izquierda, se mueve a la derecha
        DEC AL
        CMP AL, 3
        JBE NOIZQ  ;Para que no sobrepase los limites
        SUB AL, 2
        MOV DS:[curs_x], AL
NOIZQ:  POP DX
        JMP FINN
DERCH:  DEC AL
        CMP AL, MAX_COL-3
        JAE NODER
        ADD AL, 2
        MOV DS:[curs_x], AL
NODER:  POP DX
        JMP FINN

TTRANS: LEA DX, DS:[pant]
        PUSH DX
        MOV AH, DS:[curs_x]
        MOV AL, DS:[curs_y]
        PUSH AX
        MOV DX, (' ')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4              ;Se borran la bola y el cursor
        MOV AH, DS:[asp_x]
        MOV AL, DS:[asp_y]
        PUSH AX
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        CALL FAR PTR NALEAT
        MOV DS:[asp_x], AH
        MOV DS:[asp_y], AL   
        MOV DS:[curs_x], AH
        CMP AL, 2
        JBE BAJAR
        DEC AL                   ;Hay que comprobar que no de en el techo
        MOV DS:[curs_y], AL
        JMP D_CAMB
BAJAR:  INC AL
        MOV DS:[curs_y], AL
D_CAMB: PUSH AX
        MOV DX, ('*')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        MOV AH, DS:[asp_x]        ;Se dibujan en sus nuevas posiciones
        MOV AL, DS:[asp_y]
        PUSH AX
        MOV DX, ('o')
        PUSH DX
        CALL FAR PTR PONERCH
        ADD SP, 4
        POP DX
        JMP FINN

DOBLEC: MOV DS:[click],2
        MOV DS:[contp], 2
        MOV AL, DS:[nivel]
        CMP AL, 2
        JE REESTAB
        JMP CINCBL

REESTAB:MOV AL, DS:[bolas]
        CMP AL, 1
        JNE SPUEDE    ;No se pueden reducir m s si solo queda una bola
        JMP FINN
SPUEDE: DEC AL
        MOV DS:[bolas], AL
        LEA SI, DS:[pant2] ;Offset de pant2
        LEA DI, DS:[pant]
        PUSH SI
        MOV BX, 0
COPIAR2:CMP BX, MAX_PANT-400 ; No hace falta sobreescribir por debajo de las cajas
        JE PONVARS
        MOV CL, DS:[DI+BX]
        MOV DS:[SI+BX], CL  ;Se copia pant2 en pant1
        INC BX
        JMP COPIAR2
PONVARS:MOV DS:[c5_x], CO5_X
        MOV DS:[c5_y], CO5_Y
        MOV DS:[c10_x], CO10_X
        MOV DS:[c10_y], CO10_Y
        MOV DS:[c25_1_X], CO25_1_X
        MOV DS:[c25_2_X], CO25_2_X
        MOV DS:[c25_y], CO25_Y
        CALL FAR PTR DIBUJAR
        POP SI
        JMP FINN

CINCBL: LEA DX, DS:[pant]
        PUSH DX
        MOV AL, DS:[tiempo]
        CMP AL, 10
        JA ANADIR
        POP DX
        JMP FINN  ; Si el tiempo es 10 o menos, no se puede hacer
ANADIR: MOV DS:[segundos], 55
        SUB AL, 9
        MOV DS:[tiempo], AL
        MOV DS:[bolasx], 1
BORR1:  MOV AH, DS:[bol1_x]
        MOV AL, DS:[bol1_y]
        CMP AX, 0
        JE BORR2
        PUSH AX
        MOV AX, (' ')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4
BORR2:  MOV AH, DS:[bol2_x]
        MOV AL, DS:[bol2_y]
        CMP AX, 0
        JE BORR3
        PUSH AX
        MOV AX, (' ')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4
BORR3:  MOV AH, DS:[bol3_x]
        MOV AL, DS:[bol3_y]
        CMP AX, 0
        JE BORR4
        PUSH AX
        MOV AX, (' ')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4
BORR4:  MOV AH, DS:[bol4_x]
        MOV AL, DS:[bol4_y]
        CMP AX, 0
        JE BORR5
        PUSH AX
        MOV AX, (' ')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4
BORR5:  MOV AH, DS:[bol5_x]
        MOV AL, DS:[bol5_y]
        CMP AX, 0
        JE GEN_B
        PUSH AX
        MOV AX, (' ')
        PUSH AX
        CALL FAR PTR PONERCH
        ADD SP, 4
GEN_B:  CALL FAR PTR NALEAT ; Generamos nuevas coordenadas
        MOV DS:[bol1_x], AH
        MOV DS:[bol1_y], AL
        PUSH AX
        MOV DX, (169)
        PUSH DX              ; Se escribe la nueva bola
        CALL FAR PTR PONERCH
        ADD SP, 4
        CALL FAR PTR NALEAT ; Generamos nuevas coordenadas
        MOV BX, AX
        MOV AH, 0
        MOV AL, BH
        ADD AL, 100
        MOV CL, 78
        DIV CL
        MOV BH, AH
        MOV AH, 0           ;Se hace esto para "espaciar" las bolas
        MOV BL, AL
        MOV CL, 50
        MUL CL
        ADD AX, 7
        MOV CL, 22
        MOV AH, 0
        DIV CL
        MOV BL, AH
        ADD BX, 0101H
        MOV DS:[bol2_x], BH
        MOV DS:[bol2_y], BL
        PUSH BX
        MOV DX, (169)
        PUSH DX              ; Se escribe la nueva bola
        CALL FAR PTR PONERCH
        ADD SP, 4
        CALL FAR PTR NALEAT ; Generamos nuevas coordenadas
        MOV BX, AX
        MOV AL, BH
        SUB AL, 83
        MOV AH, 0      ;Por si el resultado es negativo
        MOV CL, 78
        DIV CL
        MOV BH, AH
        MOV AH, 0           ;Se hace esto para "espaciar" las bolas
        MOV BL, AL
        MOV CL, 32
        MUL CL
        ADD AX, 56
        MOV AH, 0
        MOV CL, 22
        DIV CL
        MOV BL, AH
        ADD BX, 0101H
        MOV DS:[bol3_x], BH
        MOV DS:[bol3_y], BL
        PUSH BX
        MOV DX, (169)
        PUSH DX              ; Se escribe la nueva bola
        CALL FAR PTR PONERCH
        ADD SP, 4
        CALL FAR PTR NALEAT ; Generamos nuevas coordenadas
        MOV BX, AX
        MOV AL, BH
        ADD AL, 33
        MOV AH, 0      ;Por si el resultado es negativo
        MOV CL, 78
        DIV CL
        MOV BH, AH
        MOV AH, 0           ;Se hace esto para "espaciar" las bolas
        MOV BL, AL
        MOV CL, 17
        MUL CL
        ADD AX, 5
        MOV AH, 0
        MOV CL, 22
        DIV CL
        MOV BL, AH
        ADD BX, 0101H
        MOV DS:[bol4_x], BH
        MOV DS:[bol4_y], BL
        PUSH BX
        MOV DX, (169)
        PUSH DX              ; Se escribe la nueva bola
        CALL FAR PTR PONERCH
        ADD SP, 4
        CALL FAR PTR NALEAT ; Generamos nuevas coordenadas
        MOV BX, AX
        MOV AL, BH
        ADD AL, 33
        MOV AH, 0      ;Por si el resultado es negativo
        MOV CL, 78
        DIV CL
        MOV BH, AH
        MOV AH, 0           ;Se hace esto para "espaciar" las bolas
        MOV BL, AL
        MOV CL, 52
        MUL CL
        SUB AX, 100
        MOV AH, 0
        MOV CL, 22
        DIV CL
        MOV BL, AH
        ADD BX, 0101H
        MOV DS:[bol5_x], BH
        MOV DS:[bol5_y], BL
        PUSH BX
        MOV DX, (169)
        PUSH DX              ; Se escribe la nueva bola
        CALL FAR PTR PONERCH
        ADD SP, 4
        POP DX

FINN:  MOV AL, 20H
       OUT 20H, AL
       POP DI
       POP SI
       POP ES
       POP DS
       POP DX
       POP CX
       POP BX
       POP AX
       IRET
rti_time ENDP


CODIGO ENDS
END INICIO
