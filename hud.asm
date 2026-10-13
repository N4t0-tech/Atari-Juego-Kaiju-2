; hud.asm - HUD al estilo de Kaiju (ANTIC 4, fuente de Kaiju): fila 0 para
; J1 y fila 24 (HUD2) para J2, cada una solo si ese jugador entro a la partida
;
;   columnas 0-9    energia del jugador: un icono ($06,$07) por punto (hasta 5)
;   columnas 11-28  (fila 0) una barra ($34) por celula que falta recoger,
;                   centrada en la pantalla
;   columnas 29-38  puntos del jugador: 10 digitos ($0A + digito); los 4
;                   primeros son 0 y los 6 ultimos salen de puntos (BCD)
; Se dibuja de las copias de jug_datos.

dibujar_hud
        lda #0
        sta hud_dirty
        ldy #39
hud_clr sta PANTALLA,y
        sta HUD2,y
        dey
        bpl hud_clr
        lda #40         ; barra de celulas (compartidas), centrada:
        sec             ; desde la columna (40 - celrest) / 2
        sbc celrest
        lsr
        tay
        ldx celrest
hud_ba2 cpx #0
        beq hud_j
        lda #$34
        sta PANTALLA,y
        iny
        dex
        jmp hud_ba2
hud_j   lda #<PANTALLA
        sta ptr2
        lda #>PANTALLA
        sta ptr2+1
        ldx #0
        lda unido_j
        beq hud_j2
        jsr hud_jugador
hud_j2  lda unido_j+1
        beq hud_fin
        lda #<HUD2
        sta ptr2
        lda #>HUD2
        sta ptr2+1
        ldx #JUG_TAM
        ; sigue en hud_jugador

; energia y puntos del jugador X (0 o JUG_TAM, su copia) en la fila ptr2
hud_jugador
        lda jug_datos+J_ENERGIA,x
        sta tmp3
        ldy #0
hud_en  lda tmp3
        beq hud_pt
        lda #$06
        sta (ptr2),y
        iny
        lda #$07
        sta (ptr2),y
        iny
        dec tmp3
        jmp hud_en
hud_pt  ldy #29
        lda #$0A
hud_p0  sta (ptr2),y
        iny
        cpy #33
        bne hud_p0
hud_dig lda jug_datos+J_PUNTOS,x
        lsr
        lsr
        lsr
        lsr
        clc
        adc #$0A
        sta (ptr2),y
        iny
        lda jug_datos+J_PUNTOS,x
        and #$0F
        clc
        adc #$0A
        sta (ptr2),y
        iny
        inx
        cpy #39
        bcc hud_dig
hud_fin rts

; suma a puntos+X (del jugador activo) el digito BCD de A ($01-$09 o $10-$90: un solo digito no
; nulo), con acarreo decimal hacia los digitos de mas peso, y pide redibujar
; el HUD. +1: X=2 A=$01; +10: X=2 A=$10; +100: X=1 A=$01. Sin modo decimal
; (SED), para no depender de las interrupciones del OS. Conserva Y.
; 999999 + 1 vuelve a 000000.
sumar_bcd
sp_byte clc
        adc puntos,x
        sta puntos,x
        and #$0F        ; digito bajo > 9?
        cmp #$0A
        bcc sp_alto
        lda puntos,x
        adc #$05        ; C = 1: +6 corrige el digito y lleva 1 al alto
        sta puntos,x
sp_alto lda puntos,x
        cmp #$A0        ; digito alto > 9?
        bcc sp_fin
        sbc #$A0        ; C = 1
        sta puntos,x
        lda #$01        ; acarreo al digito bajo del byte siguiente
        dex
        bpl sp_byte
sp_fin  lda #1
        sta hud_dirty
        rts

; solo redibuja si algo cambio (puntos, energia o celulas ponen hud_dirty=1)
actualizar_hud
        lda hud_dirty
        beq ah_fin
        jsr dibujar_hud
ah_fin  rts
