; jugador.asm - movimiento, animacion y dibujo del jugador
; El jugador es el robot de Kaiju: poses de 8 x 24 a resolucion de 1 linea
; (kaiju_graficos.asm), cuerpo y contorno mezclados (GPRIOR $31): J1 = P0 + P1,
; J2 = P2 + P3. Las rutinas trabajan sobre el jugador activo (bloque JUG de
; datos.asm, «jugador» = 0 o 1); cargar_jugador / guardar_jugador lo cambian.

; carga el jugador A (0 o 1) en el bloque JUG
cargar_jugador
        sta jugador
        jsr base_jugador
        ldy #0
cj_b    lda jug_datos,x
        sta JUG,y
        inx
        iny
        cpy #JUG_TAM
        bne cj_b
        rts

; guarda el bloque JUG en la copia del jugador activo
guardar_jugador
        jsr base_jugador
        ldy #0
gj_b    lda JUG,y
        sta jug_datos,x
        inx
        iny
        cpy #JUG_TAM
        bne gj_b
        rts

; X = desplazamiento de la copia del jugador activo en jug_datos (0 o JUG_TAM)
base_jugador
        ldx #0
        lda jugador
        beq bj_fin
        ldx #JUG_TAM
bj_fin  rts

; lee el joystick y mueve al jugador: limites, freno en diagonal y choques
; con los bloques del nivel (primero en horizontal y luego en vertical, asi
; se desliza a lo largo de una pared)
mover_jugador
        lda #0
        sta salida

        lda px          ; guardar posicion para deshacer el movimiento
        sta oldx
        lda py
        sta oldy

        ; si hay alguna direccion, se recalcula hacia donde mira (ddx, ddy)
        ldx jugador
        lda STICK0,x
        and #$0F
        cmp #$0F
        beq nodir
        lda #0
        sta ddx
        sta ddy
nodir
        ; leer joystick (bits 0=arriba 1=abajo 2=izq 3=der) y pedir movimiento
        lda #0
        sta mvx
        sta mvy
        lda STICK0,x
        lsr
        bcs noup
        ldx #$FE        ; vertical: 2 lineas por frame (PMG a 1 linea)
        stx mvy
        ldx #$FC        ; -4
        stx ddy
noup    lsr
        bcs nodown
        ldx #2
        stx mvy
        ldx #4
        stx ddy
nodown  lsr
        bcs noleft
        ldx #$FF
        stx mvx
        ldx #$FC        ; -4
        stx ddx
noleft  lsr
        bcs noright
        ldx #1
        stx mvx
        ldx #4
        stx ddx
noright

        ; diagonal: solo avanza 3 de cada 4 pasos (si no, va ~41% mas rapido);
        ; en el paso frenado no se mueve y andando queda como estaba (npaso y
        ; no RTCLOK: con 2 frames por paso RTCLOK & 3 frenaria 1 de cada 2)
        lda mvx
        beq nofreno
        lda mvy
        beq nofreno
        lda npaso
        and #3
        bne nofreno
        rts
nofreno
        ; impulso: 1 de cada IMPULSO pasos avanza el doble, asi el jugador va
        ; un 10% mas rapido sin tocar el resto del juego
        dec cimpulso
        bne noimpulso
        lda #IMPULSO
        sta cimpulso
        asl mvx         ; -1/1 -> -2/2 (px)
        asl mvy         ; -2/2 -> -4/4 (lineas)
noimpulso

        ; horizontal: 50 <= px <= 200, y deshacer si choca con un bloque
        lda px
        clc
        adc mvx
        cmp #50
        bcs okleft
        ldx #SAL_IZQ    ; quiso salir por la izquierda (ver_salida)
        stx salida
        lda #50
okleft  cmp #201
        bcc okright
        ldx #SAL_DER
        stx salida
        lda #200
okright sta px
        jsr choca
        bcc okx
        jsr borde_hiere
        lda oldx
        sta px
okx
        ; vertical: 40 <= py <= 198 (el borde del nivel ya impide llegar al HUD)
        lda py
        clc
        adc mvy
        cmp #40
        bcs okmin
        ldx #SAL_ARR
        stx salida
        lda #40
okmin   cmp #199
        bcc okmax
        ldx #SAL_ABA
        stx salida
        lda #198
okmax   sta py
        jsr choca
        bcc oky
        jsr borde_hiere
        lda oldy
        sta py
oky

        ; andando = 1 si la posicion cambio (contra un bloque no hay animacion)
        lda #0
        sta andando
        lda px
        cmp oldx
        bne semovio
        lda py
        cmp oldy
        beq finmov
semovio inc andando
finmov  rts

; choca devolvio en A el bloque: el borde verde (2 y 3) quita energia
borde_hiere
        cmp #2
        bcc bh_fin
        cmp #4
        bcs bh_fin
        jmp herir
bh_fin  rts

; animacion: al caminar alterna paso A y B cada 5 frames (como Kaiju).
; Elige la pose (POSE_*, datos.asm) y si se dibuja espejada (espejo = $80).
animar_jugador
        lda #0
        sta espejo
        lda andando
        bne caminando
        sta tick        ; quieto: A = 0
        sta paso
        lda ddx         ; mira a la izquierda o a la derecha
        bmi q_izq
        lda #POSE_QUIETO_DER
        sta pose
        rts
q_izq   lda #POSE_QUIETO_IZQ
        sta pose
        rts
caminando
        inc tick
        lda tick
        cmp #5
        bcc elegir
        lda #0
        sta tick
        lda paso
        eor #1
        sta paso
elegir
        lda ddx         ; solo hacia arriba (sin horizontal): de espaldas
        bne de_lado
        lda ddy
        bpl de_lado
        lda #POSE_ARRIBA_A
        jmp sumapaso
de_lado lda ddx
        bpl a_der
        lda #$80        ; caminando a la izquierda: pasos espejados
        sta espejo
a_der   lda #POSE_CAMINA_A
sumapaso
        clc
        adc paso        ; paso 0 = A, 1 = B (la pose B va justo despues)
        sta pose
        rts

; ptr3 / ptr5 = lineas de la PMG del cuerpo y del contorno del jugador activo
; desde py - 4 (J1: P0 y P1, J2: P2 y P3)
pmg_jugador
        lda py
        sec
        sbc #4
        sta ptr3
        sta ptr5
        lda jugador
        asl             ; C = 0 (jugador es 0 o 1)
        adc #>(PMG+$400)
        sta ptr3+1
        adc #1
        sta ptr5+1
        rts

; dibuja la pose actual: 24 filas del cuerpo y del contorno (guardado 24 bytes
; despues), espejadas con revtab si espejo = $80, y fija la columna. No se
; borra antes: se limpian las 4 lineas de arriba y las 4 de abajo (el jugador
; se mueve hasta 4 lineas por paso), asi el sprite nunca queda vacio mientras
; ANTIC lo muestra (si no, parpadea)
dibujar_jugador
        lda pose        ; J2 tiene sus propias poses (kaiju2_graficos.asm)
        ldx jugador
        beq dj_pose
        clc
        adc #POSES_J2
dj_pose tax
        lda poses_lo,x  ; ptr = pose - 4 y ptr4 = pose + 20: con Y = 4..27
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
        ldy #31
        lda #0
dj_aba  sta (ptr3),y    ; las 4 lineas de abajo
        sta (ptr5),y
        dey
        cpy #27
        bne dj_aba
dj      lda (ptr),y     ; fila del cuerpo
        jsr espejar
        sta (ptr3),y
        lda (ptr4),y    ; misma fila del contorno
        jsr espejar
        sta (ptr5),y
        dey
        cpy #3
        bne dj
        lda #0
dj_arr  sta (ptr3),y    ; las 4 lineas de arriba
        sta (ptr5),y
        dey
        bpl dj_arr
        lda invul       ; invulnerable: parpadea (oculto 4 pasos de cada 8)
        and #4
        beq dj_pos
        lda #0          ; HPOS 0: fuera de la pantalla
        beq hpos_jugador
dj_pos  lda px
; pone el cuerpo y el contorno del jugador activo en el HPOS A
hpos_jugador
        ldx jugador
        beq hj_j1
        sta HPOSP2
        sta HPOSP3
        rts
hj_j1   sta HPOSP0
        sta HPOSP1
        rts

; si espejo = $80 invierte los bits de A (revtab); conserva X e Y
espejar bit espejo
        bpl esp_fin
        stx tmp
        tax
        lda revtab,x
        ldx tmp
esp_fin rts
