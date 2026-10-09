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
| Joystick 1           | Mover (8 direcciones)                    |
| Botón                | Disparar en la dirección en que mirás    |
| Botón (en el título) | Empezar la partida                       |

## Reglas

- **Células**: tocalas para juntarlas (+100). Cuando no queda ninguna, pasás al nivel siguiente.
  Si le disparás a una, perdés el nivel: −1 de energía y "TRY AGAIN".
- **Robots**: patrullan su zona y te persiguen si entrás en ella. Tocarlos cuesta 1 de energía.
  Cada disparo les quita una vida (las que tenga en el editor); destruirlos da +10.
- **Bloques azules**: se rompen a tiros (+1). El borde verde también lastima.
- **Energía**: empezás con 5; después de cada golpe hay un rato de invulnerabilidad. Con 0 es GAME OVER.
- Superando el último nivel aparece "YOU ARE SUPER PLAYER".

## Estructura

| Archivo                | Contenido                                                      |
|------------------------|----------------------------------------------------------------|
| `main.asm`             | Punto de entrada, bucle principal, incluye todo lo demás       |
| `hardware.asm`         | Registros del Atari y mapa de memoria                          |
| `jugador.asm`          | Movimiento, animación y dibujo del jugador                     |
| `bala.asm`             | Disparo                                                        |
| `enemigos.asm`         | Robots: patrulla, persecución, contactos                       |
| `celulas.asm`          | Células                                                        |
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
3. **Inicio** pone al jugador; **Célula** pone células (hasta 18); **Robot** pone robots (hasta 10).
   Arrastralos para moverlos y borralos con el botón derecho.
4. Elegí un robot para cambiar su tipo, su vida, su patrulla (dos direcciones y pasos; la línea verde
   muestra el recorrido) y su zona de vigilancia (en amarillo; se puede dibujar con **Zona**).
5. **▶ Probar en la escena** lo carga en la escena de prueba para caminarlo.
6. **💾 Descargar niveles.asm**, guardalo en la carpeta del juego reemplazando el anterior y compilá.

Para seguir editando otro día, el editor recuerda tus niveles en el navegador; también podés abrir un
`niveles.asm` con **Abrir niveles.asm…**. Abajo se ve cuánta memoria ocupan (caben unos 25 niveles).

## Diferencias con el original

- La persecución de los robots usa 8 direcciones limpias (el original comparaba mal un eje en algunos casos).
- En vertical, el jugador se mueve 2 líneas por paso (el original, 1).
- La bala choca con su caja de 4 × 8 completa; así se puede salir de la caja del mapa 6.
- Sonidos simplificados.
