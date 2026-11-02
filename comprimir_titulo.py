#!/usr/bin/env python3
# comprimir_titulo.py - comprime la imagen del titulo para el juego
# Uso: python3 comprimir_titulo.py   (lee kaiju_titulo.mic, escribe kaiju_titulo.lz)
# Solo hace falta correrlo si cambia kaiju_titulo.mic; el .lz va en el repo.
#
# Formato (lo descomprime descomprimir_titulo en nivel.asm), por fichas:
#   $00-$7F  t+1 bytes literales a continuacion
#   $80-$FE  copiar t-$7D bytes (3..129) desde d+1 bytes atras (d = byte siguiente)
#   $FF      fin
import sys

LINEAS = 196            # el juego solo muestra las primeras 196 lineas de 40 bytes
MIN, MAXL, MAXD = 3, 129, 256


def comprimir(d):
    out, lit, i = bytearray(), bytearray(), 0

    def soltar():
        for k in range(0, len(lit), 128):
            trozo = lit[k:k + 128]
            out.append(len(trozo) - 1)
            out.extend(trozo)
        lit.clear()

    while i < len(d):
        largo, dist = 0, 0
        for j in range(max(0, i - MAXD), i):
            l = 0
            while i + l < len(d) and l < MAXL and d[j + l] == d[i + l]:
                l += 1
            if l > largo:
                largo, dist = l, i - j
        if largo >= MIN:
            soltar()
            out += bytes([largo + 0x7D, dist - 1])
            i += largo
        else:
            lit.append(d[i])
            i += 1
    soltar()
    out.append(0xFF)
    return bytes(out)


def descomprimir(z):
    out, i = bytearray(), 0
    while z[i] != 0xFF:
        t = z[i]
        if t < 0x80:
            out += z[i + 1:i + 2 + t]
            i += 2 + t
        else:
            d = z[i + 1] + 1
            for _ in range(t - 0x7D):
                out.append(out[-d])
            i += 2
    return bytes(out)


if __name__ == '__main__':
    img = open('kaiju_titulo.mic', 'rb').read()[:LINEAS * 40]
    z = comprimir(img)
    assert descomprimir(z) == img, 'la descompresion no da la imagen original'
    open('kaiju_titulo.lz', 'wb').write(z)
    print(f'kaiju_titulo.lz: {len(img)} -> {len(z)} bytes', file=sys.stderr)
