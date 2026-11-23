; intro.asm - animacion de inicio (generado con editor-sprite.html, panel Intro)
; Se ejecuta solo al arrancar, antes del titulo. Se puede saltar con el boton.

intro
        jsr limpiar_pantalla
        jsr limpiar_pmg
        jsr modo_juego
        lda #0
        sta jugador
        sta intro_i
in_paso ldx intro_i
        cpx intro_pasos
        bcs in_fin
        ; leer paso: pose,px,py,espejo,espera,snd (6 bytes)
        txa
        asl @
        sta tmp2
        asl @               ; *4
        clc
        adc tmp2            ; *6
        tax
        lda intro_data,x
        sta in_pose
        lda intro_data+1,x
        sta px
        lda intro_data+2,x
        sta py
        lda intro_data+3,x
        sta espejo
        lda intro_data+4,x
        sta in_espera
        lda intro_data+5,x
        sta in_snd

        lda in_pose
        cmp #$FF
        beq in_hide
        jsr in_dibujar
        jmp in_snd_do
in_hide jsr limpiar_pmg
in_snd_do
        lda in_snd
        cmp #$FF
        beq in_wait
        jsr sonar
in_wait lda in_espera
        beq in_next
        sta ecuenta
in_w    jsr esperar_paso
        jsr actualizar_sonido
        lda STRIG0
        and STRIG1
        beq in_fin              ; saltar intro
        dec ecuenta
        bne in_w
in_next inc intro_i
        jmp in_paso
in_fin  lda #0
        sta AUDC1
        sta sndtim
        jsr limpiar_pmg
        rts

; dibuja pose in_pose del jugador 0 en px,py
in_dibujar
        ldx in_pose
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
        lda px
        jsr hpos_jugador
        ldy #31
        lda #0
in_clr  sta (ptr3),y
        sta (ptr5),y
        dey
        bpl in_clr
        ldy #27
in_dr   lda (ptr),y
        jsr espejar
        sta (ptr3),y
        lda (ptr4),y
        jsr espejar
        sta (ptr5),y
        dey
        cpy #3
        bne in_dr
        rts

intro_i     .byte 0
in_pose     .byte 0
in_espera   .byte 0
in_snd      .byte 0

intro_pasos .byte 8
;          pose, px,  py,  esp, espera, snd
intro_data
        .byte 1,   60,  140, 0,   6,  $FF  ; camina A entrando
        .byte 2,   75,  140, 0,   6,  $FF  ; camina B
        .byte 1,   90,  140, 0,   6,  $FF
        .byte 2,   105, 140, 0,   6,  $FF
        .byte 1,   120, 140, 0,   6,  $FF
        .byte 0,   120, 140, 0,   20, 6    ; quieto + SND_VICTORIA
        .byte 3,   120, 136, 0,   8,  $FF  ; arriba A
        .byte 0,   120, 140, 0,   20, $FF  ; quieto final
