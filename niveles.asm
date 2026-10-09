; niveles.asm - niveles del juego, generado con editor-sprite.html (panel
; Niveles). Para cambiarlos: abrir este archivo en el editor, editar y
; exportar de nuevo.
;
; Cada nivel:
;   .byte parte, x, y   inicio del jugador: parte, HPOS y linea PMG de su esquina
;   .byte ancho, alto   partes del nivel (cuadricula, hasta MAXPARTES en total)
;   cada parte, fila por fila de la cuadricula: 23 filas del mapa (filas 1-23
;     de la pantalla, 40 caracteres cada una), comprimidas: $FF, n, v = n
;     veces el caracter v; otro byte va tal cual
;   .byte robots, celulas (de todo el nivel)
;   robots, 12 bytes: parte, x, y (casilla de arriba a la izquierda de sus
;     2 x 2), direccion A, direccion B, pasos, caracter ($9C/$1C, tirador
;     $C0/$40), vida y la zona de vigilancia: columnas x0-x1, filas y0-y1
;   celulas, 3 bytes: parte, x, y

NUM_NIVELES = 1

niveles                 .word nivel1

nivel1                  ; Primer nivel
                        .byte 0,124,112                         ; inicio del jugador: parte, x, y
                        .byte 2,1                               ; partes: ancho, alto
                        ; parte 0 (columna 0, fila 0)
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 2
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 3
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 4
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 5
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 6
                        .byte 3,$FF,38,0,3                      ; fila 7
                        .byte 3,$FF,4,0,$FF,10,4,$FF,10,0,$FF,10,4,$FF,4,0,3 ; fila 8
                        .byte 3,$FF,38,0,3                      ; fila 9
                        .byte 3,$FF,39,0                        ; fila 10
                        .byte 3,$FF,39,0                        ; fila 11
                        .byte 3,$FF,39,0                        ; fila 12
                        .byte 3,$FF,39,0                        ; fila 13
                        .byte 3,$FF,38,0,3                      ; fila 14
                        .byte 3,$FF,4,0,$FF,10,4,$FF,10,0,$FF,10,4,$FF,4,0,3 ; fila 15
                        .byte 3,$FF,38,0,3                      ; fila 16
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 17
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 18
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 19
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 20
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 21
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 22
                        .byte 3,$FF,38,2,3                      ; fila 23
                        ; parte 1 (columna 1, fila 0)
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 2
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 3
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 4
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 5
                        .byte 3,$FF,7,0,$FF,24,4,$FF,7,0,3      ; fila 6
                        .byte 3,$FF,7,0,5,5,$FF,14,0,5,5,$FF,13,0,3 ; fila 7
                        .byte 3,$FF,7,0,5,5,$FF,14,0,5,5,$FF,13,0,3 ; fila 8
                        .byte 3,$FF,7,0,5,5,$FF,14,0,5,5,$FF,13,0,3 ; fila 9
                        .byte $FF,8,0,5,5,$FF,29,0,3            ; fila 10
                        .byte $FF,8,0,5,5,$FF,29,0,3            ; fila 11
                        .byte $FF,8,0,5,5,$FF,29,0,3            ; fila 12
                        .byte $FF,8,0,5,5,$FF,29,0,3            ; fila 13
                        .byte 3,$FF,7,0,5,5,$FF,14,0,5,5,$FF,13,0,3 ; fila 14
                        .byte 3,$FF,7,0,5,5,$FF,14,0,5,5,$FF,13,0,3 ; fila 15
                        .byte 3,$FF,7,0,5,5,$FF,14,0,5,5,$FF,13,0,3 ; fila 16
                        .byte 3,$FF,7,0,$FF,24,4,$FF,7,0,3      ; fila 17
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 18
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 19
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 20
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 21
                        .byte 3,$FF,7,0,5,5,$FF,20,0,5,5,$FF,7,0,3 ; fila 22
                        .byte 3,$FF,38,2,3                      ; fila 23
                        .byte 5,9                               ; robots, celulas
                        .byte 0,8,4,6,2,16,$9C,1,0,18,1,7       ; robot 0
                        .byte 0,30,18,2,6,16,$C0,1,21,39,16,23  ; robot 1
                        .byte 1,12,3,6,2,24,$9C,2,0,39,1,5      ; robot 2
                        .byte 1,16,11,3,0,4,$C0,1,10,23,7,16    ; robot 3
                        .byte 1,12,19,6,2,16,$9C,1,6,19,15,23   ; robot 4
                        .byte 0,3,3,0,35,3,0,3,20,0,35,20,0,9,11,0,29,11,1,34,3,1,34,20,1,28,11 ; celulas (parte, x, y)
