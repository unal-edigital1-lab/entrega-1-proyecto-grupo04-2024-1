#### Juan Manuel Beltrán Botello

#### Oscar Jhondairo Siabato León

#### Willian Mauricio Meza Patiño

#### Jhon Alejandro Cuaspud


## Introduccion 

Implementar un Tamagotchi en una FPGA Cyclone IV utilizando el lenguaje de programación de hardware Verilog. Este Tamagotchi será una mascota virtual que reaccionará a las interacciones del usuario a través de botones y a estímulos ambientales mediante sensores de ultrasonido, PIR y de vibraciones, los cuales serán detallados más adelante. El sistema contará con un display de 7 segmentos para mostrar los niveles y la puntuación de la mascota, mientras que una pantalla LCD de 16x2 se encargará de representar gráficamente su estado, así como el modo de juego en el que se encuentra el usuario.

## Objetivos

Desarrollar un sistema de Tamagotchi en FPGA (Field-Programmable Gate Array) que simule el cuidado de una mascota virtual. El diseño incorporará una lógica de estados para reflejar las diversas necesidades y condiciones de la mascota, junto con mecanismos de interacción a través de sensores y botones que permitan al usuario cuidar adecuadamente de ella

Diseñar e implementar un sistema de interacción en la FPGA Cyclone IV, donde el usuario podrá realizar acciones a través de cinco botones dedicados a las funciones de alimentar, curar, reiniciar, modo test y modo racing.

Integrar tres sensores: un sensor de ultrasonido, un sensor PIR (infrarrojo pasivo) y un sensor de vibraciones, para que el Tamagotchi reaccione a estímulos ambientales y físicos.

Desarrollar la lógica de control en Verilog para coordinar eficientemente las interacciones del usuario y las respuestas a los estímulos de los sensores, asegurando una experiencia de juego fluida.

Implementar salidas visuales mediante un display de 7 segmentos para mostrar la puntuación de la mascota y una pantalla LCD de 16x2 para representar su estado gráfico y el modo de juego activo.

Optimizar el diseño para minimizar el uso de recursos en la FPGA Cyclone IV, resolviendo desafíos de diseño, limitaciones de recursos y posibles errores físicos que puedan surgir durante el desarrollo.

## Componentes 

#### FPGA cyclone IV

#### Protoboard

#### Sensor medidor de distancia ultrasonido Hc-sr4

#### Sensor de vibracion sw-420

#### Sensor de movimiento  PIR HC-SR501

#### Pantalla LCD 16X2 

#### Display 7 seg 

#### 5 Botones

## Especificacion de los sistemas que conforman el proyecto

### Caja negra 

Tras enfrentar desafíos en la implementación del sensor de colores debido a complicaciones con el protocolo de comunicación I2C, se ha desarrollado una versión mejorada del sistema. Esta nueva versión introduce dos sensores adicionales: un sensor de ultrasonido y un sensor de vibraciones (los cuales suplen la funcion del sensor de colores), y elimina el sensor de colores original. Además, se han realizado ajustes en la configuración de los botones, reemplazando el botón de jugar por uno para alimentar y añadiendo un nuevo botón dedicado al modo racing.

<img src= "IMAGENES/caja negra V2.jpg">

### Diagrama de flujo 

<img src= "IMAGENES/Diagrama de flujo V2.jpg">

Este diagrama de flujo describe el comportamiento de un Tamagotchi implementado

#### Inicio

Valores iniciales:

Hambre = 5

Diversión = 5

Energía = 5

Salud = 5

Felicidad = 5




| **Parámetro**    | **Condición** | **Acción**             | **Resultado**                                     |
|------------------|---------------|------------------------|--------------------------------------------------|
| **Hambre**       | 2ut = Sí      | Hambre = Hambre - 1    | Se reduce el nivel de hambre cada 2 unidades de tiempo.                    |
|                  | Hambre ≤ 2    | Hambriento             |                  |
|                  |No alimentar  | Salud = Salud - 1      | Disminuye la salud al no alimentar.                 |
|                  | No alimentar | Felicidad = Felicidad - 2 | Disminuye la felicidad al no alimentar.               |
|                  |Alimentar (boton)|  Hambre = 5             | Hambre se resetea al valor máximo (5).           |
| **Diversión**    |1ut = Sí      | Diversión = Diversión - 1 | Se reduce el nivel de diversión cada 1 unidad de tiempo.                 |
|                  | Diversión ≤ 2 | Aburrido               |                   |
|                  | No jugar      | Felicidad = Felicidad - 1 | Disminuye la felicidad al no jugar.                 |
|                  |Jugar (sensor) | Diversión = 5          | Diversión se resetea al valor máximo (5).        |
|                  |Jugar (sensor)| Energía = Energía - 1  | Se reduce la energía al jugar.                   |
|                  |Jugar (sensor)| Hambre = Hambre - 1    | Se reduce el hambre al jugar.                    |
| **Energía**      | 4ut = Sí      | Energía = Energía - 1   | Se reduce el nivel de energía cada 4 unidades de tiempo.                   |
|                  | Energía ≤ 2   | Cansado                |                                                  |
|                  |Dormir (sensor)| Energia = 5            | Energia se resetea al valor maximo (5)                                                  
|                  |Dormir (sensor)| Salud = Salud + 1      | Aumenta la salud al dormir.                      |
|                  |Dormir (sensor)| Felicidad = Felicidad + 2 | Aumenta la felicidad al dormir.                  |
| **Salud**        | Salud ≤ 2     | Enfermo                |                                                   |
|                  | Curar (Botón) | Salud = 5              |Salud se resetea al valor maximo (5).                    |
|                  | No curar      | Salud = Salud - 1      | Se reduce la salud si no se cura.                |
|                  | Salud = 0     | Muerte                 | El Tamagotchi muere y se activa la opción Reset. |
| **Felicidad**    | Felicidad ≤ 2 | Triste                 |                                          |
|                  |No acariciar   |  salud = Salud - 1      | Disminuye la salud si no se acaricia             |
|                  |Acariciar (sensor)| Felicidad =5           | se resetea la felicidad al acariciar al valor maximo (5)        |
| **Modo Racing**  | Pulsar por 5 seg | Pulsos = 1            | Tiempo x 5.                                      |
|                  |               | Pulsos = 2             | Tiempo x 10.                                     |
|                  |               | Pulsos = 3             | Tiempo x 50.                                     |
| **Modo Test**    | Pulsar por 5 seg | Pulso = 1             | Muerto.                                          |
|                  |               | Pulso = 2             | Dormido.                                         |
|                  |               | Pulso = 3             | Triste.                                          |
|                  |               | Pulso = 4             | Enfermo.                                         |
|                  |               | Pulso = 5             | Cansado.                                         |
|                  |               | Pulso = 6             | Aburrido.                                        |
|                  |               | Pulso = 7             | Hambriento.                                      |
|                  |               | Pulso = 8             | Feliz.                                           |

Este resumen abarca los diferentes estados y sus respectivos cambios basados en las condiciones que se presentan en el diagrama de flujo. 

### Maquina de estados

### Visualizacion 

<img src= "IMAGENES/Diagrama de estados LCD.jpg">

#### Resumen del Flujo de la FSM:

• IDLE: Espera la señal de inicio.

• INIT_CONFIG: Envia los comandos de configuración al LCD.

• CLEAR_COUNTERS0: Reinicia los contadores para preparar la escritura de caracteres en la CGRAM.

• CREATE_CHARS: Escribe caracteres personalizados en la CGRAM del LCD.

• CLEAR_COUNTERS1: Reinicia los contadores para preparar la escritura de texto en la pantalla.

• SET_CURSOR_AND_WRITE: Mueve el cursor y escribe texto en la pantalla.

• WRITE_ADDITIONAL_TEXT: Escribe texto adicional en la pantalla, incluyendo el manejo de escritura en la segunda línea del LCD.

### Diagrama de estados sensor ultrasonido

<img src= "IMAGENES/Diagrama de estados sensor ultrasonido.jpg">

#### Explicación:

• IDLE: Incrementa el contador count y evalúa cuándo activar la señal trigger.

• TRIGGER: Se dispara la señal de trigger, y el sistema está a la espera de la señal echo de vuelta.

• ECHO: El sistema mide el tiempo que echo está activo (incrementando echo_count). Cuando echo pasa de 1 a 0, se almacena el valor en count_out.

• Almacenamiento: Una vez que el eco ha sido recibido completamente, se guarda el valor del tiempo medido y se prepara el sistema para la próxima medición.

## Arquitectura del sistema

### Definición clara de la funcionalidad de cada periférico y coherencia con la implementación en HDL y su conexión.

## Sensor medidor de distancia ultrasonido HC-SR4


<img src= "IMAGENES/Sensor Ultrasonid.png">


##### Voltaje de operación: 5V.

##### Corriente de operación: <2 mA en reposo, 15 mA en operación

##### Dimensiones: 32mm x 20mm2.

##### Ángulo de detección: 30°.

##### Distancia de medición: Entre 2 cm y 400 cm

##### Resolución: 0,3 cm

### Funcionamiento 

El sensor HC-SR04 utiliza ondas ultrasónicas para medir la distancia entre él y un objeto. El principio de funcionamiento se basa en la emisión de un pulso ultrasónico que viaja en el aire, rebota en el objeto, y regresa al sensor. El dispositivo mide el tiempo que tarda en regresar el pulso para calcular la distancia mediante la ecuación de distancia:

*d = v × t*

donde:

*d es la distancia*

*v es la velocidad del sonido (aproximadamente 343 m/s en condiciones normales)*

*t es el tiempo medido*

<img src= "IMAGENES/funcionamaiento del sensor ultrasonico.png">


### Funcionalidad 

El sensor ultrasónico HC-SR04 se utiliza en el proyecto para medir la proximidad entre la mascota virtual (Tamagotchi) y el usuario. La interaccion se denomina como una "caricia" se simula detectando que la mano del usuario está a una distancia cercana al sensor, lo que luego se traduce en una interacción positiva que afecta el estado de la mascota, como aumentar su nivel de felicidad.

<img src= "IMAGENES/señal cuadrada del sensor ultrasonico.png">

###Explicación Basada en el Diagrama de Temporización

La imagen que se muestra explica cómo el sensor ultrasónico envía y recibe las señales para medir la distancia

### Trigger Input to Module:

El proceso comienza cuando la FPGA envía una señal de disparo (TRIG) al sensor durante 10 microsegundos (como muestra la primera parte del gráfico). Este pulso activa el sensor, que emite una ráfaga de ondas ultrasónicas de 8 ciclos a 40 kHz, señalada en la imagen como "8 Cycle Sonic Burst".

### Echo Pulse Output:

Después de que la ráfaga ultrasónica es emitida, el sensor espera a recibir el eco del pulso que rebota en el objeto cercano (la mano del usuario). La señal ECHO se pone en alto cuando el sensor detecta el retorno de la onda, y se mantiene en alto por un período de tiempo proporcional a la distancia. Este comportamiento es lo que se representa en la parte inferior del gráfico como "Echo Pulse Output". El tiempo que la señal permanece en alto indica la proximidad del objeto.

### Interpretación de la "Caricia":

Para simular una caricia, la FPGA mide el tiempo en que el pin ECHO permanece en alto. Si el tiempo de retorno del eco indica que la mano del usuario está dentro de un rango específico, se interpreta como una caricia. En este caso, la mascota virtual reaccionará de forma positiva, como si el usuario estuviera acariciándola y restablecera el puntaje de la felicidad.

### El tiempo medido en microsegundos.
​
Si la distancia está dentro del rango definido (3 a 5 centimetros), se ejecuta la acción de la "caricia", afectando el comportamiento de la mascota en el juego.

### Pines de Alimentación

• VCC (Alimentación 5V): Este pin se conecta a una fuente de 5V para alimentar el sensor.

• GND (Tierra): Debe conectarse al pin de tierra (GND) en la FPGA para completar el circuito de alimentación.

• TRIG (Disparo): El pin TRIG se conecta a un GPIO de la FPGA configurado como salida. Para activar la medición de distancia, la FPGA debe enviar una señal de 10 microsegundos en alto, lo que generará una ráfaga de ondas ultrasónicas.

• ECHO (Recepción del eco): El pin ECHO se conecta a otro GPIO de la FPGA configurado como entrada. Este pin permanecerá en alto durante el tiempo que tarda el eco en regresar. El tiempo en alto se usa para calcular la distancia al objeto.

### Implementación HDL y Conexión

<img src= "IMAGENES/conecciones del ultrasonico.png">

El flujo de la implementación en Verilog sería algo similar a lo siguiente:

1. Generación de señal TRIG: Crear un módulo en Verilog que controle el tiempo de activación del pin TRIG (10 µs).

2. Medición del tiempo ECHO: Implementar un temporizador que comience a contar cuando el pin ECHO se pone en alto y se detenga cuando vuelva a estar en bajo.

3. Cálculo de la distancia: Transformar el tiempo medido en la distancia correspondiente y almacenarla para su uso en la lógica del Tamagotchi.

## Sensor de vibración SW-420
<img src= "IMAGENES/sensor de vibracion.png">

Voltaje de operación: 3.3V - 5V

Corriente de operación: <1.5 mA

Dimensiones: 35mm x 15mm

## Funcionamiento

El sensor de vibración SW-420 detecta vibraciones o golpes mediante un mecanismo de tipo interruptor interno. Cuando se aplica una vibración al sensor, el interruptor interno cambia de estado, lo que genera una señal de salida. El sensor es capaz de detectar pequeñas vibraciones y cambios bruscos en el entorno físico, lo que lo hace ideal para aplicaciones de seguridad o interacción basada en movimiento.


### Funcionalidad

En el proyecto de la mascota virtual (Tamagotchi), el sensor SW-420 se utiliza para detectar "golpes" o "sacudidas" que el usuario le da a la mascota virtual. Cada vez que se detecta una vibración, se interpreta como una interacción del usuario, que puede influir en el estado emocional de la mascota, como aumentar su nivel de felicidad cuando detecta la vibracion.

### Explicación Basada en el Diagrama de Señal

El sensor SW-420 genera una señal de salida digital, donde un nivel bajo indica que se ha detectado una vibración. Al no haber vibración, la salida del sensor permanece en nivel alto. Al detectar una vibración o sacudida, el sensor genera un pulso bajo, el cual puede ser interpretado por la FPGA para tomar acciones en la lógica del Tamagotchi.

### Interpretación de la Vibración

La FPGA recibe la señal del sensor SW-420. Si se detecta un cambio en el estado de la señal, esto indica que se ha producido una vibración. Cada vez que detecta una vibracion el nivel de felicidad se restablecera.

### Pines de Alimentación

<img src= "IMAGENES/componentes sensor vibracion.png">

• VCC (Alimentación): Este pin se conecta a una fuente de 3.3V o 5V para alimentar el sensor.

• GND (Tierra): Debe conectarse al pin de tierra (GND) en la FPGA.

• DO (Salida digital): El pin DO se conecta a un GPIO de la FPGA configurado como entrada. Este pin cambiará su estado dependiendo de si se detecta o no una vibración.

### Implementación HDL y Conexión

El flujo de la implementación en Verilog sería algo similar a lo siguiente:

• Detección de vibración: Crear un módulo en Verilog que monitoree el pin de salida del sensor. Si se detecta un cambio de estado en la señal, se registra una vibración.

• Gestión de la respuesta: Implementar la lógica para determinar la acción a tomar según la intensidad o frecuencia de las vibraciones detectadas, afectando el comportamiento de la mascota.

• Respuesta de la mascota: Ajustar el estado emocional de la mascota (como su felicidad) en función de las vibraciones detectadas.


## Sensor de movimiento PIR HC-SR501

<img src= "IMAGENES/SENSOR PIR .png">

Para implementar este sensor, necesitaremos lo siguiente:

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

#### Pines de Alimentación

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

3.	Envío de Datos y Comandos:

•	El MPU utiliza los pines RS, R/W y E para seleccionar y enviar datos o comandos a través de los pines de datos (DB0-DB7).

4.	Visualización:
   
•	El controlador interpreta los datos y comandos recibidos y actualiza la pantalla en consecuencia, mostrando los caracteres en las posiciones especificadas.

### Funcionalidad 

La pantalla LCD 16x2 juega un papel fundamental en la interacción entre el usuario y su mascota virtual, proporcionando una interfaz visual que muestra de forma clara y directa el estado emocional y físico de la mascota.

#### Visualización de Estados Emocionales y Físicos

La pantalla está configurada para mostrar emojis y mensajes que representan diferentes estados emocionales y físicos de la mascota, tales como:

•	Feliz: Indica que la mascota está contenta y satisfecha.

•	Triste: Refleja que la mascota necesita más atención o cariño.

•	Enfermo: Muestra que la mascota requiere cuidados médicos o descanso.

•	Hambriento: Alerta al usuario de que es necesario alimentar a la mascota.

•	Cansado: Sugiere que la mascota necesita dormir o descansar.

•	Aburrido: Señala que la mascota necesita más interacción o jugar.

•  Muerto: Indica que el juego se termino y tendra que reiniciar

Dependiendo de cómo el usuario interactúa con la mascota virtual (alimentación, juego, descanso), la pantalla actualizará dinámicamente los íconos y mensajes para reflejar el nuevo estado de la mascota. Esto permite al usuario entender inmediatamente las consecuencias de sus acciones y ajustar su comportamiento para mejorar el bienestar de la mascota.

### Implementación HDL y Conexión

Se desarrolla una descripción en Verilog que gestione la comunicación con el LCD. Se incluye una lógica para inicializar el display, escribir comandos y agregar caracteres especiales que respondan según las señales que se envíen desde la FPGA, asegurándose de mostrar el estado en que se encuentre la mascota. 

### Componentes y conexiones

#### Microprocesador (MPU):

Función: Controla la pantalla enviando comandos y datos.

Conexiones: Se conecta a los pines RS, R/W, E y DB0-DB7 de la pantalla.

#### Pines de Alimentación

•	VCC: Fuente de alimentación de 5V en la FPGA.

•	GND: Tierra en la FPGA.

#### Pines de Control:

* RS (Registro de Selección): Selecciona entre comandos (0) y datos (1).

* R/W (Lectura/Escritura): Selecciona entre lectura (1) y escritura (0).

* E (Enable): Habilita la comunicación con la pantalla.

#### Pines de Datos (DB0-DB7):

Función: Transmiten los datos y comandos entre el MPU y la pantalla.

Modo de Operación: Puede operar en modo de 4 bits (DB4-DB7) o 8 bits (DB0-DB7).

#### Controlador/Driver IC (ICST7066U-0L-BT-BC o equivalente):

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

### Funcionalidad 

Los displays de 7 segmentos en nuestro proyecto actúan como paneles de información crucial, mostrando de manera efectiva los niveles estadísticos que reflejan el bienestar de la mascota virtual. Estos niveles varían de 1 a 5 y representan diferentes aspectos del estado de la mascota, incluyendo hambre, diversión, descanso, salud y felicidad.

•	Hambre: Indica si está llena o hambrienta la mascota.

•	Diversión: Refleja cuánta diversión está recibiendo la mascota.

•	Energia: Muestra cuán descansada está la mascota.

•	Salud: Señala el estado de salud general de la mascota.

•	Felicidad: Expresa el nivel de felicidad de la mascota.

A medida que el dueño interactúa con la mascota, estos niveles pueden aumentar o disminuir. Por ejemplo, alimentar a la mascota incrementará el nivel de hambre, mientras que jugar con ella aumentará su nivel de diversión y felicidad.

### Implementación HDL y Conexión

Cada display está controlado directamente desde la FPGA, la cual envía señales para ajustar los valores mostrados en función de las interacciones realizadas con la mascota virtual mediate la descripción de hardware. Los cambios en los niveles se reflejan inmediatamente en los displays de 7 segmentos, proporcionando retroalimentación instantánea al dueño sobre las necesidades actuales de la mascota.

#### Pines de Alimentación

•	VCC: Fuente de alimentación de 5V en la FPGA.

•	GND: Tierra en la FPGA.


## Interruptor táctil (push button)

<img src= "IMAGENES/boton-interruptor.jpg">

•	Voltaje de operación: 3.3V a 5V.

•	Corriente de operación:  Típica: 50mA.  Máxima: 100mA.

•	Operación: -20°C a 70°C.

### Funcionalidad 

Los botones cumpliran la funcion de curar, alimentar, reset, modo test, y racing mode, los cuales nos permitiran interactuar con la mascota de manera fisica con lo cual 

•	Hambre: Restablecera la puntuacion cuando la mascota esta hambrienta.

•	Salud: Restablecera la puntuacion de la salud cumplira con la funcion de curar.

• Reset: Despues de presionar se restablecera el juego

•	Test mode: Despues de presionar durante 5 segundos la mascota entrara en el modo de juego "Test mode" con el cual cada vez que se presione cambiara de estados en la pantalla LCD y finalmente si queremos salir del modo solo tendremos que volver a presionar durante 5 segundos el boton.

• Racing mode: Despues de presionar durante 5 segundos la mascota entrara en el modo de juego "Racing mode" en el cual el tiempo pasara 8 veces mas rapido de lo normal si queremos salir del modo solo tendremos que volver a presionar durante 5 segundos el boton.

### Implementación HDL y Conexión

Se implementará un mecanismo de antirrebote en hardware para los botones, lo que garantizará una operación confiable al filtrar las señales ruidosas que pueden producirse durante las pulsaciones. Esto evitará lecturas incorrectas o pulsaciones múltiples no deseadas, asegurando que cada interacción del usuario sea registrada de manera precisa. 

#### Pines de Alimentación

<img src= "IMAGENES/Conexion de interruptor.jpeg">

De esta manera, realizaremos la conexión de los pulsadores alimentándolos con 5V a través de una resistencia de 220 ohmios. Asignaremos un pin de la FPGA para controlar cada pulsador, permitiendo detectar las señales de entrada. Finalmente, conectaremos el circuito a tierra para completar la configuración y asegurar un funcionamiento adecuado. Esta disposición garantiza que la señal sea correctamente interpretada por la FPGA, evitando fluctuaciones no deseadas y asegurando una respuesta estable ante cada pulsación.

•	VCC: Fuente de alimentación de 5V en la FPGA.

•	GND: Tierra en la FPGA.

## Prototipado

### Simulaciones e interpretación 

Para la implementacion de la mayoria de los sensores (Modulos implementados en el codigo para cada uno de ellos) y perifericos que componen nuestro proyecto "Tamagochi" se simuló su comportamiento por medio de Questa. los resultados desgregados de cada componente se veran a continación.

1. Simulación Display 7segmentos:

<img src= "IMAGENES/DISPLAY_HAMBRE.png">

<img src= "IMAGENES/DISPLAY_VIDA.png">

En la anteriores imagenes se muestra el funcionamiento de los displays de 7 segmentos deacuerdo a su configuración. cada display que representa el nivel de un estado comienza desde el mismo valor numerico en el display seleccionado y cambia con el tiempo. se comprueba el correcto funcionamient de los displays.

2.Simulación pantalla LCD de 16x2:

<img src="IMAGENES/pantalla_lcd.png">

Para la pantalla lcd de 16x2 se probó que  la pantalla estuviera lista para la lectura de los archivos tipo txt que se le subieran, las caras de que hace nuestra mascota "tamagochi". ready_i indica el inicio de nuestra maquina de estados.

3. Simulación Antirrebote:

<img src="IMAGENES/ANTIRREBOTE.png">

Se puede ver como en la imagen, cuando simulamos pulsos de distinta duración no se presentan distorsiones en ningun pulso por lo que podemos concluir el correcto funcionamiento de nuestro modulo antirrebote.

4. Simulación Ultrasonido:

<img src="IMAGENES/TB_ULTRASONIDO.png">

Se puede ver en la imagen como, primero que nada el trigger de el sensor se va iniciando durante un periodo de 10 micro segundos, su periodo de ajuste. despues de este tiempo comienza a verse señales de "echo" que simulan las señales que se van arecibir del sensor. señales con cierta duracion y en un intervalo de tiempo corto.

### Justificación y Replanteamiento del Modelo

El diseño inicial del Tamagotchi en FPGA incluía sensores RGB (TCS34725) y PIR (PIR HC-SR501), botones, Display 7 seg y una pantalla LCD 16x2. Sin embargo, después de enfrentar dificultades con la implementación del protocolo I2C para el sensor RGB, se tomó la decisión de sustituirlo y agregar otros sensores más viables, como los sensores de vibración (SW-420) y ultrasonido (Hc-sr4), que simplificaron la implementación y aportaron nuevas formas de interacción.

### Justificación

#### Cambio de Sensor RGB y adición de Sensores de Vibración y Ultrasonido:

El sensor RGB fue reemplazado debido a la complejidad de integrar el protocolo I2C. En su lugar, se añadieron los sensores de vibración y ultrasonido, que aportan nuevas dinámicas al juego. El sensor de vibración permite interpretar acciones físicas, como sacudir el dispositivo para "jugar" restableciendo el puntaje de diversion, mientras que el sensor de ultrasonido se usa para detectar la proximidad, simulando interacciones como una "caricia" de parte del usuario restableciendo el puntaje de la felicidad.

#### Sensor PIR:

El sensor PIR se mantuvo en el diseño debido a su facilidad para detectar movimiento, lo que permite acciones automáticas como "Despertar" a la mascota cuando el usuario se acerca y cuando el usuario no esta entrara er el estado de "dormido" restableciendo el puntaje de la energia.

#### Display de 7 segmentos:

El display de 7 segmentos sigue siendo una opción viable para mostrar la información de los indicadores de la mascota virtual: felicidad, hambre, energía, salud y diversión. Cada uno de estos indicadores tiene una puntuación que varía entre 0 y 5, proporcionando los datos necesarios para interactuar adecuadamente con la mascota. Aunque la pantalla tiene limitaciones, es suficiente para representar estas métricas.


#### Pantalla LCD 16x2:

La pantalla LCD es el componente principal para la visualización, es nuestra máquina de estados, la cual gestiona y muestra los diferentes estados de la mascota. Utilizamos esta pantalla para mostrar los estados correspondientes. Los estados de la mascota se actualizan en función del tiempo y los cambios en los indicadores, estos estados incluyen: "Estoy feliz", "Estoy triste", "Aburrido", "Cansado", "hambriento", "Enfermo", "Dormido" y "Me mori". Cada uno de estos estados es mostrado en la pantalla LCD mediante un emoji acompañado del nombre del estado correspondiente ademas del modo de juego.


### Evaluación Cíclica:

El modelo ha sido ajustado a través de iteraciones que permitieron superar las limitaciones técnicas del sensor RGB y hacer pruebas más directas con los sensores de vibración y ultrasonido. Estas mejoras las hemos evaluado con el paso del tiempo con el objetivo de presentar un proyecto bien estruturado.



### Interpretación de resultados de la implementación

Finalmente, se logró la implementación de tres sensores con el objetivo de que la interacción del usuario con la mascota sea más didáctica y se ajuste mejor a las necesidades de una mascota real. Además, se resolvieron las diferentes dificultades que surgieron con la implementación del sensor de colores, sustituyéndolo por los otros dos sensores: uno de vibración y otro de ultrasonido. las pruebas realizadas del  funcionamiento resultaron satisfactorias con algunos problemas con el sensor PIR y su calibracion pero en resumen nuestro resultado fue satisfactorio en relación con las especificaciones que el proyecto sugería.

### Determinación de causas físicas que puedan generar malos funcionamientos

#### 1. Sensor PIR (Passive Infrared Sensor)

Interferencia de Señales: El sensor PIR puede ser afectado por interferencias de señales infrarrojas externas, como la luz solar directa o fuentes de calor
cercanas, lo que puede resultar en lecturas erráticas o falsas alarmas.

Problemas de Alcance: Si el sensor no está colocado en una posición adecuada, su alcance puede verse reducido, afectando su capacidad para detectar movimiento correctamente.

Desajuste en el Tiempo de Respuesta: El tiempo de respuesta del sensor puede variar dependiendo de la temperatura y las condiciones ambientales, lo que puede afectar su precisión.

#### 2. Sensor de Ultrasonido

Problemas de Alcance y Precisión: Los sensores ultrasónicos pueden tener problemas si hay obstáculos o superficies irregulares en el camino de la señal 
ultrasónica, lo que puede afectar la precisión de la medición de distancia.

Interferencia de Otras Fuentes de Ultrasonido: Otros dispositivos que emiten ultrasonido pueden interferir con el sensor, causando lecturas incorrectas.

Sensibilidad a la Temperatura: La velocidad del sonido cambia con la temperatura, lo que puede afectar la precisión del sensor si no se compensa adecuadamente.

#### 3. Sensor de Vibración

Sensibilidad a Vibraciones Externas: El sensor puede detectar vibraciones no relacionadas con el propósito previsto debido a vibraciones externas o movimientos en el entorno.

Desgaste con el Tiempo: Los sensores de vibración pueden experimentar desgaste mecánico, lo que puede afectar su precisión y respuesta con el tiempo.

Problemas de Instalación: Si el sensor no está montado de manera segura o adecuada, puede resultar en lecturas inexactas o intermitentes.

#### 4. Pantalla de 7 Segmentos

Problemas de Conexión: Las conexiones a la display de 7 segmentos pueden aflojarse, lo que puede llevar a fallos en la visualización de los dígitos.

Problemas de Visibilidad: La pantalla puede ser difícil de leer en ciertas condiciones de iluminación o si no se utiliza el contraste adecuado.

#### 5. Pantalla LED 16x2

Problemas de Contraste: La visibilidad de la pantalla LED 16x2 puede verse afectada si el contraste no está ajustado correctamente o si la retroiluminación falla.

Píxeles Muertos: Pueden aparecer píxeles muertos o defectuosos que afectan la calidad de la visualización.

Problemas de Conexión: Las conexiones de la pantalla pueden ser inestables, lo que puede causar fallos intermitentes en la visualización.

#### 6. Botones

Desgaste: Los botones pueden desgastarse con el tiempo, lo que puede llevar a una respuesta inexacta o a la falta de respuesta.

Conexiones Sueltas: Las conexiones entre los botones y la FPGA pueden aflojarse, causando que los botones no funcionen correctamente.

Interferencia Mecánica: Los botones pueden experimentar interferencia mecánica si no están instalados adecuadamente o si se usan de manera excesiva.

## Evaluación del cumplimiento de los requisitos funcionales 

Tras un análisis minucioso de los requisitos funcionales del proyecto, podemos concluir que su cumplimiento ha sido casi satisfactorio, dado que el funcionaminto del modo test y del boton reset no se realizo de acuerdo a las especificaciones esperadas. Además, se han superado las expectativas al cumplir con requisitos adicionales más allá de los mínimos establecidos por el mismo.

## Trabajo en Equipo y Gestión del Proyecto

### cronograma de actividades 

| **Fase**            | **Semana**   | **Actividad**                                                                 | **Pruebas/Reuniones**                                                               |
| ------------------- | ------------ | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Diseño del Sistema   | Semana 1     | Análisis de requisitos y especificaciones                                      | Pruebas iniciales de la lógica de estados y Reunión 1                               |
|                     | Semana 2     | Diseño del circuito y arquitectura del sistema                                 | Pruebas de conexión inicial del circuito con FPGA                                    |
|                     | Semana 3     | Definición de la lógica de estados del Tamagotchi                              | Pruebas iniciales de funcionalidad                                                  |
| Implementación       | Semana 4     | Instalación de pantallas y botones                                             | Pruebas de visualización en pantallas y botones                                      |
|                     | Semana 5     | Integración de sensores (RGB, PIR, vibración)                                  | Pruebas de integración de sensores y hardware                                        |
|                     | Semana 6     | Pruebas funcionales del hardware y ajuste de sensibilidad                      | Ajustes basados en resultados de pruebas iniciales                                   |
|                     | Semana 7     | Optimización de la integración y codificación de la lógica inicial             | Reunión 2 (Revisión del hardware) y pruebas adicionales                             |
| Desarrollo del SW    | Semana 8     | Programación de la lógica de estados (transiciones y respuesta de sensores)    | Pruebas de lógica con sensores y pantallas                                           |
|                     | Semana 9     | Implementación del modo de prueba y botón Reset                                | Pruebas del modo de prueba y botón Reset                                             |
|                     | Semana 10    | Ajuste de la lógica de estados y funcionalidad                                 | Reunión 3 (Validación del software) y pruebas finales de software                    |
| Pruebas y Optimización | Semana 11 | Pruebas exhaustivas del sistema                                                | Pruebas finales con usuarios simulados                                               |
|                     | Semana 12    | **Cambio del sensor RGB por ultrasonido y vibración**                          | Reunión 4 (Replanteo del cambio de sensor) y pruebas de integración del nuevo sensor |
| Documentación y Entrega | Semana 13 | Optimización final del sistema, documentación técnica y entrega                | Reunión 5 (Revisión final) y pruebas de validación final                             |


La contribución del equipo al desarrollo del proyecto ha sido equitativa en relacion a las habilidades y fortalezas de cada integrante, las cuales fueron fundamentales para superar los obstáculos que surgieron a lo largo del proceso. Nuestro equipo se destacó por su resiliencia durante todo el desarrollo del proyecto.

### Procedimiento y anexos fotograficos

<img src= "IMAGENES/Pulsadores.jpeg">

Como se puede evidenciar la conexion de los pulsadores desde la protoboard ademas de la imagen se podra encontrar en la seccion de codigos la descripcion del boton antirrebote 

<img src= "IMAGENES/PIR.jpeg">

Como se puede evidenciar la conexion del sensor PIR desde la protoboard ademas de la imagen se podra encontrar en la seccion de codigos la descripcion del sensor como un simple interruptor en el module LCD1602_top

<img src= "IMAGENES/Vibracion.jpeg">

Como se puede evidenciar la conexion del sensor de vibracion desde la protoboard ademas de la imagen se podra encontrar en la seccion de codigos la descripcion del sensor como un simple interruptor en el module LCD1602_top

<img src= "IMAGENES/Ultrasonido.jpeg">

Como se puede evidenciar la conexion del sensor de ultrasoido desde la protoboard ademas de la imagen se podra encontrar en la seccion de codigos la descripcion del sensor en el module ultrasonido

<img src= "IMAGENES/Procedimiento2.jpg">

Se puede evidenciar la conexion completa de algunos perifericos del montaje en la protoboard 

<img src= "IMAGENES/Procedimiento3.jpg">

Como se puede evidenciar la conexion de la pantalla, los displays 7 segmenntos que anucian las puntuaciones ademas de la imagen se podra encontrar en la seccion de codigos la descripcion de la visualizacion en el module LCD1602_top y el module display_7seg_4digitos

<img src= "IMAGENES/Procedimiento1.jpg">

Finalmente mostramos en levantamiento total de nuestro poyecto 

### Video

Video de explicacion del funcionamiento del Tamagotchi
 
[Ver video en YouTube](https://youtu.be/vZQra_RWRXc)

## Referencias

https://www.alldatasheet.com/datasheet-pdf/view/1132204/ETC2/HCSR04.html

https://cdn-learn.adafruit.com/downloads/pdf/pir-passive-infrared-proximity-motion-sensor.pdf

https://media.digikey.com/pdf/Data%20Sheets/Seeed%20Technology/Grove_Vibration_Sensor_SW-420_Web.pdf

https://circuitdigest.com/article/16x2-lcd-display-module-pinout-datasheet


