# atari-juego

Recreación del juego **Kaiju** ("SUPPA ROBOTTO") para Atari de 8 bits, escrita desde cero en ensamblador 6502.
Las reglas del original se sacaron por ingeniería inversa de su binario (compilado con cc65). Los gráficos,
la fuente y la imagen de título son los del disco original, convertidos byte a byte; los niveles son
propios y se hacen con el editor (`editor-sprite.html`, panel **Niveles**).

Manejás al robot Kaiju por los niveles de `niveles.asm`: juntá todas las células, esquivá o destruí
a los robots y no le dispares a las células.

## Requisitos

- [MADS](https://github.com/tebe6502/Mad-Assembler) 2.1.7 (Mad-Assembler)
- Un emulador de Atari 8-bit; el proyecto se prueba con [Altirra](https://www.virtualdub.org/altirra.html)

## Compilar y jugar

```sh
mads main.asm -o:juego.xex
altirra juego.xex
```

`juego.xex` no está en el repo (se genera al compilar).

En un Atari XL/XE real no hace falta apretar OPTION al cargarlo: el juego apaga el BASIC solo
(necesita esa memoria para los niveles).

### Build de debug

```sh
mads main.asm -d:DEBUG=1 -o:juego-debug.xex
```

En la pantalla de título aparece **START LEVEL n** para empezar en cualquier nivel:
joystick izquierda/derecha cambia de a un nivel.

### Windows

MADS y Altirra tienen versiones nativas para Windows, así que los comandos son los mismos:

1. Bajá `mads.exe` de los [releases de Mad-Assembler](https://github.com/tebe6502/Mad-Assembler/releases)
   y ponelo en el `PATH` o en la carpeta del proyecto.
2. Desde `cmd` o PowerShell, **parado en la carpeta del proyecto** (los `icl` usan rutas relativas):

   ```bat
   mads main.asm -o:juego.xex
   ```

3. Abrí `juego.xex` con Altirra (doble clic, arrastrándolo a la ventana o `Altirra64.exe juego.xex`).

Si clonás con git, evitá que convierta los finales de línea del binario `kaiju_titulo.mic`
(`git config core.autocrlf false`); a los `.asm` con CRLF MADS los acepta igual.

## Controles

| Control              | Acción                                   |
|----------------------|------------------------------------------|
| Joystick 1 / 2       | Mover (8 direcciones) a J1 / J2          |
| Botón                | Disparar en la dirección en que mirás    |
| Botón (en el título) | Empezar la partida con ese joystick      |
| Botón del otro joystick (jugando) | Entrar a la partida (cooperativo) |

## Reglas

- **Células**: tocalas para juntarlas (+100). Cuando no queda ninguna, pasás al nivel siguiente.
  Si le disparás a una, perdés el nivel: −1 de energía y "TRY AGAIN".
- **Robots**: patrullan su zona y te persiguen si entrás en ella. Tocarlos cuesta 1 de energía.
- **Tiradores**: robots que te disparan cada 1,5 segundos más o menos cuando estás a menos de 14 casillas,
  apuntando a donde estás. Cuando te descubren no te persiguen: se ponen a distancia de tiro y, si te
  acercás, se escapan (al doble de velocidad que los otros robots).
  Cada bala que te toca cuesta 1 de energía; las balas se frenan en los bloques.
  Cada disparo les quita una vida (las que tenga en el editor); destruirlos da +10.
- **Partes**: un nivel puede ocupar varias pantallas. Se pasa a la de al lado saliendo por un hueco del
  borde; hay que juntar las células de todas. Así se arma un laberinto de hasta 3×3 pantallas.
- **Salida**: si el nivel tiene una (la puerta de franjas), se gana al tocarla y las células solo dan
  puntos. Sin salida, se gana juntando todas las células.
- **Bloques azules**: se rompen a tiros (+1). El borde verde también lastima.
- **Energía**: empezás con 5; después de cada golpe hay un rato de invulnerabilidad. Con 0 es GAME OVER.
- Superando el último nivel aparece "YOU ARE SUPER PLAYER".
- **Cooperativo**: se puede jugar solo o de a dos en cualquier nivel. El otro jugador entra cuando quiera
  apretando el botón de su joystick: aparece al lado de su compañero con 5 de energía. J2 es el robot de otro color. Cada uno tiene su energía (J1 en la fila de
  arriba, J2 en la de abajo); los puntos y las células son de los dos. Si uno le dispara a una célula, pierde energía él
  y se repite el nivel. Para pasar a otra parte del nivel tienen que estar los dos en el hueco, empujando
  hacia el mismo lado. Quien se queda sin energía sale de la partida (y ya no puede volver a entrar); sin ninguno, GAME OVER. Los robots
  van por el jugador más cercano.

## Estructura

| Archivo                | Contenido                                                      |
|------------------------|----------------------------------------------------------------|
| `main.asm`             | Punto de entrada, bucle principal, incluye todo lo demás       |
| `hardware.asm`         | Registros del Atari y mapa de memoria                          |
| `jugador.asm`          | Movimiento, animación y dibujo de los jugadores (cooperativo)  |
| `bala.asm`             | Disparo                                                        |
| `enemigos.asm`         | Robots: patrulla, persecución, contactos                       |
| `balaenemiga.asm`      | Tiradores: sus disparos (missiles 2 y 3)                       |
| `celulas.asm`          | Células                                                        |
| `partes.asm`           | Niveles de varias partes (pantallas)                           |
| `nivel.asm`            | Pantallas (juego, mensajes, título) y choques con los bloques  |
| `etapas.asm`           | Título, niveles, mensajes y selector de debug                  |
| `niveles.asm`          | Los niveles (mapas, robots, células); lo genera el editor      |
| `hud.asm`              | Energía, células restantes y puntaje                           |
| `sonido.asm`           | Efectos de sonido                                              |
| `datos.asm`            | Variables y tablas                                             |
| `kaiju_*.asm`, `.mic`  | Recursos del Kaiju original (gráficos, fuente, textos, título) |
| `editor-sprite.html`   | Editor de sprites, colores y niveles (se abre en el navegador) |
| `AGENTS.md`            | Documentación técnica detallada (memoria, reglas, detalles)    |

## Editor de sprites y niveles

`editor-sprite.html` se abre directamente en el navegador, sin instalar nada. Permite editar las poses del
robot, la bala y los colores con la paleta del Atari, y exporta bloques `.byte` listos para pegar en el código.

### Crear niveles

En el panel **Niveles**:

1. Elegí un nivel de la lista (o **+ Nuevo**: arranca con el borde). El orden de la lista es el orden del juego.
2. Pintá los bloques (borde, muro, bloque azul que se rompe…) con lápiz, rectángulo o relleno; el botón
   derecho borra. Con **Simetría** se pinta espejado.
   Un nivel puede tener **varias partes** (pantallas, hasta 9: 3×3, 4×2, 9×1…). Elegí la cuadrícula en
   **Partes** y la parte que editás en las miniaturas. En el juego se pasa de una a otra saliendo por un
   hueco del borde: al abrir un hueco se abre también en la parte vecina. Todo lo que pasa en una parte
   (bloques rotos, células, robots) queda así al volver.
3. **Inicio** pone al jugador; **Célula** pone células (hasta 18 por nivel); **Robot** pone robots (hasta 16 por nivel);
   **Salida** pone la salida (una por nivel).
   Arrastralos para moverlos y borralos con el botón derecho.
4. Elegí un robot para cambiar su tipo (normal o tirador, en dos colores), su vida, su patrulla (dos direcciones y pasos; la línea verde
   muestra el recorrido) y su zona de vigilancia (en amarillo; se puede dibujar con **Zona**).
5. **▶ Probar en la escena** lo carga en la escena de prueba para caminarlo.
6. **💾 Descargar niveles.asm**, guardalo en la carpeta del juego reemplazando el anterior y compilá.

Para seguir editando otro día, el editor recuerda tus niveles en el navegador; también podés abrir un
`niveles.asm` con **Abrir niveles.asm…**. Abajo se ve cuánta memoria ocupan: los niveles tienen 11 KB para
ellos solos (unos 25 grandes como los de Kaiju o 45 sencillos).

## Diferencias con el original

- La persecución de los robots usa 8 direcciones limpias (el original comparaba mal un eje en algunos casos).
- En vertical, el jugador se mueve 2 líneas por paso (el original, 1).
- La bala choca con su caja de 4 × 8 completa; así se puede salir de la caja del mapa 6.
- Sonidos simplificados.
