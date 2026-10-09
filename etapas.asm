; etapas.asm - flujo de la partida: titulo, «LEVEL n», los NUM_NIVELES
; niveles de niveles.asm (hechos con editor-sprite.html) y los mensajes de fin
;
; Se supera un nivel al recoger todas sus celulas. Disparar a una celula
; cuesta 1 de energia y repite el nivel («TRY AGAIN»); sin energia, «GAME
; OVER». Tras el ultimo, «YOU ARE SUPER PLAYER». La energia y los puntos pasan
; de un nivel al siguiente.

nueva_partida
        lda etapa_ini   ; 0 salvo que se elija otra con el selector DEBUG
        sta etapa
        lda #0
        sta puntos
        sta puntos+1
        sta puntos+2
        lda #5
        sta energia
        rts

; imagen de titulo hasta que se aprieta el boton (hay que soltarlo antes)
titulo
        jsr modo_titulo
        .if DEBUG
        jsr dbg_texto
        .endif
tit_suelta
        jsr esperar_frame
        .if DEBUG
        jsr dbg_selector
        .endif
        lda STRIG0
        beq tit_suelta
tit_espera
        jsr esperar_frame
        .if DEBUG
        jsr dbg_selector
        .endif
        lda STRIG0
        bne tit_espera
        rts

        .if DEBUG
; selector de nivel (solo DEBUG): izquierda/derecha -1/+1, dando la vuelta en
; 0..NUM_NIVELES-1; se mueve una vez por empujon
dbg_selector
        lda STICK0
        and #$0F
        cmp dbg_stick
        beq dbg_fin     ; sin cambios
        sta dbg_stick
        cmp #$07        ; derecha
        bne dbg_izq
        inc etapa_ini
        lda etapa_ini
        cmp #NUM_NIVELES
        bcc dbg_texto
        lda #0
        sta etapa_ini
        beq dbg_texto
dbg_izq cmp #$0B        ; izquierda
        bne dbg_fin
        dec etapa_ini
        bpl dbg_texto
        lda #NUM_NIVELES-1
        sta etapa_ini
; escribe el numero de etapa_ini + 1 (1-99) en txt_debug
dbg_texto
        lda etapa_ini
        jsr decimal
        clc
        adc #$10        ; d'0' = $10
        cpx #0
        bne dbg_dos
        sta txt_debug+TXT_DEBUG_N
        lda #0          ; espacio
        sta txt_debug+TXT_DEBUG_N+1
        rts
dbg_dos sta txt_debug+TXT_DEBUG_N+1
        txa
        clc
        adc #$10
        sta txt_debug+TXT_DEBUG_N
dbg_fin rts
        .endif

; A = etapa (0-98): devuelve el numero de nivel (etapa + 1) en X = decenas,
; A = unidades
decimal
        clc
        adc #1
        ldx #0
dc_div  cmp #10
        bcc dc_fin
        sbc #10
        inx
        jmp dc_div
dc_fin  rts

; «LEVEL n» en el centro durante 2 segundos, con la fuente de Kaiju
pantalla_level
        jsr limpiar_pantalla
        ldx #4
pl_txt  lda txt_level,x
        sta PANTALLA+11*40+15,x
        dex
        bpl pl_txt
        lda etapa
        jsr decimal
        clc
        adc #$0A        ; digito ($0A = '0')
        cpx #0
        beq pl_uno
        sta PANTALLA+11*40+22   ; dos digitos
        txa
        clc
        adc #$0A
pl_uno  sta PANTALLA+11*40+21
        lda #>FUENTE
        jsr modo_texto
        ldx #120
        jmp esperar_n

; mensaje A (bajo) / X (alto) de kaiju_graficos.asm (terminado en $FF) en la
; fila 11 desde la columna Y, con la fuente de la ROM, durante 3 segundos
mensaje
        sta ptr
        stx ptr+1
        sty tmp3
        jsr limpiar_pantalla
        lda #<(PANTALLA+11*40)
        clc
        adc tmp3
        sta ptr2
        lda #>(PANTALLA+11*40)
        adc #0
        sta ptr2+1
        ldy #0
ms_car  lda (ptr),y
        cmp #$FF
        beq ms_fin
        sta (ptr2),y
        iny
        bne ms_car
ms_fin  lda #>FUENTE_ROM
        jsr modo_texto
        ldx #180
        ; sigue en esperar_n

; espera X frames
esperar_n
        jsr esperar_frame
        dex
        bne esperar_n
        rts

; arma la etapa «etapa»: mapa, robots, celulas, HUD y jugador
cargar_etapa
        jsr limpiar_pmg
        jsr limpiar_pantalla
        jsr dibujar_nivel
        jsr cargar_robots       ; sigue leyendo el nivel donde quedo ptr
        lda #0
        sta fin
        sta invul
        sta cuenta
        sta ddy
        lda #4          ; mirando a la derecha
        sta ddx
        lda #11
        sta cnt11
        jsr mostrar_parte       ; la parte inicial, con sus celulas y robots
        jsr dibujar_hud
        jsr modo_juego
        jsr animar_jugador
        jmp dibujar_jugador
