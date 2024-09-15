# Entrega Final del proyecto WP01

## Integrantes 

Juan Manuel Beltrán Botello

Oscar Jhondairo Siabato León

Willian Mauricio Meza Patiño

Jhon Alejandro Cuaspud


# Propuesta Inicial para el Proyecto en FPGA: 
Implementación de un Tamagotchi
Introducción: En este proyecto, proponemos  implementar un Tamagotchi en una FPGA Cyclone IV. El Tamagotchi será una mascota virtual que responderá a la interacción del usuario mediante botones y a estímulos ambientales a través de sensores de sonido y luz. La salida del sistema incluirá un display de 7 segmentos para mostrar los niveles y puntuación de la mascota, así como una pantalla LCD de 16x2 para representar su estado gráficamente.

## Objetivos:

Diseñar e implementar un sistema de interacción para el usuario mediante cinco botones: alimentar, premiar, regañar, reset y test.
Integrar dos sensores, uno de sonido para detectar cuando la mascota es despertada y otro de luz para determinar si es de día o de noche.
Desarrollar la lógica de control para coordinar las interacciones del usuario y los estímulos ambientales.
Implementar salidas visuales utilizando un display de 7 segmentos y una pantalla LCD de 16X2 para representar el estado y la puntuación de la mascota.
Optimizar el diseño para minimizar el uso de recursos en la FPGA Cyclone IV.
## Especificacion de los componentes para el proyecto 

## Perifericos

sensor rgb TCS34725 (no fue implementado debido a limite de tiempo en el cronograma)

sensor medidor de distancia ultrasonido Hc-sr4

sensor de vibracion sw-420

Sensor de movimiento  PIR HC-SR501

Pantalla LCD 16X2 

Display 7 seg 

4 interruptores

## sensor rgb TCS34725


<img src= IMAGENES/TCS.png>

Especificaciones  

Voltaje de operación: 2.7V a 3.6V (recomendado: 3.3V).

Corriente de operación:

Modo activo: 60 µA.

LED activado: 240 µA.

Modo espera: < 2.5 µA.

Protocolo de comunicación: I2C (7 bits, hasta 400 kHz).

Rango de detección de colores:

Rojo: 610 - 720 nm.

Verde: 495 - 570 nm.

Azul: 450 - 495 nm.

Luz clara: Para la medición de la luminosidad ambiental.

Resolución de salida: ADC de 16 bits por canal (Rojo, Verde, Azul, Claro).

Tiempo de integración: 2.4 ms a 700 ms (ajustable).

LED interno: LED blanco para mejorar la precisión bajo condiciones de baja luz.

Campo de visión: 35°.

Dimensiones: 3.94 mm x 2.84 mm x 1.35 mm.

Temperatura de operación: -30°C a +85°C.

Distancia de detección: Óptima a 5-10 mm.

Funcionalidad

El sensor TCS34725 se empleará para que la mascota virtual interactúe de manera más amigable con su dueño, proporcionando una experiencia basada en la detección de colores específicos. Cada color detectado por 
el sensor influirá en el comportamiento y el estado de la mascota de la siguiente manera:



Color Azul:

Simulación: Representa el suministro de agua a la mascota.
Efecto: Cuando el sensor detecte el color azul, se interpretará como si la mascota estuviera bebiendo agua, lo que contribuye a mantener su nivel de salud.

Color Verde:

Simulación: Indica la alimentación de la mascota.
Efecto: La detección del color verde indicará que la mascota está siendo alimentada, ayudando a satisfacer su hambre.

Color Rojo:

Simulación: Representa interacciones afectivas entre el dueño y la mascota, como abrazos.

Efecto: La presencia del color rojo aumentará el nivel de felicidad de la mascota, reflejando el cariño y la atención que recibe de su dueño. Este color también permitirá que la mascota salga del estado de tristeza.

Implementación en HDL y Conexión

1. Módulo I2C en HDL:
Se implementará un módulo I2C en código Verilog para gestionar la comunicación entre la FPGA y el sensor TCS34725. Este módulo manejará el intercambio de datos de color detectados por el sensor hacia la lógica del sistema Tamagotchi.

2. Manejo de Datos:
La lógica en Verilog interpretará los datos RGB recibidos del sensor y los transformará en las acciones descritas dentro del juego del Tamagotchi. Por ejemplo, si se detecta el color verde, la mascota interpretará que está siendo alimentada.

3. Alimentación y Conexiones Físicas:

Pines de Alimentación:

VCC: El sensor requiere una fuente de alimentación de 3.3V que será proporcionada por la FPGA.

GND: Este pin debe conectarse a la tierra (GND) en la FPGA.

Pines de Comunicación I2C:

SCL (Serial Clock Line): Este pin controla el reloj del bus I2C y debe conectarse al pin SCL correspondiente de la FPGA.

SDA (Serial Data Line): Este pin es la línea de datos del bus I2C y debe conectarse al pin SDA de la FPGA.



## Sensor medidor de distancia ultrasonido Hc-sr4

<img src= "IMAGENES/Sensor Ultrasonid.png">

Voltaje de operación: 5V.

Corriente de operación: <2 mA en reposo, 15 mA en operación

Dimensiones: 32mm x 20mm2.

Ángulo de detección: 30°.

Distancia de medición: Entre 2 cm y 400 cm

Resolución: 0,3 cm

### Funcionamiento 

El sensor HC-SR04 utiliza ondas ultrasónicas para medir la distancia entre él y un objeto. El principio de funcionamiento se basa en la emisión de un pulso ultrasónico que viaja en el aire, rebota en el objeto, y regresa al sensor. El dispositivo mide el tiempo que tarda en regresar el pulso para calcular la distancia mediante la ecuación de distancia:

d = v × t,
donde:

d es la distancia,
v es la velocidad del sonido (aproximadamente 343 m/s en condiciones normales),
t es el tiempo medido.

<img src= "IMAGENES/funcionamaiento del sensor ultrasonico.png">


### Funcionalidad 

El sensor ultrasónico HC-SR04 se utiliza en el proyecto para medir la proximidad entre la mascota virtual (Tamagotchi) y el usuario. La "caricia" se simula detectando que la mano del usuario está a una distancia cercana al sensor, lo que luego se traduce en una interacción positiva que afecta el estado de la mascota, como aumentar su nivel de felicidad.

<img src= "señal cuadrada del sensor ultrasonico.png">

Trigger Input to Module:
El proceso comienza cuando la FPGA envía una señal de disparo (TRIG) al sensor durante 10 microsegundos (como muestra la primera parte del gráfico). Este pulso activa el sensor, que emite una ráfaga de ondas ultrasónicas de 8 ciclos a 40 kHz, señalada en la imagen como "8 Cycle Sonic Burst".

Echo Pulse Output:
Después de que la ráfaga ultrasónica es emitida, el sensor espera a recibir el eco del pulso que rebota en el objeto cercano (la mano del usuario). La señal ECHO se pone en alto cuando el sensor detecta el retorno de la onda, y se mantiene en alto por un período de tiempo proporcional a la distancia. Este comportamiento es lo que se representa en la parte inferior del gráfico como "Echo Pulse Output". El tiempo que la señal permanece en alto indica la proximidad del objeto.

Interpretación de la "Caricia":
Para simular una caricia, la FPGA mide el tiempo en que el pin ECHO permanece en alto. Si el tiempo de retorno del eco indica que la mano del usuario está dentro de un rango específico (por ejemplo, entre 5 cm y 15 cm), se interpreta como una caricia. En este caso, la mascota virtual reaccionará de forma positiva, como si el usuario estuviera acariciándola.

El tiempo medido en microsegundos se convierte en distancia utilizando la fórmula:

Distancia (cm)
=
𝑇
𝑖
𝑒
𝑚
𝑝
𝑜
_
𝑚
𝑒
𝑑
𝑖
𝑑
𝑜
58
Distancia (cm)= 
58
Tiempo_medido
​
 
Si la distancia está dentro del rango definido, se ejecuta la acción de la "caricia", afectando el comportamiento de la mascota en el juego.


##### Pines de Alimentación

VCC (Alimentación 5V):Este pin se conecta a una fuente de 5V para alimentar el sensor.

GND (Tierra):Debe conectarse al pin de tierra (GND) en la FPGA para completar el circuito de alimentación.

TRIG (Disparo):El pin TRIG se conecta a un GPIO de la FPGA configurado como salida. Para activar la medición de distancia, la FPGA debe enviar una señal de 10 microsegundos en alto, lo que generará una ráfaga de ondas ultrasónicas.

ECHO (Recepción del eco):El pin ECHO se conecta a otro GPIO de la FPGA configurado como entrada. Este pin permanecerá en alto durante el tiempo que tarda el eco en regresar. El tiempo en alto se usa para calcular la distancia al objeto.

### Implementación HDL y Conexión

<img src= "conecciones del ultrasonico.png">

El flujo de la implementación en Verilog sería algo similar a lo siguiente:

Generación de señal TRIG: Crear un módulo en Verilog que controle el tiempo de activación del pin TRIG (10 µs).

Medición del tiempo ECHO: Implementar un temporizador que comience a contar cuando el pin ECHO se pone en alto y se detenga cuando vuelva a estar en bajo.

Cálculo de la distancia: Transformar el tiempo medido en la distancia correspondiente y almacenarla para su uso en la lógica del Tamagotchi.


## Sensor de movimiento PIR HC-SR501
Para implementar este sensor, necesitaremos lo siguiente:
<img src= "IMAGENES/SENSOR PIR .png">

•	Voltaje de Alimentación: 4.5V a 12V DC

•	Voltaje de Salida (TTL): 3.3V

•	Distancia de Detección: 3 a 7 metros aproximadamente

•	Ángulo de Detección: 90° a 110°

•	Intervalo de Tiempo de Alarma: 5 segundos a 5 minutos (ajustable)

•	Dimensiones: 32.7mm x 29mm

•	Corriente de Reposo: <50 µA

•	Tiempo de Retardo: 5 segundos a 18 segundos (ajustable)

•	Tiempo de Bloqueo: 2.5 segundos (predeterminado)

•	Temperatura de Funcionamiento: -15°C a +70°C

 
### Funcionamiento 
<img src= "IMAGENES/RENDIJA .png">

Los sensores de movimiento PIR constan de dos partes principales: un elemento sensor piroeléctrico y una lente fresnel. El elemento sensor piroeléctrico puede detectar la radiación infrarroja. Todos los objetos con una temperatura superior al cero absoluto (0 Kelvin / -273,15 °C) emiten energía térmica en forma de radiación infrarroja, incluidos los cuerpos humanos. Un sensor piroeléctrico tiene dos ranuras rectangulares de un material que permite el paso de la radiación infrarroja. Detrás de ellas, hay dos electrodos de sensor de infrarrojos separados, uno responsable de producir una salida positiva y el otro una salida negativa. Se busca  un cambio en los niveles de IR (infrarrojos) y no en los niveles de IR del ambiente. Los dos electrodos están conectados para que se anulen mutuamente. Si una mitad ve más o menos radiación IR que la otra, la salida oscilará alta o baja.
El circuito integrado de procesamiento de señales procesa esta señal y convierte el pin de salida del sensor en ALTO o BAJO en consecuencia.
### Ajuste del sensor
<img src= "IMAGENES/PIR R.png">
 
#### Ajuste de la sensibilidad (rango)
El HC-SR501 tiene una distancia máxima de detección de 7 metros. Puede ajustar la distancia de detección girando el potenciómetro de sensibilidad en el sentido de las agujas del reloj o en el sentido contrario (véase la imagen anterior). Al girar el potenciómetro en el sentido de las agujas del reloj, la distancia de detección aumenta hasta un máximo de 7 metros. Si se gira en sentido contrario a las agujas del reloj, la distancia de detección disminuye hasta un mínimo de 3 metros.
#### Ajuste del tiempo de retardo (Tx)
Con este potenciómetro se puede ajustar el tiempo que la salida permanece en ALTO tras la detección de movimiento. Como mínimo, el retardo es de 3 segundos y como máximo, de 300 segundos o 5 minutos. Gire el potenciómetro en el sentido de las agujas del reloj para aumentar el retardo y en el sentido contrario para disminuirlo.
#### Puente de selección de disparo
El puente (amarillo) permite seleccionar uno de los dos modos de disparo. Puede ajustarse a L (disparo simple) o H (disparo repetido):

•	Disparo simple - La salida se pondrá en ALTO en cuanto se detecte movimiento. Permanecerá en ALTO durante el tiempo establecido por el potenciómetro. Cualquier movimiento durante este periodo no se procesa y no reinicia el temporizador.

•	Disparo repetido - Cada vez que se detecta movimiento, el temporizador de retardo se reinicia.

La diferencia entre el modo de disparo simple y el repetitivo se muestra en la siguiente figura.
<img src= "IMAGENES/TIEMPO.png">

### Funcionalidad 

El sensor de movimiento PIR HC-SR501 enriquece la interacción entre la mascota virtual y su entorno, facilitando respuestas automáticas a la presencia o ausencia de personas. Este sensor juega un papel crucial en la regulación de los estados de actividad y descanso de la mascota, asegurando una experiencia más realista y adaptativa para el usuario.

##### Modo de Descanso Automático:

Si no se detecta movimiento en el rango del sensor durante un período establecido, el sensor envía una señal a la FPGA para que la mascota virtual entre en modo de descanso, simbolizando que la mascota está durmiendo.

Este modo permite que la mascota virtual conserve energía y reduzca sus actividades, imitando un comportamiento natural de descanso después de periodos de juego o actividad prolongada.

##### Despertar y Activación:

Cuando una persona entra en el rango de detección del sensor, este activa la mascota virtual, despertándola de su estado de descanso. La mascota se activa inmediatamente, estando lista para interactuar con el dueño.

### Implementación HDL y Conexión

En el entorno de desarrollo FPGA, se configura el pin seleccionado para que funcione como entrada digital, dependiendo del estado de esta señal se activara las funciones anteriormente descritas, además cuando se detecta un flanco ascendente, indicara movimiento utilizando un disparo simple. 

##### Pines de Alimentación

•	VCC: Fuente de alimentación de 5V en la FPGA.

•	GND: Tierra en la FPGA.

•	OUT: Pin configurado como entrada en la FPGA, proporciona una salida digital, lo que significa que sólo tiene dos estados posibles: alto (1) y bajo (0).


## Pantalla LCD 16X2
<img src= "IMAGENES/LCD.png">

•	Voltaje de Operación: 4.7V a 5.3V

•	Corriente de Operación: 1mA (sin retroiluminación)

•	Retroiluminación: LED  azul

•	Número de Caracteres: 32 (16 caracteres por cada una de las 2 filas)

•	Tamaño de Caracteres: 5x8 puntos por carácter

•	Interfaz: 8 bits (puede configurarse para usar solo 4 bits)

•	Controlador: HD44780 o compatible

•	Ciclo de Trabajo: 1/16 duty cycle

•	Temperatura de Operación: -20°C a +70°C

<img src= "IMAGENES/CAJALCD.png">

### Funcionamiento

1.	Inicialización:
•	El MPU envía una serie de comandos de inicialización al controlador de la pantalla para configurar el modo de operación (4 bits o 8 bits), el número de líneas y el tipo de fuente.
2.	Envío de Datos y Comandos:
•	El MPU utiliza los pines RS, R/W y E para seleccionar y enviar datos o comandos a través de los pines de datos (DB0-DB7).
3.	Visualización:
•	El controlador interpreta los datos y comandos recibidos y actualiza la pantalla en consecuencia, mostrando los caracteres en las posiciones especificadas.

### Funcionalidad 

La pantalla LCD 16x2 juega un papel fundamental en la interacción entre el usuario y su mascota virtual, proporcionando una interfaz visual que muestra de forma clara y directa el estado emocional y físico de la mascota.

##### Visualización de Estados Emocionales y Físicos

La pantalla está configurada para mostrar emojis y mensajes que representan diferentes estados emocionales y físicos de la mascota, tales como:

•	Feliz: Indica que la mascota está contenta y satisfecha.

•	Triste: Refleja que la mascota necesita más atención o cariño.

•	Enfermo: Muestra que la mascota requiere cuidados médicos o descanso.

•	Hambriento: Alerta al usuario de que es necesario alimentar a la mascota.

•	Cansado: Sugiere que la mascota necesita dormir o descansar.

•	Aburrido: Señala que la mascota necesita más interacción o jugar.

Dependiendo de cómo el usuario interactúa con la mascota virtual (alimentación, juego, descanso), la pantalla actualizará dinámicamente los íconos o mensajes para reflejar el nuevo estado de la mascota. Esto permite al usuario entender inmediatamente las consecuencias de sus acciones y ajustar su comportamiento para mejorar el bienestar de la mascota.

### Implementación HDL y Conexión

Se desarrolla una descripción en Verilog que gestione la comunicación con el LCD. Se incluye una lógica para inicializar el display, escribir comandos y agregar caracteres especiales que respondan según las señales que se envíen desde la FPGA, asegurándose de mostrar el estado en que se encuentre la mascota. 

### Componentes y conexiones

#### Microprocesador (MPU):

Función: Controla la pantalla enviando comandos y datos.

Conexiones: Se conecta a los pines RS, R/W, E y DB0-DB7 de la pantalla.

##### Pines de Alimentación

•	VCC: Fuente de alimentación de 5V en la FPGA.

•	GND: Tierra en la FPGA.

##### Pines de Control:

RS (Registro de Selección): Selecciona entre comandos (0) y datos (1).

R/W (Lectura/Escritura): Selecciona entre lectura (1) y escritura (0).

E (Enable): Habilita la comunicación con la pantalla.

##### Pines de Datos (DB0-DB7):

Función: Transmiten los datos y comandos entre el MPU y la pantalla.

Modo de Operación: Puede operar en modo de 4 bits (DB4-DB7) o 8 bits (DB0-DB7).

##### Controlador/Driver IC (ICST7066U-0L-BT-BC o equivalente):

Función: Interpreta los comandos y datos del MPU y controla la pantalla.

Conexiones: Internamente conectado a los pines de datos y control de la pantalla


## Display de 7 segmentos (ánodo común)
<img src= "IMAGENES/DISPLAY7R.png">
•    Display 7 Segmentos

•    Componente de 1 Dígito con Punto Decimal

•    Tipo Display: Ánodo Común

•    Tamaño del Dígito: 2.3 Pulgadas (58.80 mm) Ver imágenes para detalles

•    Tensión Directa por Segmento (Vf): 7.2 a 8.5 VDC (excluye punto decimal)

•    Tensión Directa Punto Decimal (Vf): 3.6 a 4.2 VDC

•    Tensión Inverso Máxima: 3 VDC

•    Corriente por Segmento Máxima: 30 mA

•    Corriente de Operación por Segmento Recomendada: 12 mA

### Componentes y Pines:

<img src= "IMAGENES/DISPLAYD.png">
•	Segmentos (a-g): Cada uno de los siete segmentos que forman los números.
•	Punto Decimal (dp): Opcional, utilizado para mostrar números decimales.
•	Pines de Conexión: 4pines, incluyendo los pines comunes y los pines de cada segmento.

### Funcionamiento

•	Control de Segmentos: Cada segmento se enciende o apaga para formar los números del 0 al 9 y algunas letras.

•	Interfaz: Puede ser controlado directamente por un microcontrolador o mediante un decodificador BCD a 7 segmentos.

## Interruptor táctil (push button)
<img src= "IMAGENES/PULSADOR .png">
•	Voltaje de operación: 3.3V a 5V.

•	Corriente de operación:  Típica: 50mA.  Máxima: 100mA.

•	Operación: -20°C a 70°C.

### Funcionalidad 

Los displays de 7 segmentos en nuestro proyecto actúan como paneles de información crucial, mostrando de manera efectiva los niveles estadísticos que reflejan el bienestar de la mascota virtual. Estos niveles varían de 1 a 5 y representan diferentes aspectos del estado de la mascota, incluyendo hambre, diversión, descanso, salud y felicidad.

•	Hambre: Indica si está llena o hambrienta la mascota.

•	Diversión: Refleja cuánta diversión está recibiendo la mascota.

•	Descanso: Muestra cuán descansada está la mascota.

•	Salud: Señala el estado de salud general de la mascota.

•	Felicidad: Expresa el nivel de felicidad de la mascota.

A medida que el dueño interactúa con la mascota, estos niveles pueden aumentar o disminuir. Por ejemplo, alimentar a la mascota incrementará el nivel de hambre, mientras que jugar con ella aumentará su nivel de diversión y felicidad.

### Implementación HDL y Conexión

Cada display está controlado directamente desde la FPGA, la cual envía señales para ajustar los valores mostrados en función de las interacciones realizadas con la mascota virtual mediate la descripción de hardware. Los cambios en los niveles se reflejan inmediatamente en los displays de 7 segmentos, proporcionando retroalimentación instantánea al dueño sobre las necesidades actuales de la mascota.

##### Pines de Alimentación

•	VCC: Fuente de alimentación de 5V en la FPGA.

•	GND: Tierra en la FPGA.

## Caja Negra 

El diagrama representa un sistema  compuesto por tres módulos principales: Sensores, Botones y Visualización. Los sensores incluyen un sensor de movimiento y un sensor de colores que comunican mediante el protocolo I2C. El módulo de botones, que incluye opciones como Jugar, Curar, Reset y Test, está conectado a un sistema de debouncing para gestionar las entradas de forma precisa. Las salidas visuales se manejan a través de un display de 7 segmentos y un LCD de 16x2. Además, un divisor de frecuencia regula las interacciones de tiempo en el sistema, garantizando la sincronización y el correcto despliegue de información.

<img src= "IMAGENES/caja negra.jpg">

## Diagrama de flujo

El diagrama de flujo describe un sistema de juego donde se simula el cuidado de una mascota virtual  que determinan su estado de bienestar: Hambre, Diversión, Energía, Salud y Felicidad, todas iniciando en 5. Estas se afectan con el tiempo, y el jugador debe intervenir para mantenerlas dentro de rangos saludables.

1. **Hambre**: Si el nivel de Hambre cae por debajo de 2, la mascota se muestra hambrienta. El jugador debe alimentarla para evitar que la Salud y la Felicidad no disminuyan.

2. **Diversión**: Al reducirse la Diversión por debajo de 2, la mascota se considera aburrida. El jugador puede optar por jugar con la mascota para aumentar su Felicidad y restablecer su Diversión.

3. **Energía**: Si la Energía disminuye a menos de 2, la mascota entra en un estado cansado, necesitando dormir para recuperar Energía y Salud.

4. **Salud**: Un nivel de Salud por debajo de 2 indica que la mascota está enferma. Debe ser curada, o de lo contrario la Salud continuará disminuyendo, pudiendo resultar en la muerte de la mascota si la Salud llega a cero.

5. **Felicidad**: Si la Felicidad cae por debajo de 2, la mascota se pone triste, lo que puede afectar adicionalmente su Salud. Acariciar a la mascota o atender sus otras necesidades puede restaurar la Felicidad.

Si alguna de las condiciones críticas como la Salud llega a cero, la mascota muere, y el juego requiere que se realice un reinicio. Este sistema de juego enseña sobre el cuidado y la atención necesaria para mantener el bienestar de un ser, aunque sea virtual, enfatizando la importancia de la observación y la respuesta a las necesidades de los que dependen de nosotros.

<img src= "IMAGENES/Diagrama de flujo.jpg">


## maquina de estados.

Estado Inicial: La mascota comienza con niveles equilibrados de salud, energía, diversión, hambre y felicidad.

Transiciones:
 
Si alguno de estos niveles baja demasiado, la mascota cambia a un estado específico, como Hambriento, Aburrido, Cansado, Enfermo, o Triste.
Los usuarios pueden realizar acciones como alimentar, jugar o curar, que restauran esos niveles y devuelven la mascota al estado Saludable.

Estado Final: Si la salud de la mascota llega a cero, entra en el estado Muere, concluyendo la simulación.

Importancia:

Esta FSM permite que la mascota reaccione de forma dinámica a las interacciones del usuario y a las condiciones de su entorno, ofreciendo una experiencia interactiva y educativa que simula el cuidado de una mascota real.

<img src= "IMAGENES/maquina de estados .png">


