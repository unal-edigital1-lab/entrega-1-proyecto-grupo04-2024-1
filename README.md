# Entrega 1 del proyecto WP01

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

Sensor RGB (Sensor de colores) Tcs 34725

Sensor de movimiento  PIR HC-SR501

Pantalla LCD 16X2 

Display 7 seg 

4 interruptores

## Sensor RGB (Sensor de colores) TCS 34725

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

## Sensor de movimiento PIR HC-SR501

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

### Componentes y conexiones

#### Microprocesador (MPU):
Función: Controla la pantalla enviando comandos y datos.
Conexiones: Se conecta a los pines RS, R/W, E y DB0-DB7 de la pantalla.
#### Pines de Control:
RS (Registro de Selección): Selecciona entre comandos (0) y datos (1).
R/W (Lectura/Escritura): Selecciona entre lectura (1) y escritura (0).
E (Enable): Habilita la comunicación con la pantalla.
#### Pines de Datos (DB0-DB7):
Función: Transmiten los datos y comandos entre el MPU y la pantalla.
Modo de Operación: Puede operar en modo de 4 bits (DB4-DB7) o 8 bits (DB0-DB7).
#### Controlador/Driver IC (ICST7066U-0L-BT-BC o equivalente):
Función: Interpreta los comandos y datos del MPU y controla la pantalla.
Conexiones: Internamente conectado a los pines de datos y control de la pantalla

### Funcionamiento

1.	Inicialización:
•	El MPU envía una serie de comandos de inicialización al controlador de la pantalla para configurar el modo de operación (4 bits o 8 bits), el número de líneas y el tipo de fuente.
2.	Envío de Datos y Comandos:
•	El MPU utiliza los pines RS, R/W y E para seleccionar y enviar datos o comandos a través de los pines de datos (DB0-DB7).
3.	Visualización:
•	El controlador interpreta los datos y comandos recibidos y actualiza la pantalla en consecuencia, mostrando los caracteres en las posiciones especificadas.
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


Se han elaborado las especificaciones generales para el correcto funcionamiento del proyecto, incluyendo una representación esquemática de la FPGA. Esta FPGA se visualiza como una caja negra que integra cada uno de los módulos necesarios para el proyecto. Además, se han detallado las funciones específicas de cada módulo, representados también como cajas negras individuales. Se ha especificado además
el uso del protocolo SPI para el control de la matriz de 8x8, la cual mostrará visualmente los estados de nuestra mascota virtual.

<img src= "especificacion.jpg">

## estados 

### Feliz: 
Tu mascota está super feliz. No para de moverse y parece que siempre está sonriendo.

### Saludable: 
Tu mascota está lleno de vida. Juega mucho y siempre está listo para la acción.

### Enfermo: 
 tu mascota no se siente muy bien hoy. Está más quieto de lo normal y no juega tanto tiene un gesto de incomodidad.

### Agotado:
Tu mascota está muy cansado. Ha jugado tanto que ahora solo quiere descansar un rato y su rotros muestra un gesto de cansancio.
<img src= "estados.jpeg">
<img src= "niveles.jpeg">
# Arquitectura del sistma 

## Periférico: Sensor de Luz

Funcionalidad: Un sensor de luz es un dispositivo que detecta la intensidad de la luz en el ambiente. Se utilizará para determinar el nivel de iluminación en nuestro entorno ,con esto se definirá la noche y el día para nuestra mascota  

Implementación en HDL: En el lenguaje de descripción de hardware, el sensor de luz se implementa como un módulo que tiene una interfaz de entrada y salida. La interfaz de entrada se utiliza para recibir las señales del sensor de luz cuando detecta un cambio en la intensidad de la luz. La interfaz de salida se utiliza para enviar estos datos al sistema principal.

Comunicación con el sistema: El sensor de luz se comunica con el sistema principal a través de una interfaz de bus. Cuando el sensor detecta un cambio en la intensidad de la luz,solo tendremos dos estados, iluminación máxima e iluminación mínima.osea solo un 1 y un 0, cero para cuando el sensor esté en su mínimo valor.  




// Aquí se implementaría la lógica para mostrar el estado de la mascota en la matriz de puntos
endmodule
>>>>>>> ec32649 (matris 8x8)
