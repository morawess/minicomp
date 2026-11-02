# minicomp — JFlex + CUP + MARS

Aplicación para la materia Compiladores. Compila este programa hasta MIPS y lo ejecuta en MARS:

```java
boolean flag = true;
System.Out.Println("Inicio del Programa");
IF (flag){
System.Out.Println ("Hola Mundo!");
}
ELSE {
System.Out.Println ("Error");
}
System.Out.Println("Final del Programa");
```

```
Inicio del Programa
Hola Mundo!
Final del Programa
```

Se puede trabajar de **tres formas**:

| Forma | Qué se escribe | Quién genera el `.flex` y el `.cup` | Quién ejecuta las herramientas |
|---|---|---|---|
| **Modo Tablas** (puente automático) | Campos: tabla léxica, gramática BNF, reglas de tipos | minicomp | minicomp |
| **Modo A mano** | El `lexer.flex` y el `parser.cup` reales | La persona | minicomp, con los mismos comandos de la terminal |
| **Las herramientas solas** | El `lexer.flex` y el `parser.cup` reales | La persona | La persona, por consola o desde la ventana de cada herramienta |

La idea es **contrastar**: lo que se escribe (unas 40 líneas de `.flex` y 18 líneas de
gramática) contra lo que generan las herramientas (cientos de líneas, un autómata y una tabla
LALR). El modo A mano lo muestra en la pestaña **Contraste**.

## Cómo se relacionan las fases

```
   EL COMPILADOR (las reglas, se escriben una vez)            LA ENTRADA (cambia todo el tiempo)

   lexer.flex ──JFlex──► Analizador léxico ◄─────────────────── Programa fuente
                              │ tokens                           System.Out.Println("Hola");
                              ▼
   parser.cup ──CUP────► Analizador sintáctico
                              │ árbol
                              ▼
   reglas de tipos ─────► Analizador semántico
                              │ árbol con tipos
                              ▼
                         Generador de código ──► programa.asm ──► MARS
```

El `.flex` y el `.cup` definen **el compilador**; el programa fuente es **lo que se compila**.
JFlex y CUP toman las reglas y fabrican el analizador léxico y el sintáctico. Esos analizadores
después leen el programa. Cada fase controla una sola cosa:

| Fase | Recibe | Controla | Error típico |
|---|---|---|---|
| Léxico (JFlex) | Caracteres | ¿Cada palabra existe? | `System.out.println`: el `.` no lo reconoce ninguna regla |
| Sintáctico (CUP) | Tokens | ¿Están en un orden válido? | Falta un `;` |
| Semántico | El árbol | ¿Tiene sentido? | `IF (5)`: un número no es una condición |
| Código | El árbol con tipos | — | Genera el MIPS que ejecuta MARS |

## Requisito

**Java 17 o superior, versión JDK** (la que trae `javac`). Para comprobarlo:

```
java -version
javac -version
```

## Abrir minicomp

| | |
|---|---|
| **Windows** | Doble clic en `minicomp.jar`, o en una terminal (`cmd`): `java -jar minicomp.jar` |
| **Linux / Mac** | En una terminal: `java -jar minicomp.jar` (en muchos escritorios también funciona el doble clic) |

Arranca en modo Tablas, ya compilado.

## La ventana

**Barra de arriba:**

| Botón | Qué hace |
|---|---|
| **Nuevo** | Vuelve al caso inicial (en el modo actual) |
| **Abrir… / Guardar / Guardar como…** | Abre o guarda el **trabajo** completo en un archivo `.minicomp`: el modo, las tablas o el `.flex`/`.cup`, y el programa. Es el archivo que se entrega |
| **Modo: Tablas / A mano** | Cambia la forma de trabajar (ver abajo) |
| **▶ Compilar (F5)** | Compila el programa |
| **Carpeta de trabajo / Abrir carpeta** | La carpeta `output/`, donde quedan todos los archivos generados (ver más abajo) |

**Programa fuente** (pestaña de la izquierda, en los dos modos): se escribe directamente, o se trae
un `.txt` con **Abrir archivo…** (se compila solo al abrirlo). **Guardar como…** lo guarda en un `.txt`.

**Barra de abajo:** muestra cada fase (o cada paso, en modo A mano) con ✔ si pasó, ✘ si falló y
○ si no se llegó a ejecutar, y debajo los mensajes de error. Si se cambia algo después de compilar,
las fases se ponen en gris y aparece *"Hubo cambios desde la última compilación"*: hay que
presionar **F5** de nuevo.

## Flujo de trabajo sugerido

Tres etapas, de menos a más código escrito a mano:

```
 1. ENTENDER                 2. ESCRIBIR                     3. SIN AYUDA
 Modo Tablas                 Modo A mano                     Las herramientas solas
 se completan campos         se escriben el .flex y el .cup  se escriben y se ejecutan
 minicomp genera y ejecuta   minicomp ejecuta los 5 pasos    los 5 pasos por consola
```

1. **Entender (modo Tablas).** Abrir minicomp: arranca ya compilado. Recorrer los resultados
   (Tokens → Árbol de derivación → AST decorado → Semántico → Código MIPS). Cambiar el programa
   (por ejemplo, `flag = false` o sacar un `;`) o una regla, y presionar **F5** para ver qué fase
   cambia o dónde falla.
2. **Escribir (modo A mano).** Pasar a **Modo: A mano**: aparecen el `lexer.flex` y el
   `parser.cup` reales del mismo ejemplo. Modificarlos (por ejemplo, agregar `while`), presionar
   **F5** y mirar **Pasos** (qué respondió cada herramienta) y **Contraste** (lo que escribiste
   contra lo que generaron JFlex y CUP).
3. **Sin ayuda.** Tocar **Abrir carpeta**: en `output/` ya están el `.flex`, el `.cup`, el
   programa y las herramientas. Repetir los 5 pasos por consola (ver
   [Las herramientas solas](#las-herramientas-solas-sin-minicomp)).

**Para entregar:** **Guardar** crea un archivo `.minicomp` con todo el trabajo: el modo, las
tablas o el `.flex`/`.cup`, y el programa. Ese único archivo es la entrega, y se vuelve a abrir
con **Abrir…**.

## Modo Tablas (puente automático)

A la izquierda:

- **1 · Léxico:** definiciones regulares y tabla *expresión regular → token*.
- **2 · Sintáctico:** la gramática en BNF.
- **3 · Semántico:**
  - casillas con las reglas que se verifican: variable declarada antes de usarse (siempre activa),
    condición del IF de tipo `boolean` (se puede desactivar para ver qué pasa), no declarar dos veces
    la misma variable, y advertir si una variable se usa sin valor;
  - la tabla de **asignación**: qué tipo de valor acepta cada tipo de variable;
  - las tablas de **operadores** (`+ - * /`, `> <`, `== !=`), que aparecen solas cuando la
    tabla léxica tiene alguna regla para un operador.

  Los tipos se llaman entero (`int`), real (`float`), cadena (`String`) y booleano (`boolean`).
- **Programa fuente.**

Los tokens que se pueden usar en la tabla léxica y en la gramática son:
`IMPRIMIR IF ELSE T_BOOLEANO T_ENTERO T_REAL T_CADENA ID LIT_ENTERO LIT_REAL LIT_CADENA
LIT_BOOLEANO ASIG PYC LPAREN RPAREN LLAVEA LLAVEC MAS MENOS POR DIV MAYOR MENOR MAYIG MENIG
IGUAL DIST`. Los **nombres** de los tokens son fijos; las expresiones regulares y la gramática
las define cada uno. La gramática se escribe así:

```
noTerminal -> alternativa1 | alternativa2      # comentario
            | alternativa3                     (una línea que empieza con | continúa la anterior)
```

`ε` o `eps` es la producción vacía, y el primer no terminal es el símbolo de arranque.

A la derecha, después de **▶ Compilar (F5)**: **Tokens**, **Árbol de derivación**, **AST
decorado**, **Semántico**, **Código MIPS** (con la salida de MARS) y **Herramientas** (el
`lexer.flex` y el `parser.cup` generados).

En **Herramientas** hay dos botones:

- **Abrir la carpeta con los archivos generados:** abre `output/tablas/`, donde quedan el
  `lexer.flex` y el `parser.cup` generados, lo que generaron JFlex, CUP y javac, y el `.asm`. Ojo: el
  `parser.cup` generado usa la clase `minicomp.Nodo`, así que para compilarlo fuera de minicomp
  hace falta `minicomp.jar` en el classpath.
- **Abrir lexer.flex en JFlex:** abre la ventana original de JFlex para importarlo.

## Modo A mano

A la izquierda se editan los archivos reales: **lexer.flex**, **parser.cup** y **Programa
fuente**. Cada uno tiene botones **Abrir…** (traer un archivo propio), **Guardar como…** y
**Restaurar ejemplo**.

**▶ Compilar (F5)** guarda los tres archivos en la carpeta **`output/`** y ejecuta los mismos 5
pasos que en la terminal, con las herramientas originales. A la derecha:

- **Pasos (consola):** cada comando y su salida, tal cual.
- **Contraste:** lo que escribiste vs. lo que generó cada herramienta, en líneas y estados.
- **Lexer.java**, **Parser.java** y **sym.java:** lo que generaron JFlex y CUP.
- **Código MIPS:** el `programa.asm` y lo que imprimió MARS.

Si un paso falla, se muestra su error y no se ejecutan los siguientes.

### Abrir los archivos en la ventana de cada herramienta

| Herramienta | ¿Tiene ventana? | Desde minicomp |
|---|---|---|
| **JFlex** | Sí | Botón **Abrir en JFlex** (pestaña lexer.flex): guarda el archivo, abre JFlex y copia la ruta |
| **CUP** | **No**: solo funciona por consola | Se ejecuta en el paso 2 |
| **MARS** | Sí | Botón **Abrir MARS** (pestaña Código MIPS): abre MARS y copia la ruta de `programa.asm` |

### La carpeta de trabajo: `output/`

Todo lo que generan minicomp y las herramientas queda en la carpeta **`output/`, al lado de
`minicomp.jar`** (se crea sola al compilar):

```
minicomp/
├── minicomp.jar
└── output/
    ├── lexer.flex, parser.cup, programa.txt       ← modo A mano: lo que escribís
    ├── Lexer.java, Parser.java, sym.java, *.class  ← lo que generan JFlex, CUP y javac
    ├── programa.asm                                ← el MIPS que genera el compilador
    ├── herramientas/                               ← copia de JFlex, CUP y MARS
    └── tablas/                                     ← modo Tablas: el .flex y el .cup generados,
                                                       lo que generan las herramientas y el .asm
```

**Abrir carpeta** (barra de arriba) la muestra en el explorador, y el botón con la ruta permite
elegir otra. Si minicomp está en una carpeta donde no se puede escribir, usa
`minicomp-trabajo` dentro de la carpeta personal.

**Qué se puede borrar:** todo lo que hay en `output/` se puede borrar cuando quieras, porque se
vuelve a generar al compilar. Lo que escribís queda en tu archivo `.minicomp` cuando usás
**Guardar**; `output/` solo tiene una copia para las herramientas. El `Lexer.java~` es una copia de
seguridad que deja JFlex cada vez que sobrescribe `Lexer.java`, y no sirve para nada.

## Las herramientas solas, sin minicomp

### Por consola

Desde la carpeta `output/`, que ya tiene todo lo necesario. También sirve cualquier carpeta con
`lexer.flex`, `parser.cup`, `programa.txt` y una copia de la carpeta `herramientas/` (está al lado
de `minicomp.jar`):

**Linux / Mac**

```bash
java -jar herramientas/jflex-full-1.9.1.jar lexer.flex                          # 1. JFlex → Lexer.java
java -jar herramientas/java-cup-11b.jar -parser Parser -symbols sym parser.cup  # 2. CUP → Parser.java + sym.java
javac -cp herramientas/java-cup-11b-runtime.jar *.java                          # 3. compilar
java -cp .:herramientas/java-cup-11b-runtime.jar Parser programa.txt            # 4. compilar el programa → programa.asm
java -jar herramientas/Mars4_5.jar nc programa.asm                              # 5. ejecutarlo en MARS
```

**Windows** (`cmd` o PowerShell). Cambian las barras `\` y el separador del classpath, que es
**`;`** en lugar de `:`:

```bat
java -jar herramientas\jflex-full-1.9.1.jar lexer.flex
java -jar herramientas\java-cup-11b.jar -parser Parser -symbols sym parser.cup
javac -cp herramientas\java-cup-11b-runtime.jar *.java
java -cp .;herramientas\java-cup-11b-runtime.jar Parser programa.txt
java -jar herramientas\Mars4_5.jar nc programa.asm
```

En PowerShell, el classpath del paso 4 va entre comillas: `-cp ".;herramientas\java-cup-11b-runtime.jar"`.

Si se cambia `lexer.flex` o `parser.cup`, hay que repetir desde el paso 1. Si solo se cambia
`programa.txt`, alcanza con los pasos 4 y 5.

### Con la ventana de cada herramienta

**JFlex** (Windows: doble clic en `jflex-full-1.9.1.jar`; Linux: `java -jar herramientas/jflex-full-1.9.1.jar`):

1. **Lexical specification → Browse:** elegir `lexer.flex`.
2. **Output directory → Browse:** la misma carpeta.
3. **Generate:** escribe `Lexer.java`. Los mensajes (estados del AFN y del AFD) aparecen abajo.

**CUP:** no tiene ventana. Siempre se usa con el comando del paso 2.

**MARS** (Windows: doble clic en `Mars4_5.jar`; Linux: `java -jar herramientas/Mars4_5.jar`):

1. **File → Open:** elegir `programa.asm` (generado en el paso 4).
2. **Run → Assemble** (F3).
3. **Run → Go** (F5), o de a una instrucción con **F7**.
4. La salida aparece abajo, en **Run I/O**. En **Registers** se ve cómo cambia `$t0`, y en
   **Data Segment**, las variables (`v_flag`).

## Cosas para probar

| Cambio | Qué pasa |
|---|---|
| `flag = false` (`01_rama_else.txt`) | MARS imprime `Error` (se ejecuta el ELSE) |
| `System.out.println` en minúsculas (`02_error_lexico.txt`) | Error **léxico**: carácter no reconocido `.` |
| Sacar un `;` (`03_error_sintactico_falta_pyc.txt`) | Error **sintáctico**: no se esperaba `}`. Se esperaba: PYC. Se informa en la línea siguiente: ahí es donde el parser se da cuenta |
| Borrar la declaración de `flag` (`04_error_semantico_no_declarada.txt`) | Error **semántico**: `flag` no fue declarada |
| `int flag = 5;` (`05_error_semantico_condicion_int.txt`) | Error **semántico**: la condición del IF tiene que ser boolean |
| `boolean flag = 5;` (`06_error_semantico_asignacion.txt`) | Error **semántico**: no se puede asignar un int a una variable boolean |
| Modo Tablas: desmarcar la regla del IF y usar `int flag = 5;` | Pasa el semántico y MARS imprime `Hola Mundo!`: `beqz` toma cualquier valor distinto de 0 como verdadero, igual que en C |
| Modo A mano: agregar `"while" { return token(sym.WHILE); }` al `.flex` y `WHILE` a los `terminal` del `.cup` | El AFD pasa de 60 a 65 estados y CUP avisa *"1 terminal declared but not used"* |
| Modo Tablas: subir la fila de `ID` a la primera posición | Las palabras reservadas salen como ID: error sintáctico |
| Modo Tablas: cambiar `ELSE condicional` por `ELSE lista` | CUP informa un **conflicto Shift/Reduce** |

Los programas que tienen nombre de archivo están en la carpeta `ejemplos/`. Se abren con
**Abrir archivo…** en la pestaña Programa fuente.

## Probar por consola, sin abrir la ventana

```bash
java -jar minicomp.jar --consola mi_trabajo.minicomp                 # con el programa guardado en el trabajo
java -jar minicomp.jar --consola mi_trabajo.minicomp otro.txt        # con otro programa
java -jar minicomp.jar --consola minimo ejemplos/02_error_lexico.txt # con el caso inicial
```

Muestra el resultado de cada fase (o de cada paso, en modo A mano). En modo Tablas, agregando
`--mars` al final también ejecuta el programa en MARS; en modo A mano MARS se ejecuta siempre,
porque es el paso 5.

## Problemas comunes

| Problema | Solución |
|---|---|
| *"No se encontró javac"* o `javac` no se reconoce | Está instalado solo el JRE: hace falta el **JDK** (por ejemplo, Eclipse Temurin 17 o 21) |
| Windows: `java` no se reconoce como comando | Java no está en el PATH: reinstalar el JDK marcando la opción de agregarlo al PATH, o abrir `minicomp.jar` con doble clic |
| El doble clic en `minicomp.jar` lo abre como un `.zip` | Clic derecho → Abrir con → Java (TM) Platform SE binary, o usar `java -jar minicomp.jar` |
| Error léxico en línea 1, columna 1, con un carácter invisible | Es la marca BOM que agregan algunos editores (como el Bloc de notas) al guardar. minicomp ya la ignora; si aparece en un `.flex` escrito a mano, agregar la regla `\uFEFF { }` |
| En modo A mano falla el paso 3 (javac) con *"cannot find symbol — symbol: variable XXX"* en `Lexer.java` | El token `XXX` se usa en el `.flex` pero no está en la lista de `terminal` del `.cup` |

## Estructura

```
minicomp/
├── minicomp.jar          la aplicación (trae adentro JFlex, CUP y MARS originales)
├── LICENCIAS.txt         licencias de JFlex (BSD), CUP y MARS (MIT)
├── README.md
├── herramientas/         JFlex 1.9.1, CUP 11b y MARS 4.5, tal cual se descargan (para usarlos sin minicomp)
├── ejemplos/             la rama ELSE y un error de cada fase
└── output/               lo que se genera al compilar (se crea sola; se puede borrar)
```
