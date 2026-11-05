; animaciones.asm - celula destruida y nivel superado (el juego queda congelado)
;
; Va en la zona de niveles, entre el titulo comprimido y niveles.asm (no corre
; en cada frame y ahi hay lugar): lo que ocupa se descuenta del PRESUPUESTO
; del editor (ver ANTES_NIVELES en main.asm)

; baile de nivel superado (celebrar): pose, espejo y salto (lineas) por tiempo.
; Salto maximo 4: dibujar_jugador solo limpia 4 lineas arriba y abajo
baile_pose   .byte POSE_QUIETO_DER,POSE_CAMINA_A,POSE_QUIETO_IZQ,POSE_CAMINA_A
             .byte POSE_ARRIBA_A,POSE_ARRIBA_A+1,POSE_CAMINA_A+1,POSE_CAMINA_A+1
baile_espejo .byte 0,0,0,$80,0,0,0,$80
baile_salto  .byte 0,2,0,2,0,4,0,4

; la bala toco una celula en bcol/bfil: deja de dibujarse y queda en cel_expl
; para explotar_celula ($FF si no se encuentra)
romper_celula
        ldx #0
rc_cel  cpx ncel
        bcs rc_no
        lda cel_parte,x
        cmp parte
        bne rc_sig
        lda cel_viva,x
        beq rc_sig
        lda bcol        ; bcol en x..x+1 y bfil en y..y+1
        sec
        sbc cel_x,x
        cmp #2
        bcs rc_sig
        lda bfil
        sec
        sbc cel_y,x
        cmp #2
        bcs rc_sig
        lda #0
        sta cel_viva,x
        stx cel_expl
        rts
rc_sig  inx
        jmp rc_cel
rc_no   lda #$FF
        sta cel_expl
        rts

; animacion de la celula destruida (el juego queda congelado): la explosion
; alterna sus 2 fases, el nivel se corrompe, el fondo destella y el ruido se
; repite. No hace falta deshacerlo: mensaje borra la pantalla, modo_texto
; repone los colores y cargar_etapa redibuja el mapa
explotar_celula
        lda #32
        sta ecuenta
ec_paso jsr esperar_paso
        lda ecuenta
        and #7
        bne ec_snd
        lda #SND_EXPLOSION
        jsr sonar
ec_snd  jsr actualizar_sonido
        lda #0          ; destello: fondo naranja/negro la primera mitad
        ldx ecuenta
        cpx #16
        bcc ec_col
        txa
        and #1
        beq ec_col
        lda #$24
ec_col  sta COLOR4
        jsr corromper
        ldx cel_expl
        bmi ec_sig
        jsr dir_celula
        lda ecuenta
        and #4          ; cambia de fase cada 4 pasos
        clc
        adc #EXPLO+$80
        jsr poner2x2
ec_sig  dec ecuenta
        bne ec_paso
        lda #0
        sta COLOR4
        rts

; el nivel se corrompe: (33 - ecuenta) * 2 caracteres al azar en posiciones
; al azar de las filas 1-23 (los HUD no), y a veces los colores tambien
corromper
        lda #33
        sec
        sbc ecuenta
        asl
        sta tmp3
co_fil  lda RANDOM
        and #31
        beq co_fil
        cmp #24
        bcs co_fil
        tay
        lda filas_lo,y
        sta ptr
        lda filas_hi,y
        sta ptr+1
co_col  lda RANDOM
        and #63
        cmp #40
        bcs co_col
        tay
        lda RANDOM
        sta (ptr),y
        dec tmp3
        bne co_fil
        lda RANDOM      ; 1 de cada 4 pasos: colores al azar
        and #3
        bne co_fin
        lda RANDOM
        sta COLOR0
        lda RANDOM
        sta COLOR1
        lda RANDOM
        sta COLOR2
co_fin  rts

; animacion de nivel superado (el juego queda congelado): el nivel se borra
; fila por fila de arriba abajo, los jugadores que siguen vivos bailan
; (baile_*: una pose cada 4 pasos, saltando en algunas) y suena un tono que
; sube. cargar_etapa redibuja el mapa del nivel siguiente
celebrar
        jsr limpiar_pmg ; balas propias y enemigas fuera
        lda #0
        sta ecuenta     ; aqui cuenta hacia arriba: 0..39
ce_paso jsr esperar_paso
        lda ecuenta
        and #7
        bne ce_snd
        lda #SND_VICTORIA
        jsr sonar
ce_snd  jsr actualizar_sonido
        lda #0
ce_jug  jsr cargar_jugador
        lda energia
        beq ce_sigj
        lda ecuenta     ; tiempo del baile = (ecuenta / 4) % 8
        lsr
        lsr
        and #7
        tax
        lda baile_pose,x
        sta pose
        lda baile_espejo,x
        sta espejo
        lda #0
        sta invul       ; que no parpadee mientras baila
        lda py          ; salta desde su altura, que no cambia
        pha
        sec
        sbc baile_salto,x
        sta py
        jsr dibujar_jugador
        pla
        sta py
        jsr guardar_jugador
ce_sigj lda jugador
        bne ce_fila0
        lda #1
        bne ce_jug
ce_fila0 ldy ecuenta    ; pasos 1-23: se borra esa fila
        beq ce_sig
        cpy #24
        bcs ce_sig
        lda filas_lo,y
        sta ptr
        lda filas_hi,y
        sta ptr+1
        lda #0
        ldy #39
ce_fila sta (ptr),y
        dey
        bpl ce_fila
ce_sig  inc ecuenta
        lda ecuenta
        cmp #40
        bne ce_paso
        jmp actualizar_sonido
