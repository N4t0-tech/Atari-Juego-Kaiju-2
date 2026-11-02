; kaiju_titulo.asm - pantalla de titulo de Kaiju ("SUPPA ROBOTTO / PRESS BUTTON")
; Imagen MicroPainter (kaiju_titulo.mic = SUNSET.MIC original): ANTIC modo E,
; 160 x 240 pixeles, 4 colores, 40 bytes por linea; 9600 bytes + 4 de color.
; El juego original solo mostraba las primeras 196 lineas (7840 bytes) y
; debajo una linea de texto en modo 7 (kaiju_txt_muviron + kaiju_txt_soulbattery).

KAIJU_TITULO_COLOR0     = $C8   ; pixel 01
KAIJU_TITULO_COLOR1     = $DE   ; pixel 10
KAIJU_TITULO_COLOR2     = $CC   ; pixel 11

; Va comprimida (kaiju_titulo.lz, de comprimir_titulo.py: 7840 -> ~2.9 KB) y
; modo_titulo la descomprime encima de MAPAS, que en el titulo no se usa.
; Una linea de 40 bytes no puede cruzar un limite de 4 KB: empieza en $4010
; para que la linea 102 caiga justo en $5000 (el segundo LMS de DLIST_T).
kaiju_titulo1           = $4010                 ; lineas 0-101
kaiju_titulo2           = kaiju_titulo1+102*40  ; lineas 102-195 ($5000)
KAIJU_TITULO_FIN        = kaiju_titulo2+94*40

; Este archivo va en ZONA_NIVELES (main.asm), antes de los niveles.
kaiju_titulo_z          ins 'kaiju_titulo.lz'
