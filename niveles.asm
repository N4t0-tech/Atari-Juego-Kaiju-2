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
;   .byte parte, x, y   salida (2 x 2): tocarla gana el nivel; parte $FF = sin
;     salida (se gana recogiendo todas las celulas)

NUM_NIVELES = 1

niveles                 .word nivel1

nivel1                  ; Primer nivel
                        .byte 0,56,56                           ; inicio del jugador: parte, x, y
                        .byte 2,2                               ; partes: ancho, alto
                        ; parte 0 (columna 0, fila 0)
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,6,0,4,$FF,31,0,3            ; fila 2
                        .byte 3,$FF,6,0,4,$FF,31,0,3            ; fila 3
                        .byte 3,$FF,6,0,4,$FF,31,0,3            ; fila 4
                        .byte 3,$FF,6,0,4,$FF,31,0,3            ; fila 5
                        .byte 3,$FF,6,5,4,$FF,10,5,$FF,21,4,3   ; fila 6
                        .byte 3,$FF,6,5,4,$FF,10,0,4,$FF,11,0,4,$FF,8,0,3 ; fila 7
                        .byte 3,$FF,6,0,5,$FF,10,0,4,$FF,11,0,4,$FF,8,0,3 ; fila 8
                        .byte 3,$FF,6,0,5,$FF,9,0,5,5,5,$FF,10,0,4,$FF,6,0,5,5,3 ; fila 9
                        .byte 3,$FF,6,0,5,$FF,9,0,5,5,5,$FF,10,0,4,$FF,6,0,5,0,0 ; fila 10
                        .byte 3,$FF,6,0,5,$FF,9,0,5,5,5,$FF,10,0,4,$FF,6,0,5,0,0 ; fila 11
                        .byte 3,$FF,6,0,5,$FF,9,0,5,5,5,$FF,10,0,4,$FF,6,0,5,0,0 ; fila 12
                        .byte 3,$FF,6,0,5,$FF,9,0,5,5,5,$FF,10,0,4,$FF,6,0,5,0,0 ; fila 13
                        .byte 3,$FF,6,0,5,$FF,10,0,4,$FF,11,0,4,$FF,6,0,5,5,3 ; fila 14
                        .byte 3,$FF,6,0,5,$FF,10,0,4,$FF,11,0,4,$FF,8,0,3 ; fila 15
                        .byte 3,$FF,6,0,4,$FF,6,0,$FF,12,4,$FF,4,5,4,$FF,8,0,3 ; fila 16
                        .byte 3,$FF,6,0,4,$FF,6,0,4,$FF,15,0,5,$FF,8,0,3 ; fila 17
                        .byte 3,$FF,6,0,4,$FF,6,0,4,$FF,15,0,5,$FF,8,0,3 ; fila 18
                        .byte 3,$FF,6,0,4,$FF,6,0,4,$FF,15,0,5,$FF,8,0,3 ; fila 19
                        .byte 3,$FF,6,0,4,$FF,6,0,4,$FF,15,0,5,$FF,8,0,3 ; fila 20
                        .byte 3,$FF,6,0,4,$FF,6,0,4,$FF,9,5,$FF,6,0,5,$FF,8,0,3 ; fila 21
                        .byte 3,$FF,6,0,4,$FF,6,0,4,5,$FF,7,0,5,$FF,6,0,5,$FF,8,0,3 ; fila 22
                        .byte 3,$FF,15,2,$FF,7,0,$FF,16,2,3     ; fila 23
                        ; parte 1 (columna 1, fila 0)
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,38,0,3                      ; fila 2
                        .byte 3,$FF,38,0,3                      ; fila 3
                        .byte 3,$FF,38,0,3                      ; fila 4
                        .byte 3,$FF,38,0,3                      ; fila 5
                        .byte 3,$FF,38,0,3                      ; fila 6
                        .byte 3,$FF,38,0,3                      ; fila 7
                        .byte 3,$FF,38,0,3                      ; fila 8
                        .byte 3,$FF,38,0,3                      ; fila 9
                        .byte $FF,39,0,3                        ; fila 10
                        .byte $FF,39,0,3                        ; fila 11
                        .byte $FF,39,0,3                        ; fila 12
                        .byte $FF,39,0,3                        ; fila 13
                        .byte 3,$FF,38,0,3                      ; fila 14
                        .byte 3,$FF,38,0,3                      ; fila 15
                        .byte 3,$FF,38,0,3                      ; fila 16
                        .byte 3,$FF,38,0,3                      ; fila 17
                        .byte 3,$FF,38,0,3                      ; fila 18
                        .byte 3,$FF,38,0,3                      ; fila 19
                        .byte 3,$FF,38,0,3                      ; fila 20
                        .byte 3,$FF,38,0,3                      ; fila 21
                        .byte 3,$FF,38,0,3                      ; fila 22
                        .byte 3,$FF,38,2,3                      ; fila 23
                        ; parte 2 (columna 0, fila 1)
                        .byte 3,$FF,15,2,$FF,7,0,$FF,16,2,3     ; fila 1
                        .byte 3,$FF,38,0,3                      ; fila 2
                        .byte 3,$FF,38,0,3                      ; fila 3
                        .byte 3,$FF,38,0,3                      ; fila 4
                        .byte 3,$FF,38,0,3                      ; fila 5
                        .byte 3,$FF,38,0,3                      ; fila 6
                        .byte 3,$FF,38,0,3                      ; fila 7
                        .byte 3,$FF,38,0,3                      ; fila 8
                        .byte 3,$FF,38,0,3                      ; fila 9
                        .byte 3,$FF,38,0,3                      ; fila 10
                        .byte 3,$FF,38,0,3                      ; fila 11
                        .byte 3,$FF,38,0,3                      ; fila 12
                        .byte 3,$FF,38,0,3                      ; fila 13
                        .byte 3,$FF,38,0,3                      ; fila 14
                        .byte 3,$FF,38,0,3                      ; fila 15
                        .byte 3,$FF,38,0,3                      ; fila 16
                        .byte 3,$FF,38,0,3                      ; fila 17
                        .byte 3,$FF,38,0,3                      ; fila 18
                        .byte 3,$FF,38,0,3                      ; fila 19
                        .byte 3,$FF,38,0,3                      ; fila 20
                        .byte 3,$FF,38,0,3                      ; fila 21
                        .byte 3,$FF,38,0,3                      ; fila 22
                        .byte 3,$FF,38,2,3                      ; fila 23
                        ; parte 3 (columna 1, fila 1)
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,38,0,3                      ; fila 2
                        .byte 3,$FF,38,0,3                      ; fila 3
                        .byte 3,$FF,38,0,3                      ; fila 4
                        .byte 3,$FF,38,0,3                      ; fila 5
                        .byte 3,$FF,38,0,3                      ; fila 6
                        .byte 3,$FF,38,0,3                      ; fila 7
                        .byte 3,$FF,38,0,3                      ; fila 8
                        .byte 3,$FF,38,0,3                      ; fila 9
                        .byte 3,$FF,38,0,3                      ; fila 10
                        .byte 3,$FF,38,0,3                      ; fila 11
                        .byte 3,$FF,38,0,3                      ; fila 12
                        .byte 3,$FF,38,0,3                      ; fila 13
                        .byte 3,$FF,38,0,3                      ; fila 14
                        .byte 3,$FF,38,0,3                      ; fila 15
                        .byte 3,$FF,38,0,3                      ; fila 16
                        .byte 3,$FF,38,0,3                      ; fila 17
                        .byte 3,$FF,38,0,3                      ; fila 18
                        .byte 3,$FF,38,0,3                      ; fila 19
                        .byte 3,$FF,38,0,3                      ; fila 20
                        .byte 3,$FF,38,0,3                      ; fila 21
                        .byte 3,$FF,38,0,3                      ; fila 22
                        .byte 3,$FF,38,2,3                      ; fila 23
                        .byte 6,6                               ; robots, celulas
                        .byte 0,3,17,1,5,31,$9C,1,1,6,10,18     ; robot 0
                        .byte 0,11,3,6,2,76,$9C,1,8,38,2,5      ; robot 1
                        .byte 0,12,10,6,2,19,$C0,1,8,17,7,15    ; robot 2
                        .byte 0,24,10,6,2,31,64,1,19,29,7,15    ; robot 3
                        .byte 0,34,11,5,1,28,28,1,31,38,7,22    ; robot 4
                        .byte 0,19,18,6,2,32,$9C,1,15,29,17,22  ; robot 5
                        .byte 0,36,3,0,16,18,0,28,7,0,34,20,0,10,20,0,3,20 ; celulas (parte, x, y)
                        .byte $FF,0,0                           ; sin salida
