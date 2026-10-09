; balaenemiga.asm - los tiradores y sus balas
;
; Un tirador es un robot como los demas (patrulla, se lo mata a tiros) cuyo
; rob_clase es TIROCLASE ($40, o $C0 en inverso). Cuando lo descubre, en vez
; de perseguir al jugador se pone a distancia de tiro (cazar), y cada
; TIRO_ESPERA actualizaciones le dispara si esta a su alcance, apuntando en 16
; direcciones. Descubierto, se mueve el doble de rapido. Hay
; MAXEB balas enemigas a la vez: la 0 es el player 2 y la 1 el player 3
; (color PCOLR2/3). Mueren al tocar un bloque o al salir de la pantalla, pasan
; por encima de celulas y robots, y al jugador le quitan 1 de energia (herir).

; robot X persiguiendo (rob_estado = 2): elige rob_dir. Los robots comunes van
; hacia el jugador; el tirador mantiene la distancia: lejos (> DIST_MAX) se
; acerca, cerca (< DIST_MIN) se aleja (o de costado; acorralado se queda) y en
; el medio se queda quieto (8) para dispararle. Conserva X.
cazar   lda rob_clase,x
        and #$7F
        cmp #TIROCLASE
        beq ca_tir
ca_hacia
        jsr hacia_jugador
ca_pon  sta rob_dir,x
        rts
ca_tir  jsr distancia
        cmp #DIST_MAX+1
        bcs ca_hacia
        cmp #DIST_MIN
        bcc ca_huye
ca_quieto
        lda #8
        bne ca_pon
ca_huye jsr dir_robot   ; sin sus caracteres en pantalla (no se choca solo;
        jsr borrar2x2   ; ae_mover lo redibuja)
        jsr hacia_jugador
        cmp #8
        bcs ca_quieto   ; justo encima: no hay para donde
        sta tmp3        ; 5 opciones desde huida + dir*5
        asl
        asl
        adc tmp3
        sta tmp3
        lda #5
        sta eb_i
ca_prueba
        ldy tmp3
        lda huida,y
        jsr libre_dir
        beq ca_ok
        inc tmp3
        dec eb_i
        bne ca_prueba
        beq ca_quieto   ; acorralado
ca_ok   lda ti_dir
        bpl ca_pon      ; siempre (0-7)

; Z = 1 si las 4 casillas del robot X movido en la direccion A estan libres.
; Conserva X; deja A en ti_dir.
libre_dir
        sta ti_dir
        tay
        lda rob_x,x
        sta ox_r
        clc
        adc dir_dx,y
        sta rob_x,x
        lda rob_y,x
        sta oy_r
        clc
        adc dir_dy,y
        sta rob_y,x
        jsr libre_robot
        php
        lda ox_r
        sta rob_x,x
        lda oy_r
        sta rob_y,x
        plp
        rts

; A = distancia del robot X al centro del jugador, en casillas (la mayor de
; las dos, en columnas o en filas). Conserva X.
distancia
        lda pcx
        sec
        sbc rob_x,x
        bcs di_x
        eor #$FF        ; C = 0: negar
        adc #1
di_x    sta tmp3
        lda pcy
        sec
        sbc rob_y,x
        bcs di_y
        eor #$FF
        adc #1
di_y    cmp tmp3
        bcs di_fin
        lda tmp3
di_fin  rts

; desde actualizar_enemigos, para el robot X (vivo): si es tirador y le toca,
; dispara, pero solo si el jugador esta a su alcance (hasta DIST_MAX) y no se
; esta alejando de el (escapando no apunta). Conserva X.
tirador
        lda rob_clase,x
        and #$7F
        cmp #TIROCLASE
        bne ti_fin
        dec rob_tiro,x
        bne ti_fin
        inc rob_tiro,x  ; = 1: si ahora no puede, prueba en la proxima
        jsr distancia
        cmp #DIST_MAX+1
        bcs ti_fin      ; muy lejos
        cmp #DIST_MIN
        bcs ti_tira
        lda rob_dir,x   ; cerca: solo si esta quieto (acorralado)
        cmp #8
        bne ti_fin
ti_tira lda #TIRO_ESPERA
        sta rob_tiro,x
        ldy #MAXEB-1    ; una bala enemiga libre
ti_busca
        lda eb_activa,y
        beq ti_libre
        dey
        bpl ti_busca
ti_fin  rts             ; estan todas en vuelo: este disparo se pierde
ti_libre
        sty eb_slot
        lda rob_x,x     ; sale del centro del robot: HPOS 48 + 4x + 2
        asl
        asl
        clc
        adc #50
        sta eb_x,y
        lda rob_y,x     ; linea 32 + 8y + 6
        asl
        asl
        asl
        clc
        adc #38
        sta eb_y,y
        jsr apuntar
        ldy eb_slot
        lda #1
        sta eb_activa,y
        lda #SND_TIRO
        jmp sonar

; velocidad de la bala enemiga eb_slot para que vaya al centro del jugador
; (px+4, py+12) en una de 16 direcciones. Se compara en unidades parecidas en
; pantalla: |dx| / 2 (HPOS) y |dy| / 4 (lineas). Con la mayor (big) y la menor
; (small): small * 5 < big -> recta; small * 3 < big * 2 -> 22,5 grados; si
; no, 45. Velocidades en ap_vx/ap_vy (4 HPOS = 8 lineas por paso, como la bala
; del jugador). Conserva X.
apuntar
        stx eb_i
        ldy eb_slot
        lda #0
        sta ap_sx
        sta ap_sy
        lda px          ; dx = (px + 4) - (eb_x + 2)
        clc
        adc #2
        sec
        sbc eb_x,y
        bcs ap_x1
        eor #$FF        ; C = 0: negar
        adc #1
        inc ap_sx       ; hacia la izquierda
ap_x1   lsr
        sta ap_ax
        lda py          ; dy = (py + 12) - (eb_y + 2)
        clc
        adc #10
        sec
        sbc eb_y,y
        bcs ap_y1
        eor #$FF
        adc #1
        inc ap_sy       ; hacia arriba
ap_y1   lsr
        lsr
        sta ap_ay
        ldx #0          ; X = 0 domina dx, 3 domina dy (+ 0/1/2 el angulo)
        cmp ap_ax
        bcc ap_xmay
        beq ap_xmay
        ldx #3
        sta ap_big
        lda ap_ax
        jmp ap_sub
ap_xmay lda ap_ax
        sta ap_big
        lda ap_ay
ap_sub  sta ap_small    ; small <= 45 (|dy| / 4): small * 5 entra en un byte
        asl
        asl
        adc ap_small
        cmp ap_big
        bcc ap_s0       ; small * 5 < big: recta
        lda ap_small
        asl
        adc ap_small
        sta tmp3
        lda ap_big
        asl
        cmp tmp3
        beq ap_s2
        bcs ap_s1       ; big * 2 > small * 3: 22,5 grados
ap_s2   inx
ap_s1   inx
ap_s0   lda ap_vx,x
        ldy ap_sx
        beq ap_vx1
        eor #$FF
        clc
        adc #1
ap_vx1  ldy eb_slot
        sta eb_dx,y
        lda ap_vy,x
        ldy ap_sy
        beq ap_vy1
        eor #$FF
        clc
        adc #1
ap_vy1  ldy eb_slot
        sta eb_dy,y
        ldx eb_i
        rts

; Z = 1 si el robot X es un tirador que descubrio al jugador: se mueve el
; doble de rapido (una casilla en cada actualizacion). Conserva X.
veloz   lda rob_estado,x
        cmp #2
        bne ve_fin
        lda rob_clase,x
        and #$7F
        cmp #TIROCLASE
ve_fin  rts

; cada paso: mueve las balas enemigas, prueba si chocan y las redibuja
actualizar_balas_enemigas
        ldx #MAXEB-1
abe_una lda eb_activa,x
        bne abe_vuela
        jmp abe_sig
abe_vuela
        jsr borrar_be
        lda eb_x,x
        clc
        adc eb_dx,x
        sta eb_x,x
        cmp #48         ; fuera de la zona visible: se destruye
        bcc abe_muere
        cmp #204
        bcs abe_muere
        lda eb_y,x
        clc
        adc eb_dy,x
        sta eb_y,x
        cmp #40
        bcc abe_muere
        cmp #212
        bcs abe_muere
        stx eb_i        ; bloque en el centro de la bala (bloque_en usa X)
        clc
        adc #1
        sta tmp3
        lda eb_x,x
        clc
        adc #1
        tax
        lda tmp3
        jsr bloque_en
        ldx eb_i
        bcc abe_jug     ; vacio
        jsr solido
        bcs abe_muere
abe_jug lda eb_x,x      ; toca al jugador? bala x..x+3, y..y+3 contra su
        clc             ; caja px..px+7, py+2..py+21
        adc #3
        cmp px
        bcc abe_pinta
        lda px
        clc
        adc #7
        cmp eb_x,x
        bcc abe_pinta
        lda eb_y,x
        clc
        adc #1          ; y+3 >= py+2
        cmp py
        bcc abe_pinta
        lda py
        clc
        adc #21
        cmp eb_y,x
        bcc abe_pinta
        jsr herir
abe_muere
        lda #0
        sta eb_activa,x
        jmp abe_sig
abe_pinta
        jsr pintar_be
abe_sig dex
        bmi abe_fin
        jmp abe_una
abe_fin rts

; dibuja la bala enemiga X (eb_icono, 4 lineas) en su player. Conserva X.
pintar_be
        ldy eb_y,x
        lda eb_x,x
        cpx #0
        bne pb_p3
        sta HPOSP2
        lda eb_icono
        sta PMG+$600,y
        lda eb_icono+1
        sta PMG+$601,y
        lda eb_icono+2
        sta PMG+$602,y
        lda eb_icono+3
        sta PMG+$603,y
        rts
pb_p3   sta HPOSP3
        lda eb_icono
        sta PMG+$700,y
        lda eb_icono+1
        sta PMG+$701,y
        lda eb_icono+2
        sta PMG+$702,y
        lda eb_icono+3
        sta PMG+$703,y
        rts

; borra la bala enemiga X de su player. Conserva X.
borrar_be
        ldy eb_y,x
        lda #0
        cpx #0
        bne bb_p3
        sta PMG+$600,y
        sta PMG+$601,y
        sta PMG+$602,y
        sta PMG+$603,y
        rts
bb_p3   sta PMG+$700,y
        sta PMG+$701,y
        sta PMG+$702,y
        sta PMG+$703,y
        rts
