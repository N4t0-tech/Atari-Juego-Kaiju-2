; kaiju2_graficos.asm - aspecto del jugador 2 (cooperativo): sus colores y
; sus 6 poses, con el mismo formato y orden que las de kaiju_graficos.asm
; (cada _p1 justo despues de su _p0; datos.asm lo comprueba). Se dibujan en
; Player 2 (cuerpo) + Player 3 (contorno). Generado con editor-sprite.html
; (panel Kaiju, «Jugador 2»): pega aqui su bloque exportado.

KAIJU2_PCOLR0   = $78   ; cuerpo del jugador 2 (P2)
KAIJU2_PCOLR1   = $3A   ; contorno del jugador 2 (P3); mezcla P2|P3 = $7A

; --- jugador 2: 6 poses x 2 players x 24 filas ---
; quieto mirando a la derecha (y mirando abajo) (Player 2, cuerpo)
kaiju2_quieto_der_p0     .byte %00000000
                        .byte %00000000
                        .byte %00000000
                        .byte %00111100
                        .byte %00111100
                        .byte %00101000
                        .byte %00111100
                        .byte %00100000
                        .byte %00111100
                        .byte %00011000
                        .byte %01111110
                        .byte %10110101
                        .byte %10111101
                        .byte %10111101
                        .byte %10111101
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00100100
                        .byte %00100100
                        .byte %00100100
                        .byte %00000000
                        .byte %00000000
                        .byte %00000000
; quieto mirando a la derecha (y mirando abajo) (Player 3, contorno)
kaiju2_quieto_der_p1     .byte %00000000
                        .byte %00000000
                        .byte %00011000
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %01111110
                        .byte %00111100
                        .byte %00111100
                        .byte %00011000
                        .byte %01111110
                        .byte %10101101
                        .byte %10100101
                        .byte %10100101
                        .byte %10100101
                        .byte %10111101
                        .byte %00000000
                        .byte %00111100
                        .byte %00100100
                        .byte %00100100
                        .byte %00100100
                        .byte %00110110
                        .byte %00000000
                        .byte %00000000
; caminando, paso A (Player 2, cuerpo)
kaiju2_camina_a_p0       .byte %00000000
                        .byte %00000000
                        .byte %00000000
                        .byte %00111100
                        .byte %00111100
                        .byte %00101000
                        .byte %00111100
                        .byte %00100000
                        .byte %00111100
                        .byte %00011000
                        .byte %01111100
                        .byte %10110110
                        .byte %10111110
                        .byte %10111111
                        .byte %10111110
                        .byte %00111110
                        .byte %00111100
                        .byte %00111100
                        .byte %00100100
                        .byte %00100000
                        .byte %00100000
                        .byte %00000000
                        .byte %00000000
                        .byte %00000000
; caminando, paso A (Player 3, contorno)
kaiju2_camina_a_p1       .byte %00000000
                        .byte %00000000
                        .byte %00011000
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %01111110
                        .byte %00111100
                        .byte %00111100
                        .byte %00011000
                        .byte %01111100
                        .byte %10101110
                        .byte %10100110
                        .byte %10100111
                        .byte %10100110
                        .byte %10111110
                        .byte %00000010
                        .byte %00111100
                        .byte %00100100
                        .byte %00100110
                        .byte %00100000
                        .byte %00110000
                        .byte %00000000
                        .byte %00000000
; caminando, paso B (Player 2, cuerpo)
kaiju2_camina_b_p0       .byte %00000000
                        .byte %00000000
                        .byte %00000000
                        .byte %00111100
                        .byte %00111100
                        .byte %00101000
                        .byte %00111100
                        .byte %00100000
                        .byte %00111100
                        .byte %00011000
                        .byte %00111110
                        .byte %01110101
                        .byte %01111101
                        .byte %11111101
                        .byte %01111101
                        .byte %01111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00100100
                        .byte %00000100
                        .byte %00000100
                        .byte %00000000
                        .byte %00000000
                        .byte %00000000
; caminando, paso B (Player 3, contorno)
kaiju2_camina_b_p1       .byte %00000000
                        .byte %00000000
                        .byte %00011000
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %01111110
                        .byte %00111100
                        .byte %00111100
                        .byte %00011000
                        .byte %00111110
                        .byte %01101101
                        .byte %01100101
                        .byte %11100101
                        .byte %01100101
                        .byte %01111101
                        .byte %01000000
                        .byte %00111100
                        .byte %00100100
                        .byte %00110100
                        .byte %00000100
                        .byte %00000110
                        .byte %00000000
                        .byte %00000000
; de espaldas (joystick arriba), paso A (Player 2, cuerpo)
kaiju2_arriba_a_p0       .byte %00000000
                        .byte %00000000
                        .byte %00000000
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00011000
                        .byte %00111110
                        .byte %01111101
                        .byte %01111101
                        .byte %01111101
                        .byte %01111101
                        .byte %01111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00100100
                        .byte %00000100
                        .byte %00000100
                        .byte %00000000
                        .byte %00000000
                        .byte %00000000
; de espaldas (joystick arriba), paso A (Player 3, contorno)
kaiju2_arriba_a_p1       .byte %00000000
                        .byte %00000000
                        .byte %00011000
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %01111110
                        .byte %00111100
                        .byte %00111100
                        .byte %00011000
                        .byte %00111110
                        .byte %01111101
                        .byte %01111101
                        .byte %01111101
                        .byte %01111101
                        .byte %01111101
                        .byte %01000000
                        .byte %00111100
                        .byte %00100100
                        .byte %00110100
                        .byte %00000100
                        .byte %00000110
                        .byte %00000000
                        .byte %00000000
; de espaldas (joystick arriba), paso B (Player 2, cuerpo)
kaiju2_arriba_b_p0       .byte %00000000
                        .byte %00000000
                        .byte %00000000
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00011000
                        .byte %00111100
                        .byte %01111110
                        .byte %10111110
                        .byte %10111110
                        .byte %10111110
                        .byte %00111110
                        .byte %00111100
                        .byte %00111100
                        .byte %00100100
                        .byte %00100000
                        .byte %00100000
                        .byte %00000000
                        .byte %00000000
                        .byte %00000000
; de espaldas (joystick arriba), paso B (Player 3, contorno)
kaiju2_arriba_b_p1       .byte %00000000
                        .byte %00000000
                        .byte %00011000
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %01111110
                        .byte %00111100
                        .byte %00111100
                        .byte %00011000
                        .byte %00111100
                        .byte %01111110
                        .byte %10111110
                        .byte %10111110
                        .byte %10111110
                        .byte %10111110
                        .byte %00000010
                        .byte %00111100
                        .byte %00100100
                        .byte %00100110
                        .byte %00100000
                        .byte %00110000
                        .byte %00000000
                        .byte %00000000
; quieto mirando a la izquierda (Player 2, cuerpo)
kaiju2_quieto_izq_p0     .byte %00000000
                        .byte %00000000
                        .byte %00000000
                        .byte %00111100
                        .byte %00111100
                        .byte %00010100
                        .byte %00111100
                        .byte %00000100
                        .byte %00111100
                        .byte %00011000
                        .byte %01111110
                        .byte %10110101
                        .byte %10111101
                        .byte %10111101
                        .byte %10111101
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %00100100
                        .byte %00100100
                        .byte %00100100
                        .byte %00000000
                        .byte %00000000
                        .byte %00000000
; quieto mirando a la izquierda (Player 3, contorno)
kaiju2_quieto_izq_p1     .byte %00000000
                        .byte %00000000
                        .byte %00011000
                        .byte %00111100
                        .byte %00111100
                        .byte %00111100
                        .byte %01111110
                        .byte %00111100
                        .byte %00111100
                        .byte %00011000
                        .byte %01111110
                        .byte %10101101
                        .byte %10100101
                        .byte %10100101
                        .byte %10100101
                        .byte %10111101
                        .byte %00000000
                        .byte %00111100
                        .byte %00100100
                        .byte %00100100
                        .byte %00100100
                        .byte %01101100
                        .byte %00000000
                        .byte %00000000
