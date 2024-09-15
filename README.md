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

sensor medidor de distancia ultrasonido Hc-sr4

sensor de vibracion sw-420

Sensor de movimiento  PIR HC-SR501

Pantalla LCD 16X2 

Display 7 seg 

4 interruptores

## Sensor medidor de distancia ultrasonido Hc-sr4

<img src= "TCS.png">

Voltaje de operación: 3.3V a 5V.

Corriente de operación: 235 µA.

Interfaz de comunicación: I2C

Resolución: 16 bits por canal (RGB y Clear).

Dimensiones: 27mm x 20mm2.

Distancia de medición recomendada: 2mm

Rango dinámico: 3,800,000:1

Temperatura de operación: -30°C a +70°C3

### Funcionamiento 

<img src= "CAJA.png">
Como se puede observar en el diagrama de bloques el sensor RGB TCS 34725 funciona filtrando la luz por medio de un filtro IR (Infrarrojo) que permite que pase solo las longitudes de onda de luz del espectro visible. La luz filtrada llega a unos fotodiodos que detectan las longitudes de onda correspondientes, enviando una señal de corriente. Las diferentes longitudes de onda producen diferentes niveles de corriente. Los colores que se pueden detectar por medio de estos fotodiodos son el rojo, verde y azul También se detecta una longitud de onda de claridad.
<img src= "ESPECTRO.png">
Por medio del conversor de análogo a Digital (ADC) las longitudes de onda se convierten a valores digitales y son guardados en registros. Los datos guardados van a ser leídos para determinar el color detectado.

### Diagrama de estados

<img src= "DIAGRAMA DE.png">
1.	Sleep

•	Estado Inicial: El sensor está en modo de bajo consumo y no realiza ninguna medición.

•	Transición a Idle: Ocurre cuando se recibe una señal de inicio (I2C Start).

2.	Idle
   
•	Estado de Espera: El sensor está listo para comenzar una medición, pero no está activo.

•	Transición a Wait: Ocurre cuando se habilita el sensor (WEN y AEN están activos).

WEN(Wait enable): Habilita el temporizador de espera del sensor 
AEN(RGBC Enable):Habilita el convertidor analogico digital.
3.	Wait:
   
•	Estado de Espera Activa: El sensor espera durante un tiempo configurado (WTIME) antes de iniciar la medición.

•	Transición a RGBC Init: Después de esperar el tiempo configurado, el sensor se prepara para la medición.

4.	RGBC Init:
   
•	Preparación: El sensor se inicializa para comenzar la medición de los canales de color.

•	Transición a RGBC ADC: Una vez inicializado, el sensor comienza la conversión analógica a digital (ADC).

5.	RGBC ADC:
   
•	Medición: El sensor mide las intensidades de luz en los canales claro, rojo, verde y azul.

•	Tiempo de Integración: Configurable entre 2.4 ms y 614 ms.

•	Transición a Idle: Después de completar la medición, el sensor vuelve al estado inactivo.


### Funcionalidad 

El sensor TCS34725 se empleará para que la mascota virtual interactúe de manera más amigable con su dueño, teniendo una experiencia basada en la detección de colores específicos. Cada color detectado por el sensor influirá en el comportamiento y el estado de la mascota de la siguiente manera:

##### Color Azul:
Se utilizará para simular el suministro de agua a la mascota. Cuando el sensor detecte el color azul, se interpretará como si la mascota estuviera bebiendo agua, lo que contribuirá a mantener su nivel de salud.

##### Color Verde: 
Este color será indicativo de alimentación. La detección del verde indicará que la mascota está siendo alimentada, lo que ayudará a satisfacer su hambre.

##### Color Rojo: 
Se usará para representar interacciones afectivas entre el dueño y la mascota como abrazos. La presencia del color rojo aumentará su nivel de felicidad, reflejando el cariño y la atención que recibe de su dueño. Además, con este color podrá salir del estado de tristeza. 


### Implementación HDL y Conexión


##### 1.	Módulo I2C en HDL: 
Se implementa un módulo existente I2C en código Verilog para manejar la comunicación entre la FPGA y el sensor TCS34725.

##### 2.	Manejo de Datos: 
Se desarrolla una lógica en Verilog que interprete los datos recibidos del sensor y los transforme en las acciones anteriormente descritas dentro del juego del Tamagotchi.

##### 3.	Alimentación y Conexiones Físicas: 
A continuación, especificaremos las conexiones que el sensor necesita para que esté correctamente alimentado y conectado a los pines I2C de la FPGA.

##### Pines de Alimentación

•	VCC: Fuente de alimentación de 3.3V en la FPGA.

•	GND: Tierra en la FPGA.

##### Pines de Comunicación I2C
El TCS34725 utiliza el protocolo I2C para la comunicación de datos, lo que significa que tiene pines específicos para esta función:

1.	SCL (Serial Clock Line): Es el reloj del bus I2C. Este pin se conecta al pin correspondiente de SCL en la FPGA.
   
3.	SDA (Serial Data Line): Es la línea de datos del bus I2C. Este pin se conecta al pin correspondiente de SDA en la FPGA.



## Sensor de movimiento PIR HC-SR501
Para implementar este sensor, necesitaremos lo siguiente:
<img src= "SENSOR PIR .png">

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
<img src= "RENDIJA .png">

Los sensores de movimiento PIR constan de dos partes principales: un elemento sensor piroeléctrico y una lente fresnel. El elemento sensor piroeléctrico puede detectar la radiación infrarroja. Todos los objetos con una temperatura superior al cero absoluto (0 Kelvin / -273,15 °C) emiten energía térmica en forma de radiación infrarroja, incluidos los cuerpos humanos. Un sensor piroeléctrico tiene dos ranuras rectangulares de un material que permite el paso de la radiación infrarroja. Detrás de ellas, hay dos electrodos de sensor de infrarrojos separados, uno responsable de producir una salida positiva y el otro una salida negativa. Se busca  un cambio en los niveles de IR (infrarrojos) y no en los niveles de IR del ambiente. Los dos electrodos están conectados para que se anulen mutuamente. Si una mitad ve más o menos radiación IR que la otra, la salida oscilará alta o baja.
El circuito integrado de procesamiento de señales procesa esta señal y convierte el pin de salida del sensor en ALTO o BAJO en consecuencia.
### Ajuste del sensor
<img src= "PIR R.png">
 
#### Ajuste de la sensibilidad (rango)
El HC-SR501 tiene una distancia máxima de detección de 7 metros. Puede ajustar la distancia de detección girando el potenciómetro de sensibilidad en el sentido de las agujas del reloj o en el sentido contrario (véase la imagen anterior). Al girar el potenciómetro en el sentido de las agujas del reloj, la distancia de detección aumenta hasta un máximo de 7 metros. Si se gira en sentido contrario a las agujas del reloj, la distancia de detección disminuye hasta un mínimo de 3 metros.
#### Ajuste del tiempo de retardo (Tx)
Con este potenciómetro se puede ajustar el tiempo que la salida permanece en ALTO tras la detección de movimiento. Como mínimo, el retardo es de 3 segundos y como máximo, de 300 segundos o 5 minutos. Gire el potenciómetro en el sentido de las agujas del reloj para aumentar el retardo y en el sentido contrario para disminuirlo.
#### Puente de selección de disparo
El puente (amarillo) permite seleccionar uno de los dos modos de disparo. Puede ajustarse a L (disparo simple) o H (disparo repetido):

•	Disparo simple - La salida se pondrá en ALTO en cuanto se detecte movimiento. Permanecerá en ALTO durante el tiempo establecido por el potenciómetro. Cualquier movimiento durante este periodo no se procesa y no reinicia el temporizador.

•	Disparo repetido - Cada vez que se detecta movimiento, el temporizador de retardo se reinicia.

La diferencia entre el modo de disparo simple y el repetitivo se muestra en la siguiente figura.
<img src= "TIEMPO.png">

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
<img src= "LCD.png">

•	Voltaje de Operación: 4.7V a 5.3V

•	Corriente de Operación: 1mA (sin retroiluminación)

•	Retroiluminación: LED  azul

•	Número de Caracteres: 32 (16 caracteres por cada una de las 2 filas)

•	Tamaño de Caracteres: 5x8 puntos por carácter

•	Interfaz: 8 bits (puede configurarse para usar solo 4 bits)

•	Controlador: HD44780 o compatible

•	Ciclo de Trabajo: 1/16 duty cycle

•	Temperatura de Operación: -20°C a +70°C

<img src= "CAJALCD.png">

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
<img src= "DISPLAY7R.png">
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

<img src= "DISPLAYD.png">
•	Segmentos (a-g): Cada uno de los siete segmentos que forman los números.
•	Punto Decimal (dp): Opcional, utilizado para mostrar números decimales.
•	Pines de Conexión: 4pines, incluyendo los pines comunes y los pines de cada segmento.

### Funcionamiento

•	Control de Segmentos: Cada segmento se enciende o apaga para formar los números del 0 al 9 y algunas letras.

•	Interfaz: Puede ser controlado directamente por un microcontrolador o mediante un decodificador BCD a 7 segmentos.

## Interruptor táctil (push button)
<img src= "PULSADOR .png">
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

<img src= "caja negra.jpg">

## Diagrama de flujo

El diagrama de flujo describe un sistema de juego donde se simula el cuidado de una mascota virtual  que determinan su estado de bienestar: Hambre, Diversión, Energía, Salud y Felicidad, todas iniciando en 5. Estas se afectan con el tiempo, y el jugador debe intervenir para mantenerlas dentro de rangos saludables.

1. **Hambre**: Si el nivel de Hambre cae por debajo de 2, la mascota se muestra hambrienta. El jugador debe alimentarla para evitar que la Salud y la Felicidad no disminuyan.

2. **Diversión**: Al reducirse la Diversión por debajo de 2, la mascota se considera aburrida. El jugador puede optar por jugar con la mascota para aumentar su Felicidad y restablecer su Diversión.

3. **Energía**: Si la Energía disminuye a menos de 2, la mascota entra en un estado cansado, necesitando dormir para recuperar Energía y Salud.

4. **Salud**: Un nivel de Salud por debajo de 2 indica que la mascota está enferma. Debe ser curada, o de lo contrario la Salud continuará disminuyendo, pudiendo resultar en la muerte de la mascota si la Salud llega a cero.

5. **Felicidad**: Si la Felicidad cae por debajo de 2, la mascota se pone triste, lo que puede afectar adicionalmente su Salud. Acariciar a la mascota o atender sus otras necesidades puede restaurar la Felicidad.

Si alguna de las condiciones críticas como la Salud llega a cero, la mascota muere, y el juego requiere que se realice un reinicio. Este sistema de juego enseña sobre el cuidado y la atención necesaria para mantener el bienestar de un ser, aunque sea virtual, enfatizando la importancia de la observación y la respuesta a las necesidades de los que dependen de nosotros.

<img src= "Diagrama de flujo.jpg">


## maquina de estados.

Estado Inicial: La mascota comienza con niveles equilibrados de salud, energía, diversión, hambre y felicidad.

Transiciones:
 
Si alguno de estos niveles baja demasiado, la mascota cambia a un estado específico, como Hambriento, Aburrido, Cansado, Enfermo, o Triste.
Los usuarios pueden realizar acciones como alimentar, jugar o curar, que restauran esos niveles y devuelven la mascota al estado Saludable.

Estado Final: Si la salud de la mascota llega a cero, entra en el estado Muere, concluyendo la simulación.

Importancia:

Esta FSM permite que la mascota reaccione de forma dinámica a las interacciones del usuario y a las condiciones de su entorno, ofreciendo una experiencia interactiva y educativa que simula el cuidado de una mascota real.

<img src= "maquina de estados .png">


