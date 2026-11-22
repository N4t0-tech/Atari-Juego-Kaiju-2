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

; animacion de muerte en single player: se le corta la cabeza y cae al suelo.
; Solo cuando un unico jugador entro a la partida
muerte_cabeza
        lda unido_j
        eor unido_j+1
        cmp #1
        bne mc_fin
        ldx #0          ; cargar el jugador que sigue en la partida
        lda unido_j
        bne mc_j
        inx
mc_j    txa
        jsr cargar_jugador
        jsr limpiar_pmg
        jsr mc_preparar         ; ptr/ptr4 = pose, ptr3/ptr5 = PMG, HPOS
        lda #0
        sta ecuenta
mc_paso jsr mc_borrar_pmg       ; limpia sprite del jugador
        jsr mc_cuerpo           ; cuerpo sin cabeza
        jsr mc_cabeza           ; cabeza cayendo
        jsr mc_nota             ; nota menor descendente
        jsr esperar_paso
        inc ecuenta
        lda ecuenta
        cmp #32
        bne mc_paso
        lda #0                  ; silencio
        sta AUDC1
        sta sndtim
        lda #16                 ; pausa con la cabeza en el suelo
        sta tmp3
mc_pausa jsr esperar_paso
        dec tmp3
        bne mc_pausa
        jsr limpiar_pmg
mc_fin  rts

; prepara punteros de pose y PMG del jugador activo
mc_preparar
        ldx pose
        lda poses_lo,x
        sec
        sbc #4
        sta ptr
        lda poses_hi,x
        sbc #0
        sta ptr+1
        lda ptr
        clc
        adc #24
        sta ptr4
        lda ptr+1
        adc #0
        sta ptr4+1
        jsr pmg_jugador
        lda px                  ; restaurar HPOS (tu_fuera lo puso a 0)
        jmp hpos_jugador

; borra solo las 32 lineas PMG del jugador activo
mc_borrar_pmg
        ldy #31
        lda #0
mc_bp   sta (ptr3),y
        sta (ptr5),y
        dey
        bpl mc_bp
        rts

; cuerpo sin cabeza: filas 14..27 de la pose
mc_cuerpo
        ldy #27
mc_bo   lda (ptr),y
        jsr espejar
        sta (ptr3),y
        lda (ptr4),y
        jsr espejar
        sta (ptr5),y
        dey
        cpy #13
        bne mc_bo
        rts

; cabeza (filas 4..13) desplazada hacia abajo segun mc_dy
mc_cabeza
        ldx ecuenta
        lda mc_dy,x
        sta tmp2
        ldy #13
mc_hd   sty oy_r
        tya
        clc
        adc tmp2                ; destino = y + dy
        cmp #32
        bcs mc_hd_s
        sta ox_r
        ldy oy_r
        lda (ptr),y
        jsr espejar
        ldy ox_r
        sta (ptr3),y
        ldy oy_r
        lda (ptr4),y
        jsr espejar
        ldy ox_r
        sta (ptr5),y
mc_hd_s ldy oy_r
        dey
        cpy #3
        bne mc_hd
        rts

; nota de muerte: 8 notas x 4 pasos, escala menor descendente
mc_nota lda ecuenta
        and #3
        bne mc_nenv
        lda ecuenta
        lsr @
        lsr @
        tax
        lda mc_notas,x
        sta AUDF1
mc_nenv lda ecuenta
        and #3
        eor #3
        clc
        adc #5                  ; volumen 8..5 dentro de cada nota
        ora #$A0                ; tono puro
        sta AUDC1
        rts

; caida al suelo y queda ahi (lineas PMG)
mc_dy   .byte 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,14,14,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14
mc_notas .byte 60,68,76,81,91,102,108,121 ; C5 Bb4 Ab4 G4 F4 Eb4 D4 C4 (menor)

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
