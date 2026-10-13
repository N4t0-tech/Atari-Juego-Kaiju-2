; datos.asm - variables y graficos del sprite

; --- jugador activo (cooperativo: jugador.asm cargar_jugador/guardar_jugador
; copian este bloque desde/hacia jug_datos + jugador*JUG_TAM). Todo lo que
; es de un solo jugador va entre JUG y JUG_FIN ---
JUG
px      .byte 120
py      .byte 120       ; en lineas (PMG a 1 linea)
oldx    .byte 0         ; posicion antes de mover (para deshacer el movimiento)
oldy    .byte 0
ddx     .byte 4         ; hacia donde mira: -4, 0 o 4 (empieza mirando a la derecha)
ddy     .byte 0
tick    .byte 0         ; frames desde el ultimo cambio de paso
paso    .byte 0         ; paso de la caminata: 0 = A, 1 = B
pose    .byte 0         ; pose a dibujar (POSE_*)
espejo  .byte 0         ; $80 = dibujar la pose espejada
andando .byte 0         ; 1 = el jugador se movio este frame (anima la caminata)
cimpulso .byte IMPULSO  ; pasos hasta el proximo impulso
gatillo .byte 1         ; STRIG de este frame (0 = presionado)
gatant  .byte 1         ; STRIG del frame anterior (para disparar solo al apretar)
activa  .byte 0         ; 1 = hay una bala en vuelo
bx      .byte 0         ; posicion de la bala
by      .byte 0
bdx     .byte 0         ; velocidad de la bala
bdy     .byte 0
puntos  .byte 0,0,0     ; puntuacion BCD, 6 digitos (alto, medio, bajo)
energia .byte 5         ; iconos de energia; 0 = fuera de la partida
invul   .byte 0         ; pasos de invulnerabilidad que quedan tras un golpe
salida  .byte 0         ; SAL_*: por donde quiso salir el jugador este paso
JUG_FIN
JUG_TAM = JUG_FIN - JUG
jugador .byte 0         ; jugador activo: 0 = J1, 1 = J2 (indice de STICK0, HPOSM0...)
unido_j .byte 0,0       ; 1 = el jugador entro en esta partida (al apretar su
                        ; boton: en el titulo o en medio de un nivel)
jug_datos :JUG_TAM*2 .byte 0    ; copia de JUG de cada jugador
; un campo de la copia del jugador X (0 o JUG_TAM): jug_datos+J_xx,x
J_PX    = px - JUG
J_PY    = py - JUG
J_PUNTOS = puntos - JUG
J_ENERGIA = energia - JUG
J_SALIDA = salida - JUG
J_ACTIVA = activa - JUG

FRAMES_PASO = 2         ; frames por paso del juego (1 = 50/60 pasos por segundo)
npaso   .byte 0         ; contador de pasos del juego (freno en diagonal)
IMPULSO = 10            ; el jugador avanza el doble 1 de cada IMPULSO pasos (+10%)
sndtim  .byte 0         ; frames que le quedan al sonido de disparo
tmp     .byte 0         ; auxiliar para el dibujo espejado
tmp2    .byte 0         ; auxiliar (mascaras de los missiles, distancias)
mvx     .byte 0         ; movimiento pedido este frame: -1, 0, 1
mvy     .byte 0         ; -2, 0, 2 (lineas)
fil0    .byte 0         ; caja del robot en filas/columnas (choca)
fil1    .byte 0
col0    .byte 0
col1    .byte 0

; --- partida (etapas.asm) ---
etapa   .byte 0         ; nivel en juego: 0..NUM_NIVELES-1 (niveles.asm), se ve como LEVEL etapa+1
etapa_ini .byte 0       ; etapa con la que empieza la partida (selector DEBUG)
dbg_stick .byte $0F     ; STICK0 anterior del selector (para moverse al apretar)
        .if DEBUG
; linea de texto del titulo en DEBUG (ANTIC 7, 20 caracteres, fuente de la ROM)
txt_debug dta d'   START LEVEL 1    '
TXT_DEBUG_N = 15        ; posicion del numero de nivel (1 o 2 digitos)
        .endif
fin     .byte 0         ; jugador + 1 que disparo a una celula: se repite el nivel
cuenta  .byte 0         ; 0-11: animacion de las celulas (cambian a los 0 y 6)
cnt11   .byte 11        ; frames hasta la proxima actualizacion de los enemigos
sndtipo .byte 0         ; efecto que suena (SND_*)
bcol    .byte 0         ; casilla que toco la bala (bloque_en)
bfil    .byte 0
bpunto  .byte 0         ; esquina de la bala que se esta probando (3..0)
brompe  .byte 0         ; 1 = la bala rompio algun bloque azul en este frame
bala_px .byte 0,3,0,3   ; esquinas de la bala (4 px x 8 lineas) desde bx, by
bala_py .byte 0,0,7,7
pcx     .byte 0         ; casilla del centro del jugador objetivo (enemigos.asm)
pcy     .byte 0
tpx     .byte 0         ; px/py del jugador objetivo (apuntar)
tpy     .byte 0
pcx_j   .byte 0,0       ; casilla del centro de cada jugador
pcy_j   .byte 0,0
vivo_j  .byte 0,0       ; energia de cada jugador (0 = fuera)
tmp3    .byte 0         ; auxiliares
ox_r    .byte 0
oy_r    .byte 0

; --- partes del nivel (partes.asm) ---
MAXPARTES = 4           ; partes por nivel (cada una usa 920 bytes de MAPAS)
parte   .byte 0         ; parte en pantalla
pcol    .byte 0         ; su columna y fila en la cuadricula
pfil    .byte 0
pancho  .byte 1         ; partes de ancho y de alto del nivel
palto   .byte 1
npartes .byte 1
aviso   .byte 0         ; cooperativo: jugadores en la puerta (0, 1 o 2)
puerta_t .byte 0        ; pasos que faltan con los dos en la puerta para cambiar
PUERTA_PASOS = 15       ; medio segundo mostrando «2/2» antes de cambiar de parte
; caja del aviso de la puerta (partes.asm): 5 x 3 caracteres en el mapa, junto
; al hueco, con «1/2» o «2/2». Solo tapa casillas vacias; los jugadores la
; atraviesan (choca) y para robots y balas es un bloque
CAJA    = $58           ; $58-$61, libres en los niveles (fuente_caja)
caja_on .byte 0         ; 1 = la caja esta en pantalla
caja_x  .byte 0         ; su casilla de arriba a la izquierda
caja_y  .byte 0
caja_lado .byte 0       ; SAL_* de la puerta y jugador (0 o JUG_TAM) junto al
caja_jug .byte 0        ; que se pone
caja_fondo :15 .byte 0  ; lo que habia debajo (solo se dibuja sobre vacio)
caja_car .byte CAJA,CAJA+1,CAJA+1,CAJA+1,CAJA+2
        .byte CAJA+3,CAJA+7,CAJA+9,CAJA+8,CAJA+4      ; el 1 cambia por 2
        .byte CAJA+5,CAJA+1,CAJA+1,CAJA+1,CAJA+6
; borde en pixel 11 (COLOR2), digitos y barra en pixel 10 como los del HUD
fuente_caja .byte $00,$00,$00,$0F,$0C,$0C,$0C,$0C       ; $58 esquina arr-izq
        .byte $00,$00,$00,$FF,$00,$00,$00,$00   ; $59 horizontal
        .byte $00,$00,$00,$F0,$30,$30,$30,$30   ; $5A esquina arr-der
        .byte $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C   ; $5B vertical izq
        .byte $30,$30,$30,$30,$30,$30,$30,$30   ; $5C vertical der
        .byte $0C,$0C,$0C,$0F,$00,$00,$00,$00   ; $5D esquina aba-izq
        .byte $30,$30,$30,$F0,$00,$00,$00,$00   ; $5E esquina aba-der
        .byte $02,$02,$02,$02,$02,$02,$02,$00   ; $5F '1'
        .byte $2A,$02,$02,$2A,$20,$20,$2A,$00   ; $60 '2'
        .byte $02,$02,$08,$08,$08,$20,$20,$00   ; $61 '/'
dn_p    .byte 0         ; auxiliares de dibujar_nivel
dn_finl .byte 0
dn_finh .byte 0
mapas_lo
        :MAXPARTES .byte <(MAPAS+#*920)
mapas_hi
        :MAXPARTES .byte >(MAPAS+#*920)

; --- robots enemigos del nivel (enemigos.asm), hasta MAXROB ---
MAXROB  = 16            ; en todo el nivel (todas sus partes)
nrob    .byte 0
rob_parte :MAXROB .byte 0       ; parte del nivel donde esta
rob_x   :MAXROB .byte 0 ; casilla de arriba a la izquierda de sus 2 x 2 caracteres
rob_y   :MAXROB .byte 0
rob_dira :MAXROB .byte 0        ; patrulla: direccion de la 1a mitad del recorrido
rob_dirb :MAXROB .byte 0        ; y de la 2a
rob_pasos :MAXROB .byte 0       ; largo del recorrido (actualizaciones)
rob_clase :MAXROB .byte 0       ; primer caracter: $9C (inverso, COLOR3) o $1C
rob_zy0 :MAXROB .byte 0         ; zona de vigilancia: filas zy0-zy1,
rob_zy1 :MAXROB .byte 0
rob_zx0 :MAXROB .byte 0         ; columnas zx0-zx1
rob_zx1 :MAXROB .byte 0
rob_dir :MAXROB .byte 0         ; direccion actual (DIR_*); 9 = destruido
rob_paso :MAXROB .byte 0        ; paso de la patrulla
rob_estado :MAXROB .byte 0      ; 1 = patrulla, 2 = persigue al jugador
rob_vida :MAXROB .byte 0        ; disparos que aguanta
rob_fase :MAXROB .byte 0        ; animacion; avanza cuando vuelve a 0
rob_golpe :MAXROB .byte 0       ; herido: pasos que le quedan de parpadeo
rob_expl :MAXROB .byte 0        ; destruido: pasos que le quedan a la explosion
rob_tiro :MAXROB .byte 0        ; tiradores: actualizaciones hasta el proximo disparo

; --- tiradores (balaenemiga.asm): robots con rob_clase / (fuente_tirador)
; disparan al jugador cada TIRO_ESPERA actualizaciones (unos 2 segundos). Sus
; balas son los missiles 2 y 3 (una cada uno, COLOR3), 4 x 4
TIROCLASE = $40         ; primer caracter del tirador ($C0 = inverso, COLOR3)
TIRO_ESPERA = 4          ; unos 1,5 segundos
DIST_MIN = 6            ; distancia (casillas) que el tirador quiere mantener:
DIST_MAX = 14           ; se aleja si es menor y se acerca si es mayor
MAXEB   = 2
eb_activa :MAXEB .byte 0        ; 1 = la bala enemiga esta en vuelo
eb_x    :MAXEB .byte 0          ; HPOS de su esquina
eb_y    :MAXEB .byte 0          ; linea PMG de su esquina
eb_dx   :MAXEB .byte 0          ; velocidad por paso
eb_dy   :MAXEB .byte 0
eb_slot .byte 0                 ; auxiliares
eb_i    .byte 0
; apuntar: velocidad (sin signo) de la bala enemiga en las 16 direcciones;
; 0-2 = domina x (recta, 22,5 y 45 grados), 3-5 = domina y
ap_vx   .byte 4,4,3, 0,2,3
ap_vy   .byte 0,3,6, 8,7,6
ap_sx   .byte 0                 ; 1 = hacia la izquierda
ap_sy   .byte 0                 ; 1 = hacia arriba
ap_ax   .byte 0                 ; |dx| / 2 y |dy| / 4
ap_ay   .byte 0
ap_big  .byte 0
ap_small .byte 0
; huida del tirador: segun la direccion hacia el jugador (0-7), 5 direcciones
; para alejarse en orden de preferencia: la opuesta, sus dos vecinas y las
; dos de costado
huida   .byte 4,6,5,7,3, 5,4,3,6,2, 6,7,4,1,5, 7,1,6,0,4
        .byte 0,2,1,3,7, 1,0,7,2,6, 2,3,0,5,1, 3,5,2,4,0
ti_dir  .byte 0                 ; auxiliar (libre_dir)
; bits de cada missile en los bytes de PMG+$300: M0 = bala de J1, M1 = J2,
; M2/M3 = balas enemigas 0/1
bits_m  .byte %00000011,%00001100,%00110000,%11000000

; --- celulas del nivel (celulas.asm), hasta MAXCEL ---
MAXCEL  = 18            ; en todo el nivel (el HUD muestra hasta 18)
ncel    .byte 0
celrest .byte 0         ; celulas que faltan recoger
cel_parte :MAXCEL .byte 0       ; parte del nivel donde esta
cel_x   :MAXCEL .byte 0
cel_y   :MAXCEL .byte 0
cel_viva :MAXCEL .byte 0

; direcciones de Kaiju (medidas en el original): desplazamiento en casillas
; 0 arr-izq, 1 arr, 2 izq, 3 aba-izq, 4 aba-der, 5 aba, 6 der, 7 arr-der, 8 quieto
dir_dx  .byte $FF,0,$FF,$FF,1,0,1,1,0
dir_dy  .byte $FF,$FF,0,1,1,1,0,$FF,0
; persecucion: direccion segun (signo dy + 1) * 3 + (signo dx + 1)
persigue .byte 0,1,7, 2,8,6, 3,5,4

; efectos de sonido (sonido.asm): AUDF1 = base + paso * k, k = 0..7
SND_DISPARO = 0
SND_RECOGER = 1
SND_GOLPE   = 2
SND_TIRO    = 3
SND_EXPLOSION = 4       ; ruido que va bajando
SND_IMPACTO = 5         ; robot herido: zumbido que va subiendo
snd_base .byte 20,60,40,90,30,50
snd_paso .byte 6,$FC,12,$FA,24,$F8
snd_dist .byte $A0,$A0,$80,$A0,$80,$C0  ; $A = tono puro, $8 = ruido

txt_level .byte $28,$29,$2A,$29,$28     ; "LEVEL" con la fuente de Kaiju
hud_dirty .byte 1       ; 1 = hay que redibujar el HUD
; sprite de la bala (missiles 0+1, 2 cols x 4 filas): cada pareja de
; bits se enciende en bloque, sin pixeles sueltos. M1 = col 0 (bits 3-2),
; M0 = col 1 (bits 1-0). Valores por fila: $0 vacio, $3 der, $C izq,
; $F bloque. Dibujalo en editor-sprite.html (panel Bala) y pega aqui
; el .byte exportado.
bala_icono .byte %0000
        .byte %1111
        .byte %1111
        .byte %0000
; bala_icono para un missile de ancho doble (SIZEM): la columna izquierda en
; los bits altos de cada pareja y la derecha en los bajos, repetido para los
; 4 missiles (se enmascara con bits_m). La arma iniciar
bala_m  :4 .byte 0

; poses del jugador (kaiju_graficos.asm). Cada pose es P0 (24 bytes) seguido
; de P1 (24 bytes); dibujar_jugador cuenta con eso. Las B van tras las A.
POSE_QUIETO_DER = 0
POSE_CAMINA_A   = 1     ; + paso: 2 = camina B
POSE_ARRIBA_A   = 3     ; + paso: 4 = de espaldas B
POSE_QUIETO_IZQ = 5
; las de J2 (kaiju2_graficos.asm) van POSES_J2 lugares despues
POSES_J2 = 6
poses_lo .byte <kaiju_quieto_der_p0,<kaiju_camina_a_p0,<kaiju_camina_b_p0
        .byte <kaiju_arriba_a_p0,<kaiju_arriba_b_p0,<kaiju_quieto_izq_p0
        .byte <kaiju2_quieto_der_p0,<kaiju2_camina_a_p0,<kaiju2_camina_b_p0
        .byte <kaiju2_arriba_a_p0,<kaiju2_arriba_b_p0,<kaiju2_quieto_izq_p0
poses_hi .byte >kaiju_quieto_der_p0,>kaiju_camina_a_p0,>kaiju_camina_b_p0
        .byte >kaiju_arriba_a_p0,>kaiju_arriba_b_p0,>kaiju_quieto_izq_p0
        .byte >kaiju2_quieto_der_p0,>kaiju2_camina_a_p0,>kaiju2_camina_b_p0
        .byte >kaiju2_arriba_a_p0,>kaiju2_arriba_b_p0,>kaiju2_quieto_izq_p0
        .if kaiju2_quieto_der_p1<>kaiju2_quieto_der_p0+24 .or kaiju2_camina_a_p1<>kaiju2_camina_a_p0+24 .or kaiju2_camina_b_p1<>kaiju2_camina_b_p0+24
        .error "kaiju2_graficos.asm: cada pose debe tener P1 justo despues de P0"
        .endif
        .if kaiju2_arriba_a_p1<>kaiju2_arriba_a_p0+24 .or kaiju2_arriba_b_p1<>kaiju2_arriba_b_p0+24 .or kaiju2_quieto_izq_p1<>kaiju2_quieto_izq_p0+24
        .error "kaiju2_graficos.asm: cada pose debe tener P1 justo despues de P0"
        .endif
        .if kaiju_quieto_der_p1<>kaiju_quieto_der_p0+24 .or kaiju_camina_a_p1<>kaiju_camina_a_p0+24 .or kaiju_camina_b_p1<>kaiju_camina_b_p0+24
        .error "kaiju_graficos.asm: cada pose debe tener P1 justo despues de P0"
        .endif
        .if kaiju_arriba_a_p1<>kaiju_arriba_a_p0+24 .or kaiju_arriba_b_p1<>kaiju_arriba_b_p0+24 .or kaiju_quieto_izq_p1<>kaiju_quieto_izq_p0+24
        .error "kaiju_graficos.asm: cada pose debe tener P1 justo despues de P0"
        .endif

; direccion de cada fila de la pantalla (fila 0 = HUD, 1-23 = nivel)
filas_lo :24 dta l(PANTALLA+#*40)
filas_hi :24 dta h(PANTALLA+#*40)

; lista de pantalla (se copia a DLIST): 24 lineas en blanco, 25 filas en
; ANTIC 4 (la 0 es el HUD de J1, la 24 el de J2) y salto con espera del VBI
dl_datos .byte $70,$70,$70
        .byte $44,<PANTALLA,>PANTALLA   ; ANTIC 4 + LMS
        :23 .byte $04                   ; ANTIC 4 (multicolor)
        .byte $44,<HUD2,>HUD2           ; fila 24: HUD de J2
        .byte $41,<DLIST,>DLIST
dl_fin


; caracteres del tirador (ANTIC 4, 2 x 2 como los otros robots), copiados a
; FUENTE desde el codigo $40: $40-$43 mirando a la izquierda, $44-$47 su
; 2a fase, $50-$57 lo mismo mirando a la derecha (dibujar_robot suma $10/4)
fuente_tirador          .byte $0F,$3F,$35,$36,$35,$0F,$03,$AF   ; $40 izq. fase 0
                        .byte $F0,$FC,$5C,$9C,$5C,$F0,$C0,$FF   ; $41 izq. fase 0
                        .byte $AF,$03,$3F,$33,$33,$3F,$30,$F0   ; $42 izq. fase 0
                        .byte $FF,$C3,$FC,$CC,$CC,$FC,$0C,$0F   ; $43 izq. fase 0
                        .byte $0F,$3F,$35,$35,$35,$0F,$03,$2F   ; $44 izq. fase 1
                        .byte $F0,$FC,$5C,$AC,$5C,$F0,$C0,$FF   ; $45 izq. fase 1
                        .byte $2F,$03,$3F,$33,$33,$3F,$C0,$C0   ; $46 izq. fase 1
                        .byte $FF,$C3,$FC,$CC,$CC,$FC,$03,$03   ; $47 izq. fase 1
                        .byte $0F,$3F,$35,$36,$35,$0F,$03,$FF   ; $50 der. fase 0
                        .byte $F0,$FC,$5C,$9C,$5C,$F0,$C0,$FA   ; $51 der. fase 0
                        .byte $FF,$C3,$3F,$33,$33,$3F,$30,$F0   ; $52 der. fase 0
                        .byte $FA,$C0,$FC,$CC,$CC,$FC,$0C,$0F   ; $53 der. fase 0
                        .byte $0F,$3F,$35,$3A,$35,$0F,$03,$FF   ; $54 der. fase 1
                        .byte $F0,$FC,$5C,$5C,$5C,$F0,$C0,$F8   ; $55 der. fase 1
                        .byte $FF,$C3,$3F,$33,$33,$3F,$C0,$C0   ; $56 der. fase 1
                        .byte $F8,$C0,$FC,$CC,$CC,$FC,$03,$03   ; $57 der. fase 1

; explosion de un robot destruido (enemigos.asm): 2 x 2 caracteres en
; EXPLO..EXPLO+3 (fase 0) y +4..+7 (fase 1), dibujados en inverso (pixel 11 =
; COLOR3). EXPLO_PASOS pasos en total; a la mitad cambia a la fase 1
EXPLO   = $48           ; $48-$4F: entre los tiradores, pasables y no solidos
EXPLO_PASOS = 12
GOLPE_PASOS = 8         ; parpadeo de un robot herido (cambia el bit de inverso)
fuente_explosion        .byte $00,$00,$02,$00,$0B,$2F,$0F,$2F   ; $48 fase 0
                        .byte $00,$00,$00,$88,$E0,$F8,$F0,$F8   ; $49 fase 0
                        .byte $2F,$0F,$2F,$0B,$20,$00,$00,$00   ; $4A fase 0
                        .byte $F8,$F0,$F8,$E0,$80,$88,$00,$00   ; $4B fase 0
                        .byte $80,$20,$08,$42,$23,$0C,$8C,$31   ; $4C fase 1
                        .byte $02,$42,$18,$20,$04,$C8,$30,$0E   ; $4D fase 1
                        .byte $B0,$0C,$23,$08,$12,$08,$21,$80   ; $4E fase 1
                        .byte $4C,$30,$31,$20,$08,$21,$02,$00   ; $4F fase 1

; tabla para espejar el sprite (bit invertido): revtab[$3C] = $3C, etc.
revtab  .byte $00,$80,$40,$C0,$20,$A0,$60,$E0
        .byte $10,$90,$50,$D0,$30,$B0,$70,$F0
        .byte $08,$88,$48,$C8,$28,$A8,$68,$E8
        .byte $18,$98,$58,$D8,$38,$B8,$78,$F8
        .byte $04,$84,$44,$C4,$24,$A4,$64,$E4
        .byte $14,$94,$54,$D4,$34,$B4,$74,$F4
        .byte $0C,$8C,$4C,$CC,$2C,$AC,$6C,$EC
        .byte $1C,$9C,$5C,$DC,$3C,$BC,$7C,$FC
        .byte $02,$82,$42,$C2,$22,$A2,$62,$E2
        .byte $12,$92,$52,$D2,$32,$B2,$72,$F2
        .byte $0A,$8A,$4A,$CA,$2A,$AA,$6A,$EA
        .byte $1A,$9A,$5A,$DA,$3A,$BA,$7A,$FA
        .byte $06,$86,$46,$C6,$26,$A6,$66,$E6
        .byte $16,$96,$56,$D6,$36,$B6,$76,$F6
        .byte $0E,$8E,$4E,$CE,$2E,$AE,$6E,$EE
        .byte $1E,$9E,$5E,$DE,$3E,$BE,$7E,$FE
        .byte $01,$81,$41,$C1,$21,$A1,$61,$E1
        .byte $11,$91,$51,$D1,$31,$B1,$71,$F1
        .byte $09,$89,$49,$C9,$29,$A9,$69,$E9
        .byte $19,$99,$59,$D9,$39,$B9,$79,$F9
        .byte $05,$85,$45,$C5,$25,$A5,$65,$E5
        .byte $15,$95,$55,$D5,$35,$B5,$75,$F5
        .byte $0D,$8D,$4D,$CD,$2D,$AD,$6D,$ED
        .byte $1D,$9D,$5D,$DD,$3D,$BD,$7D,$FD
        .byte $03,$83,$43,$C3,$23,$A3,$63,$E3
        .byte $13,$93,$53,$D3,$33,$B3,$73,$F3
        .byte $0B,$8B,$4B,$CB,$2B,$AB,$6B,$EB
        .byte $1B,$9B,$5B,$DB,$3B,$BB,$7B,$FB
        .byte $07,$87,$47,$C7,$27,$A7,$67,$E7
        .byte $17,$97,$57,$D7,$37,$B7,$77,$F7
        .byte $0F,$8F,$4F,$CF,$2F,$AF,$6F,$EF
        .byte $1F,$9F,$5F,$DF,$3F,$BF,$7F,$FF
