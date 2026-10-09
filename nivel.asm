; nivel.asm - pantallas (juego, mensajes, titulo), nivel y choques
;
; Pantalla de juego (DLIST): 24 filas de ANTIC 4 (caracteres multicolor) con
; la fuente de Kaiju; la fila 0 es el HUD. Como en el original no hay DLI.
; Coordenadas: la fila r ocupa las lineas 32+8r a 39+8r y la columna c los
; HPOS 48+4c a 51+4c (un caracter de ANTIC 4 = 4 x 8).
; Titulo (DLIST_T): imagen de Kaiju en ANTIC E (196 lineas, en dos bloques de
; 4 KB, kaiju_titulo.asm) y una linea de texto en ANTIC 7.

; arma la fuente y las dos listas de pantalla
iniciar_pantalla
        ; fuente: la de la ROM y encima los 57 caracteres de Kaiju (codigos 2-58)
        ldx #0
fnt_rom lda FUENTE_ROM,x
        sta FUENTE,x
        lda FUENTE_ROM+$100,x
        sta FUENTE+$100,x
        lda FUENTE_ROM+$200,x
        sta FUENTE+$200,x
        lda FUENTE_ROM+$300,x
        sta FUENTE+$300,x
        inx
        bne fnt_rom
fnt_k1  lda kaiju_fuente,x       ; primeros 256 bytes (X vale 0)
        sta FUENTE+$10,x
        inx
        bne fnt_k1
fnt_k2  lda kaiju_fuente+$100,x  ; los 200 restantes (57 x 8 = 456)
        sta FUENTE+$110,x
        inx
        cpx #200
        bne fnt_k2
        ldx #63         ; y los 16 del tirador: $40-$47 y $50-$57
fnt_t   lda fuente_tirador,x
        sta FUENTE+TIROCLASE*8,x
        lda fuente_tirador+64,x
        sta FUENTE+(TIROCLASE+$10)*8,x
        dex
        bpl fnt_t

        ; lista de pantalla del juego
        ldx #dl_fin-dl_datos-1
cp_dl   lda dl_datos,x
        sta DLIST,x
        dex
        bpl cp_dl

        ; lista del titulo: 24 en blanco, 102 lineas desde kaiju_titulo1, 94
        ; desde kaiju_titulo2 (ANTIC no cruza 4 KB sin otro LMS), texto, salto
        lda #$70
        sta DLIST_T
        sta DLIST_T+1
        sta DLIST_T+2
        lda #$4E
        sta DLIST_T+3
        lda #<kaiju_titulo1
        sta DLIST_T+4
        lda #>kaiju_titulo1
        sta DLIST_T+5
        ldx #6
        ldy #101
        lda #$0E
dlt_1   sta DLIST_T,x
        inx
        dey
        bne dlt_1
        lda #$4E
        sta DLIST_T,x
        lda #<kaiju_titulo2
        sta DLIST_T+1,x
        lda #>kaiju_titulo2
        sta DLIST_T+2,x
        inx
        inx
        inx
        ldy #93
        lda #$0E
dlt_2   sta DLIST_T,x
        inx
        dey
        bne dlt_2
        lda #$47        ; ANTIC 7 + LMS: "MUVIRON  SOULBATTERY"
        sta DLIST_T,x
        .if DEBUG       ; o el selector de nivel
        lda #<txt_debug
        sta DLIST_T+1,x
        lda #>txt_debug
        .else
        lda #<kaiju_txt_titulo
        sta DLIST_T+1,x
        lda #>kaiju_txt_titulo
        .endif
        sta DLIST_T+2,x
        lda #$41
        sta DLIST_T+3,x
        lda #<DLIST_T
        sta DLIST_T+4,x
        lda #>DLIST_T
        sta DLIST_T+5,x
        rts

; pone la lista de pantalla A (bajo) / X (alto) justo despues de un VBI, para
; que el OS no copie una direccion a medias
poner_dl
        pha
        jsr esperar_frame
        pla
        sta SDLSTL
        stx SDLSTH
        rts

; colores de la pantalla de juego (los bloques de Kaiju)
colores_juego
        lda #KAIJU_COLOR0
        sta COLOR0
        lda #KAIJU_COLOR1
        sta COLOR1
        lda #KAIJU_COLOR2
        sta COLOR2
        rts

; pantalla de juego: fuente de Kaiju
modo_juego
        lda #<DLIST
        ldx #>DLIST
        jsr poner_dl
        lda #>FUENTE
        sta CHBAS
        jmp colores_juego

; pantalla de mensajes: la misma con la fuente de pagina A, sin sprites ni sonido
modo_texto
        pha
        jsr limpiar_pmg
        lda #0
        sta sndtim
        sta AUDC1
        lda #<DLIST
        ldx #>DLIST
        jsr poner_dl
        pla
        sta CHBAS
        jmp colores_juego

; pantalla de titulo
modo_titulo
        jsr limpiar_pmg
        lda #<DLIST_T
        ldx #>DLIST_T
        jsr poner_dl
        lda #>FUENTE_ROM        ; para la linea de texto
        sta CHBAS
        lda #KAIJU_TITULO_COLOR0
        sta COLOR0
        lda #KAIJU_TITULO_COLOR1
        sta COLOR1
        lda #KAIJU_TITULO_COLOR2
        sta COLOR2
        rts

; borra los 2 KB de los sprites (jugador, bala, todo)
limpiar_pmg
        lda #0
        sta activa
        sta eb_activa
        sta eb_activa+1
        tax
lpm     sta PMG,x
        sta PMG+$100,x
        sta PMG+$200,x
        sta PMG+$300,x
        sta PMG+$400,x
        sta PMG+$500,x
        sta PMG+$600,x
        sta PMG+$700,x
        inx
        bne lpm
        rts

; borra las 24 filas de la pantalla (960 bytes)
limpiar_pantalla
        lda #0
        tax
lpa     sta PANTALLA,x
        sta PANTALLA+$100,x
        sta PANTALLA+$200,x
        cpx #960-$300
        bcs lpa_s
        sta PANTALLA+$300,x
lpa_s   inx
        bne lpa
        rts

; lee el nivel «etapa» (niveles.asm): cabecera (parte inicial, inicio del
; jugador, partes de ancho y de alto) y descomprime cada parte en su MAPAS
; (partes.asm). Los mapas vienen comprimidos: $FF, n, v = n veces v; otro
; byte = tal cual. Deja ptr justo detras (robots y celulas, cargar_robots)
dibujar_nivel
        lda etapa
        asl
        tax
        lda niveles,x
        sta ptr
        lda niveles+1,x
        sta ptr+1
        jsr leer_nivel
        sta parte
        jsr leer_nivel  ; inicio del jugador
        sta px
        jsr leer_nivel
        sta py
        jsr leer_nivel
        sta pancho
        jsr leer_nivel
        sta palto
        lda parte       ; pcol = parte % pancho, pfil = parte / pancho
        ldx #0
dn_div  cmp pancho
        bcc dn_res
        sbc pancho
        inx
        jmp dn_div
dn_res  sta pcol
        stx pfil
        lda #0          ; npartes = pancho * palto
        ldx palto
dn_mul  clc
        adc pancho
        dex
        bne dn_mul
        sta npartes
        lda #0
        sta dn_p
dn_parte
        lda dn_p        ; destino: MAPAS de la parte, hasta +920
        jsr dir_mapa
        lda ptr2
        clc
        adc #<920
        sta dn_finl
        lda ptr2+1
        adc #>920
        sta dn_finh
dn_sig  jsr leer_nivel
        ldx #1          ; un caracter suelto...
        cmp #$FF
        bne dn_pon
        jsr leer_nivel  ; ... o una tira: n veces v
        tax
        jsr leer_nivel
dn_pon  ldy #0
        sta (ptr2),y
        inc ptr2
        bne dn_n
        inc ptr2+1
dn_n    dex
        bne dn_pon
        lda ptr2
        cmp dn_finl
        bne dn_sig
        lda ptr2+1
        cmp dn_finh
        bne dn_sig
        inc dn_p
        lda dn_p
        cmp npartes
        bcc dn_parte
        rts

; A = siguiente byte del nivel en ptr (y avanza ptr). Conserva X.
leer_nivel
        ldy #0
        lda (ptr),y
        inc ptr
        bne ln_fin
        inc ptr+1
ln_fin  rts

; caja del robot en (px, py), en filas fil0-fil1 y columnas col0-col1: las 8
; columnas del sprite y sus lineas 2-21 (las filas 0-1 y 22-23 estan vacias)
caja_jugador
        lda py
        clc
        adc #2-32
        lsr
        lsr
        lsr
        sta fil0
        lda py
        clc
        adc #21-32
        lsr
        lsr
        lsr
        sta fil1
        lda px
        sec
        sbc #48
        lsr
        lsr
        sta col0
        lda px
        clc
        adc #7-48
        lsr
        lsr
        sta col1
        rts

; C = 1 si el robot en (px, py) toca algun bloque, con A = ese caracter.
; Las celulas ($14-$1B) y los enemigos ($1C-$33, tambien en inverso) se
; atraviesan: tocarlos lo resuelve contactos (enemigos.asm).
choca
        jsr caja_jugador
ch_fila ldx fil0
        lda filas_lo,x
        sta ptr2
        lda filas_hi,x
        sta ptr2+1
        ldy col0
ch_col  lda (ptr2),y
        beq ch_sig
        jsr solido
        bcc ch_sig      ; celula o enemigo
        lda (ptr2),y
        sec
        rts
ch_sig  cpy col1        ; C = 0 mientras falten columnas (INY no toca C)
        iny
        bcc ch_col
        lda fil0
        cmp fil1
        inc fil0
        bcc ch_fila
        clc
        rts

; C = 1 si el caracter A (no 0) es un bloque; C = 0 si es una celula ($14-$1B)
; o un robot ($1C-$33, tiradores $40-$57), tambien en inverso. Conserva X e Y.
solido  and #$7F
        cmp #$14
        bcc so_si
        cmp #$34
        bcc so_no
        cmp #TIROCLASE
        bcc so_si
        cmp #TIROCLASE+$18
        bcc so_no
so_si   sec
        rts
so_no   clc
        rts

; C = 1 si la casilla de la linea A y el HPOS X tiene algo. Devuelve A = el
; caracter, bfil/bcol = la casilla y ptr2/Y apuntando a ella (para romperla)
bloque_en
        sec
        sbc #32
        lsr
        lsr
        lsr
        sta bfil
        tay
        lda filas_lo,y
        sta ptr2
        lda filas_hi,y
        sta ptr2+1
        txa
        sec
        sbc #48
        lsr
        lsr
        sta bcol
        tay
        lda (ptr2),y
        cmp #1          ; C = 1 si no es 0
        rts
