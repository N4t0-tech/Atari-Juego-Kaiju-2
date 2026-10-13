; hardware.asm - direcciones del Atari 8-bit usadas por el juego

; --- variables del sistema (shadow registers del OS) ---
SDMCTL  = $022F         ; shadow de DMACTL
GPRIOR  = $026F         ; shadow de PRIOR (prioridades y color de missiles)
STICK0  = $0278         ; joystick 1 (bit en 0 = presionado)
STRIG0  = $0284         ; boton de disparo (0 = presionado)
STICK1  = $0279         ; joystick 2 (STICK0,x / STRIG0,x con X = jugador)
STRIG1  = $0285
PCOLR0  = $02C0         ; color del jugador 0
PCOLR1  = $02C1         ; color del jugador 1
PCOLR2  = $02C2         ; color del player 2 (cuerpo de J2)
PCOLR3  = $02C3         ; color del player 3 (contorno de J2)
COLOR0  = $02C4         ; color 0 del playfield (pixel 01 en ANTIC 4/E)
COLOR1  = $02C5         ; texto del modo texto (GR.0)
COLOR3  = $02C7         ; color 3 (lo usan los missiles con GPRIOR bit 4)
COLOR2  = $02C6         ; fondo del modo texto (GR.0)
COLOR4  = $02C8         ; fondo de modos graficos y borde
CHBAS   = $02F4         ; shadow de CHBASE (pagina de la fuente)
RTCLOK  = $14           ; contador de frames (byte bajo)
SDLSTL  = $0230         ; shadow de la lista de pantalla (byte bajo)
SDLSTH  = $0231         ; (byte alto)
RAMTOP  = $6A           ; pagina donde termina la RAM (el OS pone su pantalla debajo)
BASICF  = $03F8         ; XL/XE: 1 = BASIC apagado (el OS lo respeta al RESET)

; --- CIO (para reabrir la pantalla del OS al apagar el BASIC) ---
CIOV    = $E456         ; llamada a CIO (X = IOCB * 16)
ICCOM   = $0342         ; comando del IOCB
ICBAL   = $0344         ; direccion del buffer / nombre (bajo, alto)
ICBAH   = $0345
ICAX1   = $034A         ; auxiliares (modo de apertura)
ICAX2   = $034B

; --- GTIA / ANTIC ---
HPOSP0  = $D000         ; posicion horizontal del jugador 0
HPOSP1  = $D001         ; posicion horizontal del jugador 1
HPOSP2  = $D002         ; posicion horizontal del player 2 (cuerpo de J2)
HPOSP3  = $D003         ; posicion horizontal del player 3 (contorno de J2)
HPOSM0  = $D004         ; missile 0: bala de J1 (HPOSM0,x con X = jugador)
HPOSM1  = $D005         ; missile 1: bala de J2
HPOSM2  = $D006         ; missiles 2 y 3: balas enemigas
HPOSM3  = $D007
SIZEM   = $D00C         ; ancho de los missiles (2 bits cada uno, 01 = doble)
GRACTL  = $D01D         ; activa jugadores y missiles
PMBASE  = $D407         ; pagina base de la memoria PMG

; --- ROM ---
FUENTE_ROM = $E000      ; fuente del sistema (1 KB)

; --- PIA ---
PORTB   = $D301         ; XL/XE: bit 1 = 1 apaga el BASIC (bit 0 = ROM del OS)

; --- POKEY (sonido) ---
AUDF1   = $D200         ; canal 1: frecuencia (valor mayor = tono mas grave)
AUDC1   = $D201         ; canal 1: distorsion (4 bits altos) y volumen (bajos)

; --- pagina cero ($CB-$D1 libres para programas de usuario) ---
ptr     = $CB           ; puntero de 2 bytes (pose del jugador, nivel)
ptr2    = $CD           ; puntero de 2 bytes (pantalla)
; $D4-$DB: area del punto flotante, libre (el juego no usa el paquete FP)
ptr3    = $D4           ; PMG: cuerpo del jugador (dibujar_jugador)
ptr4    = $D6           ; pose + 24 (contorno)
ptr5    = $D8           ; PMG: contorno del jugador

; --- memoria del juego ---
PMG     = $8000         ; bloque PMG a 1 linea (2 KB, alineado a 2 KB):
                        ; +$300 missiles, +$400 P0, +$500 P1, +$600 P2, +$700 P3
FUENTE  = $8800         ; fuente del juego (1 KB, alineada a 1 KB)
PANTALLA = $8C00        ; 24 filas x 40: fila 0 HUD de J1, 1-23 nivel (960 bytes)
DLIST   = $8FC0         ; lista de pantalla del juego (35 bytes, no cruza 1 KB)
DLIST_T = $9000         ; lista de pantalla del titulo (209 bytes)
HUD2    = $90D8         ; fila 24: HUD del jugador 2 (40 bytes, hasta $90FF)
ZONA_NIVELES = $9100    ; niveles.asm, hasta ZONA_NIVELES_FIN (~11 KB). Es RAM
ZONA_NIVELES_FIN = $BC00 ; porque apagar_basic (main.asm) apaga el BASIC
                        ; ($A000-$BFFF) y lleva la pantalla del OS a $BC20
                        ; el programa ($2000 en adelante) termina antes de $6000
