; niveles.asm - niveles del juego, generado con editor-sprite.html (panel
; Niveles). Para cambiarlos: abrir este archivo en el editor, editar y
; exportar de nuevo.
;
; Cada nivel:
;   .byte x, y      inicio del jugador (HPOS y linea PMG de su esquina)
;   23 filas del mapa (filas 1-23 de la pantalla, 40 caracteres cada una),
;     comprimidas: $FF, n, v = n veces el caracter v; otro byte va tal cual
;   .byte robots, celulas
;   robots, 11 bytes: x, y (casilla de arriba a la izquierda de sus 2 x 2),
;     direccion A, direccion B, pasos, caracter ($9C rojo o $1C), vida y la
;     zona de vigilancia: columnas x0-x1, filas y0-y1
;   celulas, 2 bytes: x, y

NUM_NIVELES = 1

niveles                 .word nivel1

nivel1                  ; Primer nivel
                        .byte 124,112                           ; inicio del jugador
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 2
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 3
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 4
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 5
                        .byte 3,$FF,18,0,5,5,$FF,18,0,3         ; fila 6
                        .byte 3,$FF,38,0,3                      ; fila 7
                        .byte 3,$FF,4,0,$FF,10,4,$FF,10,0,$FF,10,4,$FF,4,0,3 ; fila 8
                        .byte 3,$FF,38,0,3                      ; fila 9
                        .byte 3,$FF,38,0,3                      ; fila 10
                        .byte 3,$FF,38,0,3                      ; fila 11
                        .byte 3,$FF,38,0,3                      ; fila 12
                        .byte 3,$FF,38,0,3                      ; fila 13
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
                        .byte 2,6                               ; robots, celulas
                        .byte 8,4,6,2,16,$9C,1,0,18,1,7         ; robot 0
                        .byte 30,18,2,6,16,$9C,1,21,39,16,23    ; robot 1
                        .byte 3,3,35,3,3,20,35,20,9,11,29,11    ; celulas (x, y)
