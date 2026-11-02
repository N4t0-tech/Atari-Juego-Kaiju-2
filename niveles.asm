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

nivel1                  ; Nivel pegado (corregido para abrirlo)
                        .byte 1,124,56                          ; inicio del jugador: parte, x, y
                        .byte 3,2                               ; partes: ancho, alto
                        ; parte 0 (columna 0, fila 0)
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,38,4,3                      ; fila 2
                        .byte 3,4,$FF,30,2,3,$FF,6,4,3          ; fila 3
                        .byte 3,4,3,$FF,4,0,5,5,$FF,14,0,5,5,$FF,7,0,3,$FF,6,4,3 ; fila 4
                        .byte 3,4,3,$FF,4,0,5,5,$FF,14,0,5,5,$FF,7,0,3,$FF,6,4,3 ; fila 5
                        .byte 3,4,3,$FF,4,0,5,5,$FF,14,0,5,5,$FF,7,0,3,$FF,6,4,3 ; fila 6
                        .byte 3,4,3,$FF,4,0,5,5,$FF,14,0,5,5,$FF,7,0,3,$FF,6,4,3 ; fila 7
                        .byte 3,4,3,$FF,4,0,$FF,20,2,3,$FF,4,0,3,$FF,6,4,3 ; fila 8
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,4,0,3,$FF,6,2,3 ; fila 9
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,12,0 ; fila 10
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,12,0 ; fila 11
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,12,0 ; fila 12
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,12,0 ; fila 13
                        .byte 3,4,3,$FF,4,0,$FF,15,2,3,$FF,4,4,$FF,12,2,3 ; fila 14
                        .byte 3,4,3,$FF,4,0,5,5,$FF,13,0,3,$FF,16,4,3 ; fila 15
                        .byte 3,4,3,$FF,4,0,5,5,$FF,13,0,3,$FF,8,4,0,$FF,7,4,3 ; fila 16
                        .byte 3,4,3,$FF,4,0,5,5,$FF,13,0,3,$FF,6,4,$FF,4,0,$FF,6,4,3 ; fila 17
                        .byte 3,4,3,$FF,4,0,5,5,$FF,13,0,3,$FF,4,4,$FF,7,0,$FF,5,4,3 ; fila 18
                        .byte 3,4,$FF,15,2,3,$FF,4,5,3,4,4,$FF,9,0,$FF,5,4,3 ; fila 19
                        .byte 3,$FF,16,4,3,$FF,4,5,3,4,4,$FF,8,0,$FF,6,4,3 ; fila 20
                        .byte 3,$FF,16,4,3,$FF,4,0,3,4,4,4,0,0,4,4,0,0,$FF,7,4,3 ; fila 21
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 22
                        .byte 3,$FF,16,2,$FF,6,0,$FF,16,2,3     ; fila 23
                        ; parte 1 (columna 1, fila 0)
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,14,5,4,$FF,8,0,4,$FF,14,5,3 ; fila 2
                        .byte 3,$FF,14,5,4,$FF,8,0,4,$FF,14,5,3 ; fila 3
                        .byte 3,$FF,14,5,4,$FF,8,0,4,$FF,14,5,3 ; fila 4
                        .byte 3,$FF,14,5,4,$FF,8,0,4,$FF,14,5,3 ; fila 5
                        .byte 3,$FF,14,5,4,$FF,8,0,4,$FF,14,5,3 ; fila 6
                        .byte 3,$FF,14,5,$FF,10,0,$FF,14,5,3    ; fila 7
                        .byte 3,$FF,15,5,$FF,8,0,$FF,15,5,3     ; fila 8
                        .byte 3,0,$FF,36,5,2,2                  ; fila 9
                        .byte 0,0,$FF,36,5,0,0                  ; fila 10
                        .byte 0,0,$FF,14,5,4,4,$FF,4,0,4,4,$FF,14,5,0,0 ; fila 11
                        .byte 0,0,$FF,14,5,4,$FF,6,0,4,$FF,14,5,0,0 ; fila 12
                        .byte 0,0,$FF,14,5,$FF,8,0,$FF,14,5,0,0 ; fila 13
                        .byte 3,0,$FF,14,5,$FF,8,0,$FF,14,5,2,2 ; fila 14
                        .byte 3,$FF,15,5,4,$FF,6,0,4,$FF,15,5,3 ; fila 15
                        .byte 3,$FF,15,5,4,4,$FF,4,0,4,4,$FF,15,5,3 ; fila 16
                        .byte 3,$FF,38,5,3                      ; fila 17
                        .byte 3,$FF,38,5,3                      ; fila 18
                        .byte 3,$FF,38,5,3                      ; fila 19
                        .byte 3,$FF,38,5,3                      ; fila 20
                        .byte 3,$FF,38,5,3                      ; fila 21
                        .byte 3,$FF,16,5,3,$FF,4,0,3,$FF,16,5,3 ; fila 22
                        .byte 3,$FF,16,2,$FF,6,0,$FF,16,2,3     ; fila 23
                        ; parte 2 (columna 2, fila 0)
                        .byte 3,$FF,38,2,3                      ; fila 1
                        .byte 3,$FF,38,4,3                      ; fila 2
                        .byte 3,$FF,38,4,3                      ; fila 3
                        .byte 3,$FF,28,4,0,$FF,9,4,3            ; fila 4
                        .byte 3,$FF,27,4,0,0,0,$FF,8,4,3        ; fila 5
                        .byte 3,$FF,26,4,$FF,7,0,$FF,5,4,3      ; fila 6
                        .byte 3,$FF,26,4,$FF,7,0,$FF,5,4,3      ; fila 7
                        .byte 3,$FF,24,4,$FF,10,0,$FF,4,4,3     ; fila 8
                        .byte $FF,22,2,3,$FF,5,4,$FF,6,0,$FF,5,4,3 ; fila 9
                        .byte $FF,22,0,3,$FF,6,4,$FF,5,0,$FF,5,4,3 ; fila 10
                        .byte $FF,22,0,3,$FF,6,4,0,0,$FF,8,4,3  ; fila 11
                        .byte $FF,22,0,3,$FF,16,4,3             ; fila 12
                        .byte $FF,22,0,3,$FF,16,4,3             ; fila 13
                        .byte $FF,17,2,3,$FF,4,0,3,$FF,16,4,3   ; fila 14
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 15
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 16
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 17
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 18
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 19
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 20
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 21
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,16,4,3 ; fila 22
                        .byte 3,$FF,16,2,$FF,6,0,$FF,16,2,3     ; fila 23
                        ; parte 3 (columna 0, fila 1)
                        .byte 3,$FF,16,2,$FF,6,0,$FF,16,2,3     ; fila 1
                        .byte 3,$FF,38,0,3                      ; fila 2
                        .byte 3,$FF,38,0,3                      ; fila 3
                        .byte 3,$FF,38,0,3                      ; fila 4
                        .byte 3,$FF,38,0,3                      ; fila 5
                        .byte 3,$FF,38,0,3                      ; fila 6
                        .byte 3,$FF,38,0,3                      ; fila 7
                        .byte 3,$FF,38,0,3                      ; fila 8
                        .byte 3,$FF,38,0,3                      ; fila 9
                        .byte 3,$FF,39,0                        ; fila 10
                        .byte 3,$FF,39,0                        ; fila 11
                        .byte 3,$FF,39,0                        ; fila 12
                        .byte 3,$FF,39,0                        ; fila 13
                        .byte 3,$FF,39,0                        ; fila 14
                        .byte 3,$FF,38,0,3                      ; fila 15
                        .byte 3,$FF,38,0,3                      ; fila 16
                        .byte 3,$FF,38,0,3                      ; fila 17
                        .byte 3,$FF,38,0,3                      ; fila 18
                        .byte 3,$FF,38,0,3                      ; fila 19
                        .byte 3,$FF,38,0,3                      ; fila 20
                        .byte 3,$FF,38,0,3                      ; fila 21
                        .byte 3,$FF,38,0,3                      ; fila 22
                        .byte 3,$FF,38,2,3                      ; fila 23
                        ; parte 4 (columna 1, fila 1)
                        .byte 3,$FF,16,2,$FF,6,0,$FF,16,2,3     ; fila 1
                        .byte 3,$FF,38,0,3                      ; fila 2
                        .byte 3,$FF,38,0,3                      ; fila 3
                        .byte 3,$FF,38,0,3                      ; fila 4
                        .byte 3,$FF,38,0,3                      ; fila 5
                        .byte 3,$FF,38,0,3                      ; fila 6
                        .byte 3,$FF,38,0,3                      ; fila 7
                        .byte 3,$FF,38,0,3                      ; fila 8
                        .byte 3,$FF,38,0,3                      ; fila 9
                        .byte $FF,40,0                          ; fila 10
                        .byte $FF,40,0                          ; fila 11
                        .byte $FF,40,0                          ; fila 12
                        .byte $FF,40,0                          ; fila 13
                        .byte $FF,40,0                          ; fila 14
                        .byte 3,$FF,38,0,3                      ; fila 15
                        .byte 3,$FF,38,0,3                      ; fila 16
                        .byte 3,$FF,38,0,3                      ; fila 17
                        .byte 3,$FF,38,0,3                      ; fila 18
                        .byte 3,$FF,38,0,3                      ; fila 19
                        .byte 3,$FF,38,0,3                      ; fila 20
                        .byte 3,$FF,38,0,3                      ; fila 21
                        .byte 3,$FF,38,0,3                      ; fila 22
                        .byte 3,$FF,38,2,3                      ; fila 23
                        ; parte 5 (columna 2, fila 1)
                        .byte 3,$FF,16,2,$FF,6,0,$FF,16,2,3     ; fila 1
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
                        .byte $FF,39,0,3                        ; fila 14
                        .byte 3,$FF,38,0,3                      ; fila 15
                        .byte 3,$FF,38,0,3                      ; fila 16
                        .byte 3,$FF,38,0,3                      ; fila 17
                        .byte 3,$FF,38,0,3                      ; fila 18
                        .byte 3,$FF,38,0,3                      ; fila 19
                        .byte 3,$FF,38,0,3                      ; fila 20
                        .byte 3,$FF,38,0,3                      ; fila 21
                        .byte 3,$FF,38,0,3                      ; fila 22
                        .byte 3,$FF,38,2,3                      ; fila 23
                        .byte 2,5                               ; robots, celulas
                        .byte 2,30,7,6,2,16,$9C,1,24,37,3,12    ; robot 0
                        .byte 0,29,18,6,2,16,$9C,1,23,36,14,23  ; robot 1
                        .byte 1,19,13,2,8,11,2,19,18,0,29,5,0,19,16 ; celulas (parte, x, y)
                        .byte $FF,0,0                           ; sin salida
