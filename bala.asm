; bala.asm - disparo y bala del jugador activo (una a la vez: missile 0 para
; J1 y 1 para J2, de ancho doble; dibujo 2x4 editable, bala_icono)

actualizar_bala
        jsr borrabala
        lda gatillo     ; recordar el boton del frame anterior
        sta gatant
        ldx jugador
        lda STRIG0,x    ; 0 = presionado
        sta gatillo
        lda activa
        bne bal_mueve
        jsr nuevabala
        lda chispa
        beq finchi
        dec chispa
        beq finchi
        jmp pintachispa
finchi  rts
bal_mueve
        lda bx          ; avanzar la bala
        clc
        adc bdx
        sta bx
        lda by
        clc
        adc bdy
        sta by
        lda bx          ; si sale de la zona visible, se destruye
        cmp #48
        bcc matar
        cmp #205         ; bx+3 (esquina derecha) <= col 39
        bcs matar
        lda by
        cmp #40           ; fila 0 reservada para el HUD
        bcc matar
        cmp #216
        bcs matar
        ; se prueban las 4 esquinas de la bala (4 x 8): rompe todos los bloques
        ; azules que toque; lo primero que no sea azul la destruye
        lda #0
        sta brompe
        ldx #3
bal_pt  stx bpunto
        lda by
        clc
        adc bala_py,x
        pha
        lda bx
        clc
        adc bala_px,x
        tax
        pla
        jsr bloque_en
        bcc bal_sig       ; vacio
        and #$7F          ; quita el bit de inverso
        cmp #5            ; bloque azul: se rompe, +1 punto
        bne bal_cel
        lda #0
        sta (ptr2),y      ; bloque_en dejo ptr2/Y apuntando a la casilla
        lda #1
        sta brompe
        ldx #2
        lda #$01
        jsr sumar_bcd
bal_sig ldx bpunto
        dex
        bpl bal_pt
        lda brompe
        bne matar
        jmp pintabala
bal_cel cmp #$14
        bcc chocar        ; borde, muro o decorado solido: chispas
        cmp #$1C
        bcs bal_rob
        ldx jugador       ; celula: fin de la etapa (se repite) y
        inx               ; pierde energia el que disparo
        stx fin
        jsr romper_celula
        jmp matar
bal_rob cmp #$34
        bcc bal_gol
        cmp #TIROCLASE    ; tirador: $40-$57
        bcc chocar        ; muro solido ($34-$3F): chispas
        cmp #TIROCLASE+$18
        bcs matar
bal_gol jsr golpear_enemigo
matar   lda #0
        sta activa
        rts
chocar  lda #0            ; contra un solido: chispas en bx/by
        sta activa
        lda #CHISPA_PASOS
        sta chispa
; chispas con el missile del jugador: 9 lineas de 4x4 desde by
pintachispa
        ldx jugador
        lda bits_m,x    ; solo los bits del missile del jugador
        sta tmp
        eor #$FF
        sta tmp2
        lda bx
        sta HPOSM0,x    ; ancho doble: 4 HPOS
        ldx by
        lda chispa
        cmp #CHISPA_PASOS/2+1
        lda #<chispa_icono
        ldy #>chispa_icono
        bcs pch_set
        lda #<(chispa_icono+9)
        ldy #>(chispa_icono+9)
pch_set  sta ptr
        sty ptr+1
        jmp pintar_chispas
; dibuja la columna de chispas: X = primera linea, ptr = fila de chispa_icono,
; tmp = bits del missile, tmp2 = su complemento. 9 lineas. No conserva X.
pintar_chispas
        ldy #0
pch_fila lda (ptr),y
        beq pch_off
        lda PMG+$300,x
        ora tmp
        sta PMG+$300,x
        jmp pch_sig
pch_off  lda PMG+$300,x
        and tmp2
        sta PMG+$300,x
pch_sig  inx
        iny
        cpy #9
        bne pch_fila
        rts
nuevabala
        lda gatillo
        bne nb_no       ; 1 = boton sin presionar
        lda gatant
        bne nb_si       ; si ya estaba presionado, hay que soltarlo para volver a disparar
nb_no   rts
nb_si
        lda px          ; la bala (4 px) sale del centro del jugador (8 px)
        clc
        adc #2
        sta bx
        lda py
        clc
        adc #8          ; altura del pecho del robot
        sta by
        lda ddx
        sta bdx
        lda ddy
        asl             ; en vertical el doble: las lineas miden la mitad
        sta bdy
        ; en diagonal la velocidad baja a 3 (x) y 6 (y) (si no, va ~41% mas rapido)
        lda bdx
        beq recta
        lda bdy
        beq recta
        ldx #3
        lda bdx
        bpl dpx
        ldx #$FD        ; -3
dpx     stx bdx
        ldx #6
        lda bdy
        bpl dpy
        ldx #$FA        ; -6
dpy     stx bdy
recta
        lda #1
        sta activa
        lda #0
        sta chispa      ; disparar cancela las chispas que hubiera
        lda #SND_DISPARO
        jsr sonar
pintabala
        ldx jugador     ; 4 filas de bala_m (datos.asm), cada una en 2 lineas,
        lda bits_m,x    ; solo en los bits del missile del jugador
        sta tmp
        eor #$FF
        sta tmp2
        ldy by
        ldx #0          ; X = linea 0-7, fila X/2
bal_pb  txa
        lsr
        sta tmp3
        stx bpunto
        ldx tmp3
        lda bala_m,x
        and tmp
        sta tmp3
        lda PMG+$300,y
        and tmp2
        ora tmp3
        sta PMG+$300,y
        iny
        ldx bpunto
        inx
        cpx #8
        bcc bal_pb
        lda bx
        ldx jugador
        sta HPOSM0,x    ; ancho doble: 4 HPOS
        rts

; borra la bala o las chispas (9 lineas de su missile) si estan activas
borrabala
        lda activa
        ora chispa
        beq nobala
        ldx jugador
        lda bits_m,x
        eor #$FF
        sta tmp2
        ldy by
        ldx #9
bal_bb  lda PMG+$300,y
        and tmp2
        sta PMG+$300,y
        iny
        dex
        bne bal_bb
nobala  rts
