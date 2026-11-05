# atari-juego

Recreación del juego **Kaiju** ("SUPPA ROBOTTO") para Atari de 8 bits, escrita desde cero en ensamblador 6502.
Las reglas del original se obtuvieron por ingeniería inversa de su binario (compilado con cc65). Los gráficos,
la fuente y la imagen de título son los del disco original, convertidos byte a byte; los niveles son propios
y se crean con el editor (`editor-sprite.html`, panel **Niveles**).

Controlas al robot Kaiju, solo o con un compañero, por laberintos de hasta 3×3 pantallas: recoge todas las
células (o llega a la salida), esquiva o destruye a los robots y no le dispares a las células.

## Requisitos

- [MADS](https://github.com/tebe6502/Mad-Assembler) 2.1.7 (Mad-Assembler)
- Un emulador de Atari 8-bit; el proyecto se prueba con [Altirra](https://www.virtualdub.org/altirra.html)

## Compilar y jugar

```sh
mads main.asm -o:juego.xex
altirra juego.xex
```

`juego.xex` no está en el repositorio (se genera al compilar).

En un Atari XL/XE real no hace falta mantener OPTION al cargarlo: el juego apaga el BASIC por sí solo
(necesita esa memoria para los niveles).

### Versión de depuración

```sh
mads main.asm -d:DEBUG=1 -o:juego-debug.xex
```

En la pantalla de título aparece **START LEVEL n** para empezar en cualquier nivel:
con el joystick a la izquierda o a la derecha cambias de nivel de uno en uno.

### Windows

MADS y Altirra tienen versiones nativas para Windows, así que los comandos son los mismos:

1. Descarga `mads.exe` desde los [releases de Mad-Assembler](https://github.com/tebe6502/Mad-Assembler/releases)
   y déjalo en el `PATH` o en la carpeta del proyecto.
2. Desde `cmd` o PowerShell, **ubicado en la carpeta del proyecto** (los `icl` usan rutas relativas):

   ```bat
   mads main.asm -o:juego.xex
   ```

3. Abre `juego.xex` con Altirra (doble clic, arrastrándolo a la ventana o con `Altirra64.exe juego.xex`).

Si clonas con git, evita que convierta los finales de línea de los binarios `kaiju_titulo.mic` y
`kaiju_titulo.lz` (`git config core.autocrlf false`); MADS acepta igual los `.asm` con CRLF.

## Controles

| Control                          | Acción                                   |
|----------------------------------|------------------------------------------|
| Joystick 1 / 2                   | Mover a J1 / J2 (8 direcciones)          |
| Botón                            | Disparar hacia donde miras               |
| Botón (en el título)             | Empezar la partida con ese joystick      |
| Botón del otro joystick (jugando)| Unirse a la partida (cooperativo)        |

## Reglas

- **Células**: tócalas para recogerlas (+100). Cuando no queda ninguna, pasas al nivel siguiente.
  Si le disparas a una, pierdes el nivel: −1 de energía y "TRY AGAIN".
- **Salida**: si el nivel tiene una (la puerta de franjas), se gana al tocarla y las células solo dan puntos.
- **Robots**: patrullan su zona y te persiguen si entras en ella. Tocarlos cuesta 1 de energía.
  Cada disparo les quita una vida (las que tengan en el editor); destruirlos da +10.
- **Tiradores**: robots que te disparan más o menos cada 1,5 segundos cuando estás a menos de 14 casillas.
  Al descubrirte no te persiguen: se ponen a distancia de tiro y, si te acercas, huyen al doble de
  velocidad. Cada bala que te toca cuesta 1 de energía; las balas se detienen en los bloques.
- **Partes**: un nivel puede ocupar varias pantallas (hasta 9). Se pasa a la de al lado saliendo por un
  hueco del borde; lo que ocurre en cada parte (bloques rotos, células, robots) se conserva al volver.
- **Bloques azules**: se rompen a disparos (+1). El borde verde también te daña.
- **Energía**: empiezas con 5; después de cada golpe quedas un rato invulnerable. Con 0 es GAME OVER.
- Al superar el último nivel aparece "YOU ARE SUPER PLAYER".

## Cooperativo

- No hay modos de 1 o 2 jugadores: el otro se une cuando quiera pulsando el botón de su joystick y aparece
  junto a su compañero con 5 de energía. J2 es el robot de otro color.
- Cada uno tiene su energía; los puntos y las células son de los dos. Si uno le dispara a una célula,
  pierde energía él y se repite el nivel.
- Para pasar a otra parte, los dos deben estar en el hueco empujando hacia el mismo lado.
- Los robots van por el jugador más cercano.
- Quien se queda sin energía sale de la partida y ya no puede volver; sin ninguno, GAME OVER.

## Pantalla

- **Marcador**: en la fila superior, la energía de J1 a la izquierda, las células que faltan al centro y
  el puntaje a la derecha; en la fila inferior, la energía de J2.
- **Efectos**: los robots parpadean cuando los hieres y explotan al destruirlos; tú parpadeas mientras
  eres invulnerable; junto al hueco aparece un cartel con cuántos jugadores esperan para cambiar de parte.

## Estructura

| Archivo                | Contenido                                                      |
|------------------------|----------------------------------------------------------------|
| `main.asm`             | Punto de entrada, bucle principal; incluye todo lo demás       |
| `hardware.asm`         | Registros del Atari y mapa de memoria                          |
| `jugador.asm`          | Movimiento, animación y dibujo de los jugadores                |
| `bala.asm`             | Disparo                                                        |
| `enemigos.asm`         | Robots: patrulla, persecución, contactos, parpadeo y explosión |
| `balaenemiga.asm`      | Tiradores y sus balas                                          |
| `celulas.asm`          | Células                                                        |
| `partes.asm`           | Niveles de varias partes (pantallas)                           |
| `nivel.asm`            | Pantallas (juego, mensajes, título) y choques con los bloques  |
| `etapas.asm`           | Título, niveles, mensajes y selector de depuración             |
| `niveles.asm`          | Los niveles (mapas, robots, células); lo genera el editor      |
| `hud.asm`              | Marcador: energía, células restantes y puntaje                 |
| `sonido.asm`           | Efectos de sonido                                              |
| `datos.asm`            | Variables y tablas                                             |
| `kaiju_*.asm`, `.mic`  | Recursos del Kaiju original (gráficos, fuente, textos, título) |
| `kaiju_titulo.lz`, `comprimir_titulo.py` | Título comprimido; el script solo se usa si cambia `kaiju_titulo.mic` |
| `editor-sprite.html`   | Editor de sprites, colores y niveles (se abre en el navegador) |
| `AGENTS.md`            | Documentación técnica detallada (memoria, reglas, detalles)    |

## Editor de sprites y niveles

`editor-sprite.html` se abre directamente en el navegador, sin instalar nada. Permite editar las poses del
robot, la bala y los colores (de J1 y J2) con la paleta del Atari, y exporta bloques `.byte` listos para pegar
en el código. Tiene ayudas `?` en cada control y una escena de prueba para ver el movimiento y los disparos
sobre los niveles.

En el panel **Niveles**:

1. Elige un nivel de la lista (o **+ Nuevo**: empieza con el borde). El orden de la lista es el orden del juego.
2. Elige la cuadrícula en **Partes** (3×3, 4×2, 9×1…) y la parte que editas en las miniaturas; arrastrando
   una miniatura sobre otra se intercambian.
3. Pinta los bloques (borde, muro, bloque azul…) con lápiz, rectángulo o relleno; el botón derecho borra.
   Con **Simetría** se pinta en espejo. Al abrir un hueco en el borde se abre también en la parte vecina.
4. **Inicio** coloca al jugador; **Célula**, las células (hasta 18 por nivel); **Robot**, los robots (hasta 16);
   **Salida**, la salida (una por nivel, opcional). Arrástralos para moverlos y bórralos con el botón derecho.
5. Elige un robot para cambiar su tipo (normal o tirador, en dos colores), su vida, su patrulla (dos
   direcciones y pasos; la línea verde muestra el recorrido) y su zona de vigilancia (en amarillo; se puede
   dibujar con **Zona**).
6. Revisa los avisos (huecos sin vecino o muy pequeños, células a las que no se llega…) y usa
   **▶ Probar en la escena** para recorrerlo.
7. **💾 Descargar niveles.asm**, guárdalo en la carpeta del juego reemplazando el anterior y compila.

El editor recuerda tus niveles en el navegador; también puedes abrir un `niveles.asm` con
**Abrir niveles.asm…**. Abajo se ve cuánta memoria ocupan: hay unos 16 KB para niveles (unos 35 grandes
como los de Kaiju o 65 sencillos).

## Diferencias con el original

- La persecución de los robots usa 8 direcciones limpias (el original comparaba mal un eje en algunos casos).
- El jugador es algo más rápido: en vertical se mueve 2 líneas por paso (el original, 1) y en general un 10% más.
- La bala choca con su caja completa de 4 × 8.
- Novedades: tiradores, salida, niveles de varias partes, cooperativo, parpadeo y explosión de los robots.
- Sonidos simplificados.
