; partes.asm - niveles de varias partes (pantallas)
;
; Un nivel es una cuadricula de pancho x palto partes (hasta MAXPARTES), cada
; una de 23 x 40 caracteres. Al cargarlo se descomprimen todas en MAPAS (RAM,
; 920 bytes por parte); en pantalla esta la parte «parte» (columna pcol, fila
; pfil). Cuando el jugador sale por un hueco del borde (mover_jugador deja en
; «salida» por donde) se guarda la pantalla en su MAPAS, sin robots ni
; celulas, y se trae la vecina: lo roto, juntado o destruido sigue igual al
; volver. Los robots y celulas de las otras partes no se mueven ni se dibujan.

SAL_IZQ = 1             ; valores de «salida»
SAL_DER = 2
SAL_ARR = 3
SAL_ABA = 4

; ptr2 = MAPAS de la parte A. Conserva X.
dir_mapa
        tay
        lda mapas_lo,y
        sta ptr2
        lda mapas_hi,y
        sta ptr2+1
        rts

; copia 920 bytes (una parte) de ptr a ptr2 (avanza los dos punteros)
copiar_mapa
        ldx #3          ; 920 = 3 paginas + 152
        ldy #0
cm_pag  lda (ptr),y
        sta (ptr2),y
        iny
        bne cm_pag
        inc ptr+1
        inc ptr2+1
        dex
        bne cm_pag
cm_res  lda (ptr),y
        sta (ptr2),y
        iny
        cpy #152
        bne cm_res
        rts

; parte = pfil * pancho + pcol
calc_parte
        lda #0
        ldx pfil
        beq cp_col
cp_mul  clc
        adc pancho
        dex
        bne cp_mul
cp_col  clc
        adc pcol
        sta parte
        rts

; guarda la pantalla (filas 1-23) en el MAPAS de «parte», sin sus robots (ni
; sus explosiones) ni sus celulas
guardar_parte
        ldx #0          ; sacar los robots vivos de esta parte
gp_rob  cpx nrob
        bcs gp_cel
        lda rob_parte,x
        cmp parte
        bne gp_rs
        lda rob_dir,x
        cmp #9
        bne gp_borra
        lda rob_expl,x  ; destruido: si todavia explota, se termina ya
        beq gp_rs
        lda #0
        sta rob_expl,x
gp_borra
        jsr dir_robot
        jsr borrar2x2
gp_rs   inx
        jmp gp_rob
gp_cel  ldx #0          ; y las celulas que quedan
gp_c2   cpx ncel
        bcs gp_copia
        lda cel_parte,x
        cmp parte
        bne gp_cs
        lda cel_viva,x
        beq gp_cs
        jsr dir_celula
        jsr borrar2x2
gp_cs   inx
        jmp gp_c2
gp_copia
        lda parte
        jsr dir_mapa
        lda #<(PANTALLA+40)
        sta ptr
        lda #>(PANTALLA+40)
        sta ptr+1
        jmp copiar_mapa

; pone en pantalla la parte «parte» (su MAPAS) con sus celulas y robots
mostrar_parte
        lda parte
        jsr dir_mapa
        lda ptr2
        sta ptr
        lda ptr2+1
        sta ptr+1
        lda #<(PANTALLA+40)
        sta ptr2
        lda #>(PANTALLA+40)
        sta ptr2+1
        jsr copiar_mapa
        jsr centro_jugador      ; hacia donde miran los tiradores
        jsr pintar_celulas
        ldx #0
mp_rob  cpx nrob
        bcs mp_fin
        lda rob_parte,x
        cmp parte
        bne mp_rs
        lda rob_dir,x
        cmp #9
        beq mp_rs
        jsr dibujar_robot
mp_rs   inx
        jmp mp_rob
mp_fin  rts

; despues de mover a los jugadores: si todos los vivos quieren salir por el
; mismo lado y hay una parte de ese lado, pasa a ella; aparecen en el borde
; de enfrente. Con los dos vivos se avisa en el HUD cuantos estan en la
; «puerta» (1/2, 2/2) y, ya los dos, se cambia tras PUERTA_PASOS pasos
ver_salida
        ldx #0
        jsr salida_de
        sta tmp3
        ldx #JUG_TAM
        jsr salida_de
        cmp #$FF        ; J2 fuera: manda J1
        beq vs_solo
        ldx tmp3
        cpx #$FF        ; J1 fuera: manda J2
        bne vs_dos
        sta tmp3
vs_solo ldy #0          ; uno solo: sin aviso, pasa enseguida
        jsr poner_aviso
        jmp vs_j1
vs_dos
        sta tmp2        ; los dos vivos: cuantos estan en la puerta
        ldx #0          ; la caja va junto al primero que este en la puerta
        lda tmp3
        bne vs_cj
        ldx #JUG_TAM
        lda tmp2
vs_cj   stx caja_jug
        sta caja_lado
        ldy #0
        lda tmp3
        beq vs_n1
        iny
vs_n1   lda tmp2
        beq vs_n2
        iny
vs_n2   cpy #2
        bne vs_espera
        lda tmp3        ; los dos, pero hacia el mismo lado?
        cmp tmp2
        beq vs_juntos
        dey
vs_espera
        jsr poner_aviso
        lda #PUERTA_PASOS
        sta puerta_t
        rts
vs_juntos
        jsr poner_aviso ; 2/2 un rato, y despues se cambia
        dec puerta_t
        beq vs_j1       ; ya: se pasa hacia el lado de los dos
        rts
vs_j1   lda tmp3
        cmp #$FF
        beq vs_no
        cmp #0
        bne vs_si
vs_no   rts
vs_si   pha
        ldy #0          ; se va el aviso
        jsr poner_aviso
        lda #PUERTA_PASOS
        sta puerta_t
        pla
        cmp #SAL_IZQ
        bne vs_der
        lda pcol
        beq vs_fin
        jsr guardar_parte
        dec pcol
        ldx #J_PX
        lda #200
        jmp vs_cambia
vs_der  cmp #SAL_DER
        bne vs_arr
        ldx pcol
        inx
        cpx pancho
        bcs vs_fin
        jsr guardar_parte
        inc pcol
        ldx #J_PX
        lda #50
        jmp vs_cambia
vs_arr  cmp #SAL_ARR
        bne vs_aba
        lda pfil
        beq vs_fin
        jsr guardar_parte
        dec pfil
        ldx #J_PY
        lda #198
        jmp vs_cambia
vs_aba  ldx pfil
        inx
        cpx palto
        bcs vs_fin
        jsr guardar_parte
        inc pfil
        ldx #J_PY
        lda #40
vs_cambia               ; A = nueva px o py (X = su campo) de los vivos
        ldy jug_datos+J_ENERGIA
        beq vs_c2
        sta jug_datos,x
vs_c2   ldy jug_datos+JUG_TAM+J_ENERGIA
        beq vs_c3
        sta jug_datos+JUG_TAM,x
vs_c3   jsr calc_parte
        jsr limpiar_pmg ; las balas en vuelo desaparecen
        jsr mostrar_parte
vs_fin  rts

; aviso = Y (0, 1 o 2 jugadores en la puerta); si cambia, se quita la caja y
; (si hay alguien) se vuelve a poner con el numero nuevo
poner_aviso
        cpy aviso
        beq pa_fin
        sty aviso
        jsr quitar_caja
        lda aviso
        bne poner_caja
pa_fin  rts

; dibuja la caja del aviso («aviso»/2) junto a la puerta caja_lado, del lado
; de adentro del jugador caja_jug, solo sobre las casillas vacias
poner_caja
        clc             ; el digito: '1' o '2'
        adc #CAJA+6
        sta caja_car+6
        ldx caja_jug    ; casilla del centro del jugador
        lda jug_datos+J_PX,x
        clc
        adc #4-48
        lsr
        lsr
        sta tmp2
        lda jug_datos+J_PY,x
        clc
        adc #12-32
        lsr
        lsr
        lsr
        sta tmp3
        lda caja_lado   ; izq/der: a 3 casillas del borde, a la altura del
        cmp #SAL_ARR    ; jugador; arr/aba: a 4 filas, centrada en el
        bcs pk_vert     ; jugador
        ldx #3
        cmp #SAL_IZQ
        beq pk_h
        ldx #32
pk_h    stx caja_x
        ldx tmp3
        dex
        stx caja_y
        jmp pk_lim
pk_vert ldx #4
        cmp #SAL_ARR
        beq pk_v
        ldx #18
pk_v    stx caja_y
        ldx tmp2
        dex
        dex
        stx caja_x
pk_lim  lda caja_x      ; dentro del mapa: columnas 1-34, filas 2-20
        ldx #1
        ldy #34
        jsr limitar
        sta caja_x
        lda caja_y
        ldx #2
        ldy #20
        jsr limitar
        sta caja_y
        ldx #0          ; X = caracter 0-14 de la caja
pk_fila jsr dir_caja
        ldy #0
pk_col  lda (ptr2),y
        sta caja_fondo,x
        bne pk_sig      ; ocupada: queda lo que hay
        lda caja_car,x
        sta (ptr2),y
pk_sig  inx
        iny
        cpy #5
        bne pk_col
        cpx #15
        bne pk_fila
        lda #1
        sta caja_on
        rts

; saca la caja (si esta): repone lo que habia donde todavia este la caja
quitar_caja
        lda caja_on
        beq qc_fin
        lda #0
        sta caja_on
        ldx #0
qc_fila jsr dir_caja
        ldy #0
qc_col  lda (ptr2),y
        cmp #CAJA
        bcc qc_sig
        cmp #CAJA+10
        bcs qc_sig
        lda caja_fondo,x
        sta (ptr2),y
qc_sig  inx
        iny
        cpy #5
        bne qc_col
        cpx #15
        bne qc_fila
qc_fin  rts

; ptr2 = pantalla en la fila de la caja del caracter X (0, 5 o 10), columna
; caja_x. Conserva X.
dir_caja
        txa
        ldy #0
dc_f    cmp #5
        bcc dc_y
        sbc #5
        iny
        bne dc_f
dc_y    tya
        clc
        adc caja_y
        tay
        lda filas_lo,y
        clc
        adc caja_x
        sta ptr2
        lda filas_hi,y
        adc #0
        sta ptr2+1
        rts

; A entre X e Y (A >= $80 cuenta como negativo: X)
limitar stx tmp
        cmp #$80
        bcs li_min
        cmp tmp
        bcc li_min
        sty tmp
        cmp tmp
        bcc li_fin
        beq li_fin
        tya
li_fin  rts
li_min  txa
        rts

; A = salida del jugador X (0 o JUG_TAM, de su copia); $FF si esta fuera
salida_de
        lda jug_datos+J_ENERGIA,x
        beq sd_fuera
        lda jug_datos+J_SALIDA,x
        rts
sd_fuera
        lda #$FF
        rts
