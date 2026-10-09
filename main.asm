; main.asm - punto de entrada y ciclo principal
; Ensamblar: mads main.asm -o:juego.xex
; Version debug (selector de nivel en el titulo):
;            mads main.asm -d:DEBUG=1 -o:juego-debug.xex
;
; Archivos del proyecto (todos en la misma carpeta):
;   hardware.asm  direcciones del Atari
;   jugador.asm   movimiento, animacion y dibujo del jugador
;   bala.asm      disparo y bala (missiles 0+1)
;   sonido.asm    efectos de sonido
;   hud.asm       HUD de Kaiju: energia, celulas que faltan y puntos
;   nivel.asm     pantallas, carga del nivel y choques con los bloques
;   enemigos.asm  robots enemigos, contactos con el jugador
;   balaenemiga.asm  tiradores: disparos de los robots (players 2 y 3)
;   celulas.asm   celulas (objetos a recoger)
;   partes.asm    niveles de varias partes (pantallas)
;   etapas.asm    titulo, etapas y mensajes
;   datos.asm     variables y graficos del sprite
;   kaiju_*.asm   recursos de Kaiju (graficos, titulo); kaiju_titulo.asm
;                 ocupa $6000-$7EAF
;   niveles.asm   niveles: mapas, robots y celulas (editor-sprite.html), en
;                 su propio bloque desde $9100 (ver apagar_basic)

        .ifndef DEBUG
DEBUG   = 0             ; 1 = selector de nivel en el titulo (mads -d:DEBUG=1)
        .endif

        icl "hardware.asm"

; --- se ejecuta apenas se carga (INI), antes que el resto del juego: apaga el
; BASIC de los XL/XE (8 KB en $A000-$BFFF) para poder cargar los niveles ahi,
; y reabre la pantalla del OS (E:) para que se mude arriba de todo ($BC20) y
; no quede donde van los niveles. En un 400/800 no hace falta y no molesta.
        org PMG         ; zona de los sprites: el juego la borra despues
apagar_basic
        lda PORTB
        ora #2
        sta PORTB
        lda #1
        sta BASICF
        lda #$C0
        sta RAMTOP
        ldx #0          ; IOCB 0 = E:, cerrar y volver a abrir
        lda #12         ; CLOSE
        sta ICCOM
        jsr CIOV
        ldx #0
        lda #3          ; OPEN
        sta ICCOM
        lda #<nombre_e
        sta ICBAL
        lda #>nombre_e
        sta ICBAH
        lda #12         ; lectura y escritura
        sta ICAX1
        lda #0
        sta ICAX2
        jmp CIOV
nombre_e .byte 'E:',$9B
        ini apagar_basic

        org $2000

start
        jsr iniciar

partida
        jsr titulo
        jsr nueva_partida
etapa_sig
        jsr pantalla_level
        jsr cargar_etapa

loop
        jsr esperar_paso
        jsr mover_jugador
        jsr ver_salida          ; paso a otra parte del nivel
        jsr animar_jugador
        jsr dibujar_jugador
        jsr actualizar_bala
        jsr actualizar_enemigos
        jsr actualizar_balas_enemigas
        jsr dibujar_celulas
        jsr contactos
        jsr actualizar_sonido
        jsr actualizar_hud
        lda energia
        beq perdio
        lda fin
        bne fallo
        lda celrest
        bne loop
        ; nivel superado
        inc etapa
        lda etapa
        cmp #NUM_NIVELES
        bne etapa_sig
        lda #<kaiju_txt_super
        ldx #>kaiju_txt_super
        ldy #10
        jsr mensaje
        jmp partida
fallo   ; se disparo a una celula: -1 de energia y se repite el nivel
        dec energia
        beq perdio
        lda #<kaiju_txt_tryagain
        ldx #>kaiju_txt_tryagain
        ldy #15
        jsr mensaje
        jmp etapa_sig
perdio  lda #<kaiju_txt_gameover
        ldx #>kaiju_txt_gameover
        ldy #15
        jsr mensaje
        jmp partida

; espera FRAMES_PASO frames: un paso del juego. El original (cc65) no llegaba
; a dar una vuelta por frame, asi que todo iba a la mitad de velocidad
esperar_paso
        ldx #FRAMES_PASO
ep_fr   jsr esperar_frame
        dex
        bne ep_fr
        inc npaso
        rts

; espera al siguiente frame (sincroniza el juego a 50/60 cuadros por segundo)
esperar_frame
        lda RTCLOK
wait    cmp RTCLOK
        beq wait
        rts

; configura sprites, colores y pantallas (una sola vez)
iniciar
        jsr limpiar_pmg
        jsr iniciar_pantalla
        lda #>PMG
        sta PMBASE
        lda #$3E        ; DMA de jugadores y missiles (1 linea) y de pantalla
        sta SDMCTL
        lda #3
        sta GRACTL
        lda #KAIJU_PCOLR0
        sta PCOLR0      ; cuerpo del robot (kaiju_graficos.asm)
        lda #KAIJU_PCOLR1
        sta PCOLR1      ; contorno del robot
        lda #$31        ; bit 4: missiles con su propio color (COLOR3);
        sta GPRIOR      ; bit 5: P0+P1 se mezclan (3er color del robot)
        lda #$26        ; COLOR3: bala y enemigos (caracteres inversos)
        sta COLOR3
        lda #0          ; fondo negro (COLOR4: fondo y borde en ANTIC 4/E)
        sta COLOR4
        sta HPOSP2      ; P2 y P3: balas de los tiradores
        sta HPOSP3
        lda #$44
        sta PCOLR2      ; color de las balas enemigas
        sta PCOLR3
        rts

        icl "jugador.asm"
        icl "bala.asm"
        icl "sonido.asm"
        icl "hud.asm"
        icl "nivel.asm"
        icl "enemigos.asm"
        icl "balaenemiga.asm"
        icl "celulas.asm"
        icl "partes.asm"
        icl "etapas.asm"
        icl "datos.asm"

        icl "kaiju_graficos.asm"

        ; RAM para las partes del nivel descomprimidas (no va en el .xex)
MAPAS   = *
        .if MAPAS + MAXPARTES*920 > $6000
        .error "No entran los MAPAS de las partes antes de $6000"
        .endif

        ; el titulo se carga en $6000 y $7000 (bloques de 4 KB para ANTIC)
        .if * > $6000
        .error "El programa pasa de $6000: no cabe antes de la imagen de titulo"
        .endif
        icl "kaiju_titulo.asm"

        ; el programa no puede pisar la memoria de los sprites
        .if * > PMG
        .error "El programa pasa de PMG: mover PMG mas arriba en hardware.asm"
        .endif

        ; los niveles, en su propio bloque (RAM del BASIC, ver apagar_basic)
        org ZONA_NIVELES
        icl "niveles.asm"       ; generado con editor-sprite.html (panel Niveles)

        .if NUM_NIVELES < 1 || NUM_NIVELES > 99
        .error "NUM_NIVELES tiene que estar entre 1 y 99"
        .endif
        .if * > ZONA_NIVELES_FIN
        .error "Los niveles no entran: pasan de ZONA_NIVELES_FIN ($BC00)"
        .endif

        run start
