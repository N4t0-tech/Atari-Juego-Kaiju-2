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
                        .byte 1,124,56                          ; inicio del jugador: parte, x, y
                        .byte 3,3                               ; partes: ancho, alto
                        ; parte 0 (columna 0, fila 0)
                        .byte 3,$FF,39,2                        ; fila 1
                        .byte 3,$FF,39,4                        ; fila 2
                        .byte 3,4,$FF,30,2,3,$FF,7,4            ; fila 3
                        .byte 3,4,3,$FF,4,0,5,5,$FF,14,0,5,5,$FF,7,0,3,$FF,7,4 ; fila 4
                        .byte 3,4,3,$FF,4,0,5,5,$FF,14,0,5,5,$FF,7,0,3,$FF,7,4 ; fila 5
                        .byte 3,4,3,$FF,4,0,5,5,$FF,14,0,5,5,$FF,7,0,3,$FF,7,4 ; fila 6
                        .byte 3,4,3,$FF,4,0,5,5,$FF,14,0,5,5,$FF,7,0,3,$FF,7,4 ; fila 7
                        .byte 3,4,3,$FF,4,0,$FF,20,2,3,$FF,4,0,3,$FF,7,4 ; fila 8
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,4,0,3,$FF,7,2 ; fila 9
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,12,0 ; fila 10
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,12,0 ; fila 11
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,12,0 ; fila 12
                        .byte 3,4,3,$FF,4,0,3,$FF,19,4,3,$FF,12,0 ; fila 13
                        .byte 3,4,3,$FF,4,0,$FF,15,2,3,$FF,4,4,$FF,13,2 ; fila 14
                        .byte 3,4,3,$FF,4,0,5,5,$FF,13,0,3,$FF,17,4 ; fila 15
                        .byte 3,4,3,$FF,4,0,5,5,$FF,13,0,3,$FF,8,4,0,$FF,8,4 ; fila 16
                        .byte 3,4,3,$FF,4,0,5,5,$FF,13,0,3,$FF,6,4,$FF,4,0,$FF,7,4 ; fila 17
                        .byte 3,4,3,$FF,4,0,5,5,$FF,13,0,3,$FF,4,4,$FF,7,0,$FF,6,4 ; fila 18
                        .byte 3,4,$FF,15,2,3,$FF,4,5,3,4,4,$FF,9,0,$FF,6,4 ; fila 19
                        .byte 3,$FF,16,4,3,$FF,4,5,3,4,4,$FF,8,0,$FF,7,4 ; fila 20
                        .byte 3,$FF,16,4,3,$FF,4,0,3,4,4,4,0,0,4,4,0,0,$FF,8,4 ; fila 21
                        .byte 3,$FF,16,4,3,$FF,4,0,3,$FF,17,4   ; fila 22
                        .byte 3,$FF,16,2,3,$FF,4,0,3,$FF,17,2   ; fila 23
                        ; parte 1 (columna 1, fila 0)
                        .byte $FF,40,2                          ; fila 1
                        .byte $FF,16,4,56,$FF,6,0,55,$FF,16,4   ; fila 2
                        .byte $FF,14,4,5,4,9,$FF,6,0,8,4,5,$FF,14,4 ; fila 3
                        .byte $FF,12,4,5,5,5,4,9,$FF,6,0,8,4,5,5,5,$FF,12,4 ; fila 4
                        .byte $FF,9,4,$FF,6,5,4,9,$FF,6,0,8,4,$FF,5,5,$FF,10,4 ; fila 5
                        .byte $FF,8,4,$FF,7,5,4,9,$FF,6,0,8,4,$FF,7,5,$FF,8,4 ; fila 6
                        .byte $FF,6,4,$FF,9,5,$FF,10,0,$FF,9,5,$FF,6,4 ; fila 7
                        .byte $FF,4,4,$FF,12,5,$FF,8,0,$FF,12,5,$FF,4,4 ; fila 8
                        .byte 2,2,$FF,36,5,2,2                  ; fila 9
                        .byte 0,0,$FF,36,5,0,0                  ; fila 10
                        .byte 0,0,$FF,14,5,4,4,$FF,4,0,4,4,$FF,14,5,0,0 ; fila 11
                        .byte 0,0,$FF,14,5,4,56,$FF,4,0,56,4,$FF,14,5,0,0 ; fila 12
                        .byte 0,0,$FF,14,5,$FF,8,0,$FF,14,5,0,0 ; fila 13
                        .byte 2,2,$FF,14,5,$FF,8,0,$FF,14,5,2,2 ; fila 14
                        .byte 4,4,$FF,14,5,4,54,$FF,4,0,53,4,$FF,14,5,4,4 ; fila 15
                        .byte $FF,4,4,$FF,12,5,4,4,$FF,4,0,4,4,$FF,13,5,4,4,4 ; fila 16
                        .byte $FF,7,4,$FF,28,5,$FF,5,4          ; fila 17
                        .byte $FF,8,4,$FF,24,5,$FF,8,4          ; fila 18
                        .byte $FF,11,4,$FF,19,5,$FF,10,4        ; fila 19
                        .byte $FF,13,4,$FF,15,5,$FF,12,4        ; fila 20
                        .byte $FF,15,4,$FF,10,5,$FF,15,4        ; fila 21
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,17,4     ; fila 22
                        .byte $FF,17,2,3,$FF,4,0,3,$FF,17,2     ; fila 23
                        ; parte 2 (columna 2, fila 0)
                        .byte $FF,39,2,3                        ; fila 1
                        .byte $FF,39,4,3                        ; fila 2
                        .byte $FF,39,4,3                        ; fila 3
                        .byte $FF,29,4,0,$FF,9,4,3              ; fila 4
                        .byte $FF,28,4,0,0,0,$FF,8,4,3          ; fila 5
                        .byte $FF,27,4,$FF,7,0,$FF,5,4,3        ; fila 6
                        .byte $FF,27,4,$FF,7,0,$FF,5,4,3        ; fila 7
                        .byte $FF,25,4,$FF,10,0,$FF,4,4,3       ; fila 8
                        .byte $FF,22,2,3,$FF,5,4,$FF,6,0,$FF,5,4,3 ; fila 9
                        .byte $FF,22,0,3,$FF,6,4,$FF,5,0,$FF,5,4,3 ; fila 10
                        .byte $FF,22,0,3,$FF,6,4,0,0,$FF,8,4,3  ; fila 11
                        .byte $FF,22,0,3,$FF,16,4,3             ; fila 12
                        .byte $FF,22,0,3,$FF,16,4,3             ; fila 13
                        .byte $FF,17,2,3,$FF,4,0,3,$FF,16,4,3   ; fila 14
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,16,4,3   ; fila 15
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,16,4,3   ; fila 16
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,16,4,3   ; fila 17
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,16,4,3   ; fila 18
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,16,4,3   ; fila 19
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,16,4,3   ; fila 20
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,16,4,3   ; fila 21
                        .byte $FF,17,4,3,$FF,4,0,3,$FF,16,4,3   ; fila 22
                        .byte $FF,17,2,3,$FF,4,0,3,$FF,16,2,3   ; fila 23
                        ; parte 3 (columna 0, fila 1)
                        .byte 3,$FF,16,2,3,$FF,4,0,3,$FF,17,2   ; fila 1
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
                        .byte 3,$FF,38,0,3                      ; fila 14
                        .byte 3,$FF,38,0,3                      ; fila 15
                        .byte 3,$FF,38,0,3                      ; fila 16
                        .byte 3,$FF,38,0,3                      ; fila 17
                        .byte 3,$FF,38,0,3                      ; fila 18
                        .byte 3,$FF,38,0,3                      ; fila 19
                        .byte 3,$FF,38,0,3                      ; fila 20
                        .byte 3,$FF,38,0,3                      ; fila 21
                        .byte 3,$FF,38,0,3                      ; fila 22
                        .byte 3,$FF,17,2,$FF,4,0,$FF,17,2,3     ; fila 23
                        ; parte 4 (columna 1, fila 1)
                        .byte 3,$FF,16,2,3,$FF,4,0,3,$FF,17,2   ; fila 1
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
                        ; parte 5 (columna 2, fila 1)
                        .byte 3,$FF,17,2,$FF,4,0,$FF,17,2,3     ; fila 1
                        .byte 3,$FF,4,0,5,5,4,$FF,8,0,8,3,$FF,4,0,3,9,$FF,8,0,4,5,5,$FF,4,0,3 ; fila 2
                        .byte 3,$FF,4,0,5,5,4,$FF,9,0,5,$FF,4,0,5,$FF,9,0,4,5,5,$FF,4,0,3 ; fila 3
                        .byte 3,$FF,4,0,5,5,4,$FF,8,0,5,5,$FF,4,0,5,5,$FF,8,0,4,5,5,$FF,4,0,3 ; fila 4
                        .byte 3,$FF,4,0,5,5,$FF,9,0,5,$FF,6,0,5,$FF,9,0,5,5,$FF,4,0,3 ; fila 5
                        .byte 3,$FF,6,5,$FF,9,0,4,$FF,6,0,4,$FF,9,0,$FF,6,5,3 ; fila 6
                        .byte 3,$FF,6,5,$FF,9,0,4,$FF,6,0,4,$FF,9,0,$FF,6,5,3 ; fila 7
                        .byte 3,4,4,4,$FF,11,0,53,4,$FF,6,0,4,54,$FF,11,0,4,4,4,3 ; fila 8
                        .byte 3,2,$FF,5,0,$FF,6,5,$FF,4,4,$FF,6,0,$FF,4,4,$FF,6,5,$FF,6,0,3 ; fila 9
                        .byte $FF,39,0,3                        ; fila 10
                        .byte $FF,39,0,3                        ; fila 11
                        .byte $FF,39,0,3                        ; fila 12
                        .byte $FF,39,0,3                        ; fila 13
                        .byte 3,2,$FF,5,0,$FF,6,5,$FF,4,4,$FF,6,0,$FF,4,4,$FF,6,5,$FF,6,0,3 ; fila 14
                        .byte 3,$FF,14,0,55,4,$FF,6,0,4,56,$FF,14,0,3 ; fila 15
                        .byte 3,4,4,4,$FF,12,0,4,$FF,6,0,4,$FF,12,0,4,4,4,3 ; fila 16
                        .byte 3,$FF,6,5,$FF,9,0,4,$FF,6,0,4,$FF,9,0,$FF,6,5,3 ; fila 17
                        .byte 3,$FF,6,5,$FF,9,0,5,$FF,6,0,5,$FF,9,0,$FF,6,5,3 ; fila 18
                        .byte 3,$FF,4,0,5,5,$FF,9,0,5,$FF,6,0,5,$FF,9,0,5,5,$FF,4,0,3 ; fila 19
                        .byte 3,$FF,4,0,5,5,4,$FF,8,0,5,5,$FF,4,0,5,5,$FF,8,0,4,5,5,$FF,4,0,3 ; fila 20
                        .byte 3,$FF,4,0,5,5,4,$FF,9,0,5,$FF,4,0,5,$FF,9,0,4,5,5,$FF,4,0,3 ; fila 21
                        .byte 3,$FF,4,0,5,5,4,$FF,8,0,8,3,$FF,4,0,3,9,$FF,8,0,4,5,5,$FF,4,0,3 ; fila 22
                        .byte 3,$FF,17,2,$FF,4,0,$FF,17,2,3     ; fila 23
                        ; parte 6 (columna 0, fila 2)
                        .byte 3,$FF,17,2,$FF,4,0,$FF,17,2,3     ; fila 1
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
                        ; parte 7 (columna 1, fila 2)
                        .byte 3,$FF,38,2,3                      ; fila 1
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
                        ; parte 8 (columna 2, fila 2)
                        .byte 3,$FF,17,2,$FF,4,0,$FF,17,2,3     ; fila 1
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
                        .byte 7,9                               ; robots, celulas
                        .byte 2,30,7,6,2,16,$9C,1,25,34,4,11    ; robot 0
                        .byte 0,29,18,6,2,16,$9C,1,27,32,17,21  ; robot 1
                        .byte 5,10,6,6,2,16,$9C,1,4,17,2,11     ; robot 2
                        .byte 5,27,17,6,2,16,28,1,21,34,13,22   ; robot 3
                        .byte 5,19,11,6,2,16,$9C,1,13,26,7,16   ; robot 4
                        .byte 5,27,6,6,2,16,$9C,1,21,34,2,11    ; robot 5
                        .byte 5,11,17,6,2,16,$9C,1,5,18,13,22   ; robot 6
                        .byte 1,19,13,2,8,11,2,19,18,0,15,5,0,15,16,5,2,3,5,36,3,5,2,20,5,36,20 ; celulas (parte, x, y)
                        .byte $FF,0,0                           ; sin salida
