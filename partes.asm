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

; guarda la pantalla (filas 1-23) en el MAPAS de «parte», sin sus robots ni
; sus celulas
guardar_parte
        ldx #0          ; sacar los robots vivos de esta parte
gp_rob  cpx nrob
        bcs gp_cel
        lda rob_parte,x
        cmp parte
        bne gp_rs
        lda rob_dir,x
        cmp #9
        beq gp_rs
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

; despues de mover_jugador: si se salio por un borde y hay una parte de ese
; lado, pasa a ella (el jugador aparece en el borde de enfrente)
ver_salida
        lda salida
        beq vs_fin
        cmp #SAL_IZQ
        bne vs_der
        lda pcol
        beq vs_fin
        jsr guardar_parte
        dec pcol
        lda #200
        sta px
        jmp vs_cambia
vs_der  cmp #SAL_DER
        bne vs_arr
        ldx pcol
        inx
        cpx pancho
        bcs vs_fin
        jsr guardar_parte
        inc pcol
        lda #50
        sta px
        jmp vs_cambia
vs_arr  cmp #SAL_ARR
        bne vs_aba
        lda pfil
        beq vs_fin
        jsr guardar_parte
        dec pfil
        lda #198
        sta py
        jmp vs_cambia
vs_aba  ldx pfil
        inx
        cpx palto
        bcs vs_fin
        jsr guardar_parte
        inc pfil
        lda #40
        sta py
vs_cambia
        jsr calc_parte
        jsr limpiar_pmg ; las balas en vuelo desaparecen
        jsr mostrar_parte
vs_fin  rts
