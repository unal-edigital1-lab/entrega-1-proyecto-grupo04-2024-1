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

<img src= "Sensor Ultrasonid.png">

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

<img src= "funcionamaiento del sensor ultrasonico.png">


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

## Codigos 
### Top

//--------------------------------------------------------------------------------------------------------------------------------------------\\
module LCD1602_cust_char #(parameter num_commands = 3, 
                                      num_data_all = 48,  
                                      char_data = 8, 
                                      num_cgram_addrs = 6,
                                      text_lenght = 12,
												  text_lenght2 = 12,
                                      COUNT_MAX = 800000)(
    input clk,            
    input reset,          
    input ready_i,
    output reg rs,        
    output reg rw,
    output enable,   
    output reg [7:0] data,


    input btn_vida,
    input btn_alimentar,
    input btn_racing_mode,
	 
//---------------------- 7 segmentos ---------------------------------------------\\

    output wire [6:0] seg_0,
    output wire [4:0] an, 
//--------------------------------------------------------------------------------\\

//---------------------------------sensor pir------------------------------\\

     input sensor_pir,

//--------------------------------------------------------------------------------\\  

//----------------------------Sensor vibracion----------------------------------------\\

     input sensor_vibracion,

//------------------------------------------sensor ultasonido----------------------------\\

    input echo,
    output trigger,


//----------------------------------------------------------------------------------------\\

		  
//----------------------------------- boton ----------------------------------------\\

    input wire btn_in,
    output wire debounced_out,
    output wire debouncer_led,
    output wire [3:0] debouncer_count_out

//-----------------------------------------------------------------------------------\\

    
     
);




// Definir los estados del controlador

localparam IDLE = 0;
localparam INIT_CONFIG = 1;
localparam CLEAR_COUNTERS0 = 2;
localparam CREATE_CHARS = 3;
localparam CLEAR_COUNTERS1 = 4;
localparam SET_CURSOR_AND_WRITE = 5;
localparam WRITE_ADDITIONAL_TEXT = 6;

 

localparam SET_CGRAM_ADDR = 0;
localparam WRITE_CHARS = 1;
localparam SET_CURSOR = 2;
localparam WRITE_LCD = 3;
localparam CHANGE_LINE = 4;

// Direcciones de escritura de la CGRAM 
localparam CGRAM_ADDR0 = 8'h40;
localparam CGRAM_ADDR1 = 8'h48;
localparam CGRAM_ADDR2 = 8'h50;
localparam CGRAM_ADDR3 = 8'h58;
localparam CGRAM_ADDR4 = 8'h60;
localparam CGRAM_ADDR5 = 8'h68;
localparam CGRAM_ADDR6 = 8'h70;

//Registros de la maquina de estados LCD
reg [3:0] fsm_state;
reg [3:0] next;
reg clk_16ms;

// Definir un contador para el divisor de frecuencia
reg [$clog2(COUNT_MAX)-1:0] counter_div_freq;

// Comandos de configuración
localparam CLEAR_DISPLAY = 8'h01;
localparam SHIFT_CURSOR_RIGHT = 8'h06;
localparam DISPON_CURSOROFF = 8'h0C;
localparam DISPON_CURSORBLINK = 8'h0E;
localparam LINES2_MATRIX5x8_MODE8bit = 8'h38;
localparam LINES2_MATRIX5x8_MODE4bit = 8'h28;
localparam LINES1_MATRIX5x8_MODE8bit = 8'h30;
localparam LINES1_MATRIX5x8_MODE4bit = 8'h20;
localparam START_2LINE = 8'hC0;

// Definir un contador para controlar el envío de comandos
reg [$clog2(num_commands):0] command_counter;
// Definir un contador para controlar el envío de cada dato
reg [$clog2(num_data_all):0] data_counter;
// Definir un contador para controlar el envío de caracteres a la CGRAM
reg [$clog2(char_data):0] char_counter;
// Definir un contador para controlar el envío de comandos
reg [$clog2(num_cgram_addrs):0] cgram_addrs_counter;
// Definir un contador para controlar el envío de texto linea 1
reg[$clog2(text_lenght):0] text_counter;
// Definir un contador para controlar el envío de texto linea 1
reg[$clog2(text_lenght):0] text_counter2;



// -----------------------Bancos de registros---------------------------------------------\\

//registros de caras 
reg [7:0] data_memory [0:num_data_all-1];
reg [7:0] data_memory2 [0:num_data_all-1];
reg [7:0] data_memory3 [0:num_data_all-1];
reg [7:0] data_memory4 [0:num_data_all-1];
reg [7:0] data_memory5 [0:num_data_all-1];
reg [7:0] data_memory6 [0:num_data_all-1];
reg [7:0] data_memory7 [0:num_data_all-1];
reg [7:0] data_memory8 [0:num_data_all-1];

//registro de texto

reg [7:0] text_memory [0:text_lenght-1];
reg [7:0] text_memory2 [0:text_lenght-1];
reg [7:0] text_memory3 [0:text_lenght-1];
reg [7:0] text_memory4 [0:text_lenght-1];
reg [7:0] text_memory5 [0:text_lenght-1];
reg [7:0] text_memory6 [0:text_lenght-1];
reg [7:0] text_memory7 [0:text_lenght-1];
reg [7:0] text_memory8 [0:text_lenght-1];
reg [7:0] text_test_mode [0:text_lenght-1];
reg [7:0] text_racing_mode [0:text_lenght-1];

//Registro de la cgram
reg [7:0] config_memory [0:num_commands-1]; 
reg [7:0] cgram_addrs [0: num_cgram_addrs-1];
reg [1:0] create_char_task;
reg init_config_executed;
wire done_cgram_write;
reg done_lcd_write;

//Registos de escribir texto
reg text_write_done;
reg writing_line2;

//--------------------------------------Contadores--------------------------\\

reg [35:0]counter_tiempo;
reg [35:0]counter_tiempo_racing;
wire [31:0] echo_counter;

//--------------------------------------------------------------------------------\\

//-------------------------------Registros modos-----------------------------------\\

reg game_over;
reg test_mode;
reg racing_mode;

//----------------------------------------------------------------------------------\\

//----------------7 segmentos-------------------------------\\

reg [4:0] hambre, diversion, energia, felicidad, vida;

//------------------------------------------------------------\\

initial begin
    fsm_state <= IDLE;
    data <= 'b0;
    command_counter <= 'b0;
    data_counter <= 'b0;
    rw <= 0;
	rs <= 0;
    clk_16ms <= 'b0;
    counter_div_freq <= 'b0;
    init_config_executed <= 'b0;
    cgram_addrs_counter <= 'b0; 
    char_counter <= 'b0;
    done_lcd_write <= 1'b0; 
    

    create_char_task <= SET_CGRAM_ADDR;

    counter_tiempo = 31'd0;

    game_over <= 1'b0; 
    test_mode <=1'b0;
    racing_mode <= 1'b0;


    text_write_done <= 1'b0;
    text_counter <=0;
	 text_counter2 <=0;
	 writing_line2 <=0;

//------------------------------------------------------------------------------------------------------\\

//caracteres

    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/feliz_cara.txt", data_memory);
	 $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/hambriento_cara.txt", data_memory2);
	 $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/aburrido_cara.txt", data_memory3); 
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/cansado_cara.txt", data_memory4);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/enfermo_cara.txt", data_memory5);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/triste_cara.txt", data_memory6);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/dormido_cara.txt", data_memory7);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/muerto_cara.txt", data_memory8);

//Texto

    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/feliz_texto.txt", text_memory); 
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/hambriento_texto.txt", text_memory2); 
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/aburrido_texto.txt", text_memory3);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/cansado_texto.txt", text_memory4);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/enfermo_texto.txt", text_memory5);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/triste_texto.txt", text_memory6);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/dormido_texto.txt", text_memory7);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/muerto_texto.txt", text_memory8);
	 $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/test_mode_texto.txt", text_test_mode);
	 $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/racing_mode_texto.txt", text_racing_mode);

	config_memory[0] <= LINES2_MATRIX5x8_MODE8bit;
	config_memory[1] <= DISPON_CURSOROFF;
	config_memory[2] <= CLEAR_DISPLAY;

    cgram_addrs[0] <= CGRAM_ADDR0;
    cgram_addrs[1] <= CGRAM_ADDR1;
    cgram_addrs[2] <= CGRAM_ADDR2;
    cgram_addrs[3] <= CGRAM_ADDR3;
    cgram_addrs[4] <= CGRAM_ADDR4;
    cgram_addrs[5] <= CGRAM_ADDR5;
end

//----------------------------Contadol tiempo-------------------------------------------------------------\\

    always @(posedge clk or negedge reset ) begin
        if (!reset) begin      
            counter_tiempo <= 36'b0;     
        end else begin
            if(racing_mode == 1'b0)begin 
            if (counter_tiempo == 36'd45000000000) begin
                counter_tiempo = 36'b0;
            end else begin
                counter_tiempo = counter_tiempo + 1;
            end 
         end
			
			//contador acelerado
			
         if(racing_mode == 1'b1)begin
          if (counter_tiempo_racing == 36'd45000000000) begin
                counter_tiempo_racing = 36'b0;
            end else begin
                counter_tiempo_racing = counter_tiempo_racing + 8;
            end 
            counter_tiempo <= counter_tiempo_racing;
         end
        end
    end


//-------------------------------------------------------------------------------------------------\\

//------------------------7 segmentos---------------------------------------------------------------\\

display_7seg_4digitos display(
    .clk(clk),
    .reset(reset),
    .digit_0(hambre),
    .digit_1(diversion),
    .digit_2(energia),
    .digit_3(felicidad),
    .digit_4(vida),
    .seg_0(seg_0),
    .an(an)
);


always @(posedge clk or negedge reset) begin
    if (!reset) begin
        hambre <= 4'h6;
        diversion <= 4'h6;
        energia <= 4'h6;
        felicidad <= 4'h5;
        vida <= 4'h5;
        game_over <= 1'b0;
        test_mode <= 1'b0;
        racing_mode <= 1'b0;
    end else begin 
        
     if (vida == 4'h0) begin
        game_over <= 1'b1;
     end

//---------------------------------------------modo test-------------------------------------------------\\

     if (btn_in == 1'b0 && counter_tiempo % 250000000 == 0 && racing_mode == 1'b0) begin
        test_mode <= 1'b1;
     end
     if (test_mode == 1'b1) begin
        hambre <= 4'h5;
        diversion <= 4'h5;
        energia <= 4'h5;
        felicidad <= 4'h5;
        vida <= 4'h5;
     end

     if(btn_in == 1'b0 && counter_tiempo % 250000000 == 0 && test_mode == 1'b1)begin 
        test_mode <= 1'b0;
     end
//-----------------------------------------------------------------------------------------------\\

//--------------------------------------------modo rapido------------------------------------------\\

    if(btn_racing_mode == 1'b0 && counter_tiempo % 250000000 == 0 && test_mode == 1'b0) begin
       racing_mode <= 1'b1;
    end
    if(btn_racing_mode == 1'b0 && counter_tiempo % 2000000000 == 0 && racing_mode == 1'b1) begin
       racing_mode <= 1'b0;
    end
    

//-------------------------------------------------------------------------------------------------------\\

//------------------------------------------------------------Logica de puntajes---------------------------------------------------------\\

    if (game_over) begin 

        if(!reset)  begin

        hambre <= 4'h6;
        diversion <= 4'h6;
        energia <= 4'h6;
        felicidad <= 4'h5;
        vida <= 4'h5;
        game_over <= 1'b0;

    end

    end else begin 
	 
	 if (counter_tiempo % 2500000000 == 0 && hambre > 4'h0) begin
        hambre <= hambre - 4'h1;
    end 

	 
    if (counter_tiempo % 1250000000 == 0 && diversion > 4'h0 && sensor_pir == 1) begin
        diversion <= diversion - 4'h1;
    end

    if (counter_tiempo % 5000000000 == 0 && energia > 4'h0 && sensor_pir == 1) begin 
        energia <= energia - 4'h1;      
     end
	  
//---------------------------------logica dormido-----------------------------------------------------\\

    if (sensor_pir == 0 && counter_tiempo % 625000000 == 0 && energia<5) begin 
      energia <= energia + 1;
    end
    if (sensor_pir == 0 && counter_tiempo % 2500000000 == 0 && energia > 4 && vida<5) begin 
        vida <= vida + 1;
    end

//-----------------------------------------------------------------------------------------------\\

//---------------------logicas de felicidad------------------------------------------------\\

     if (counter_tiempo % 2500000000 == 0 && diversion<=2 && felicidad>0) begin 
        felicidad <= felicidad - 4'h1;      
     end
     if (counter_tiempo % 3750000000 == 0 && hambre<=2 && felicidad>0) begin 
        felicidad <= felicidad - 4'h2;      
     end
     if (counter_tiempo % 50000000000 == 0 && energia<=2 && felicidad>0 && sensor_pir == 1) begin 
        felicidad <= felicidad - 4'h2;      
     end
     if (counter_tiempo % 12500000000 == 0 && vida<=2 && felicidad>0 && sensor_pir == 1) begin 
        felicidad <= felicidad - 4'h2;      
     end 
	  if (sensor_ultrasonido == 0 && counter_tiempo % 100000000 == 0  && felicidad<5 && sensor_pir == 1) begin 
        felicidad <= felicidad + 4'h1;      
     end

//----------------------------------------------------------------------------------------------\\

//-----------------------------logica vida----------------------------------------------------\\

     if (counter_tiempo % 2500000000 == 0 && hambre<=2 && vida>0) begin 
        vida <= vida - 4'h1;      
     end
     if (counter_tiempo % 2500000000 == 0 && energia<=2 && vida>0) begin 
        vida <= vida - 4'h1;      
     end
     if (counter_tiempo % 2500000000 == 0 && felicidad<=2 && vida>0) begin 
        vida <= vida - 4'h1;      
     end
     if (btn_vida==1'b0 && vida<5 && hambre>0) begin 
        vida <= 5;
        hambre <= hambre - 4'h1;
     end

//-------------------------------------------------------------------------------------------------------\\

//-------------------------------------logica diversion-----------------------------------------\\

     if (sensor_vibracion == 1'b1 && diversion < 5 && sensor_pir == 1) begin 
        diversion <= 5;      
     end
     if (sensor_vibracion == 1'b1 && diversion < 5 && energia>0 && sensor_pir == 1) begin 
        energia <= energia - 1;      
     end

//----------------------------------------------------------------------------------------------------\\

//-------------------------------------logica alimentar-------------------------------------\\
	
		
     if (btn_alimentar == 1'b0 && hambre < 5 && sensor_pir == 1) begin 
        hambre <= 5;      
     end

//----------------------------------------------------------------------------------------------------\\


	  
end
end
end

//-----------------------------------------------------------------------------------------------------------------------------------\\

//------------------------------------ boton -----------------------------\\

debouncer_con_contador debouncer_inst (
    .btn_in(btn_in),
    .clk(clk),
    .reset(reset),
    .out(debounced_out),
    .led(debouncer_led),
    .count_out(debouncer_count_out)
);

//------------------------------------------------------------------------\\

//---------------------------------------ultrasonido---------------------------------------------\\

wire sensor_ultrasonido;

ultrasonic_controller ultrasonic_inst (
    .clk(clk),
    .reset(reset),
    .trigger(trigger),
    .echo(echo),
    .state(sensor_ultrasonido)
);

//-------------------------------------------------------------------------------------------------\\

//------------------------------------------------------Visualización LCD--------------------------------------------------------\\

//Divisor de frecuencia
always @(posedge clk) begin
    if (counter_div_freq == COUNT_MAX-1) begin
        clk_16ms <= ~clk_16ms;
        counter_div_freq <= 0;
    end else begin
        counter_div_freq <= counter_div_freq + 1;
    end
end

//Estado inicial
always @(posedge clk_16ms)begin
    if(reset == 0)begin
        fsm_state <= IDLE;
    end else begin
        fsm_state <= next;
    end
end

//Maquina de cambio de estados
always @(*) begin
    case(fsm_state)
        IDLE: begin
            next <= (ready_i)? ((init_config_executed)? CREATE_CHARS : INIT_CONFIG) : IDLE;
        end
        INIT_CONFIG: begin 
            next <= (command_counter == num_commands)? CLEAR_COUNTERS0 : INIT_CONFIG;
        end
        CLEAR_COUNTERS0: begin
            next <= CREATE_CHARS;
        end
        CREATE_CHARS:begin
            next <= (done_cgram_write)? CLEAR_COUNTERS1 : CREATE_CHARS;
        end
        CLEAR_COUNTERS1: begin
            next <= SET_CURSOR_AND_WRITE;
        end
        SET_CURSOR_AND_WRITE: begin 
            next <= (done_lcd_write)?  WRITE_ADDITIONAL_TEXT : SET_CURSOR_AND_WRITE;
        end
        WRITE_ADDITIONAL_TEXT: begin 
            next <= (text_write_done)? CLEAR_COUNTERS0 : WRITE_ADDITIONAL_TEXT;
        end

        default: next = IDLE;
    endcase
end


//Maquina de logica de los estados
always @(posedge clk_16ms) begin
    if (reset == 0) begin
        command_counter <= 'b0;
        data_counter <= 'b0;
		  data <= 'b0;
        char_counter <= 'b0;
        init_config_executed <= 'b0;
        cgram_addrs_counter <= 'b0;
        done_lcd_write <= 1'b0; 
        text_counter <= 0;
        text_write_done <= 0;
		  text_counter2 <=0;
	     writing_line2 <=0;


    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/feliz_cara.txt", data_memory);
	 $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/hambriento_cara.txt", data_memory2);
  	 $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/aburrido_cara.txt", data_memory3); 
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/cansado_cara.txt", data_memory4);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/enfermo_cara.txt", data_memory5);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/triste_cara.txt", data_memory6);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/dormido_cara.txt", data_memory7);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/muerto_cara.txt", data_memory8);

    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/feliz_texto.txt", text_memory); 
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/hambriento_texto.txt", text_memory2); 
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/aburrido_texto.txt", text_memory3);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/cansado_texto.txt", text_memory4);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/enfermo_texto.txt", text_memory5);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/triste_texto.txt", text_memory6);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/dormido_texto.txt", text_memory7);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/muerto_texto.txt", text_memory8);
	 $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/test_mode_texto.txt", text_test_mode);
	 $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/racing_mode_texto.txt", text_racing_mode);

    end else begin
        case (next)
		  //Estado inicial
            IDLE: begin
                char_counter <= 'b0;
                command_counter <= 'b0;
                data_counter <= 'b0;
                rs <= 'b0;
                cgram_addrs_counter <= 'b0;
                done_lcd_write <= 1'b0;
                text_write_done <= 0;
                text_counter <= 0;
					 text_counter2 <=0;
	             writing_line2 <=0;
            end
		 
            INIT_CONFIG: begin
                rs <= 'b0;
                command_counter <= command_counter + 1;
			    data <= config_memory[command_counter];
                if(command_counter == num_commands-1) begin
                    init_config_executed <= 1'b1;
                end
            end
            CLEAR_COUNTERS0: begin
                data_counter <= 'b0;
                char_counter <= 'b0;
                create_char_task <= SET_CGRAM_ADDR;
                cgram_addrs_counter <= 'b0;
                done_lcd_write <= 1'b0;
                rs <= 'b0;
                data <= 'b0;
                text_write_done <= 0;
                text_counter <= 0;

            end
            CREATE_CHARS: begin
                case(create_char_task)
                    SET_CGRAM_ADDR: begin 
                        rs <= 'b0; data <= cgram_addrs[cgram_addrs_counter]; 
                        create_char_task <= WRITE_CHARS; 
                    end
                    WRITE_CHARS: begin
                        rs <= 1;
                    if (test_mode == 1'b0) begin
                    if (vida == 0)begin
				        data <= data_memory8[data_counter];
                   end else if (!sensor_pir)begin
                        data <= data_memory7[data_counter];
                    end else if (felicidad <= 2)begin
                        data <= data_memory6[data_counter];
                    end else if (vida <= 2)begin 
                        data <= data_memory5[data_counter];
                    end else if (hambre <= 2)begin
                        data <= data_memory2[data_counter];
                    end else if (energia <= 2)begin
                        data <= data_memory4[data_counter];
                    end else if (diversion <= 2)begin
                        data <= data_memory3[data_counter];
                    end else if (felicidad > 2)begin
                        data <= data_memory[data_counter];
                    end 
                    end 
                    
                    if (test_mode == 1'b1) begin

                    if (debouncer_count_out == 4'd1)begin
				        data <= data_memory8[data_counter];
                   end else if (debouncer_count_out == 4'd2)begin
                        data <= data_memory7[data_counter];
                    end else if (debouncer_count_out == 4'd3)begin
                        data <= data_memory6[data_counter];
                    end else if (debouncer_count_out == 4'd4)begin 
                        data <= data_memory5[data_counter];
                    end else if (debouncer_count_out == 4'd5)begin
                        data <= data_memory2[data_counter];
                    end else if (debouncer_count_out == 4'd6)begin
                        data <= data_memory4[data_counter];
                    end else if (debouncer_count_out == 4'd7)begin
                        data <= data_memory3[data_counter];
                    end else if (debouncer_count_out == 4'd8)begin
                        data <= data_memory[data_counter];
                    end 

                    end

                        data_counter <= data_counter + 1;
                        if(char_counter == char_data -1) begin
                            char_counter = 0;
                            create_char_task <= SET_CGRAM_ADDR;
                            cgram_addrs_counter <= cgram_addrs_counter + 1;
                        end else begin
                            char_counter <= char_counter +1;
                        end
                    end
                endcase
            end
            CLEAR_COUNTERS1: begin
                data_counter <= 'b0;
                char_counter <= 'b0;
                create_char_task <= SET_CURSOR;
                cgram_addrs_counter <= 'b0;
            end
            SET_CURSOR_AND_WRITE: begin
                case(create_char_task)
					SET_CURSOR: begin
                        rs <= 0; data <= (cgram_addrs_counter > 2)? 8'h80 + (cgram_addrs_counter%3) + 8'h40 : 8'h80 + (cgram_addrs_counter%3);
                        create_char_task <= WRITE_LCD; 
                    end
                    WRITE_LCD: begin
                        rs <= 1; 
                        data <=  8'h00 + cgram_addrs_counter;
                        if(cgram_addrs_counter == num_cgram_addrs-1)begin
                            cgram_addrs_counter = 'b0;
                            done_lcd_write <= 1'b1;
                        end else begin
                            cgram_addrs_counter <= cgram_addrs_counter + 1;
                        end
                        create_char_task <= SET_CURSOR; 
                    end
                endcase
            end
                    WRITE_ADDITIONAL_TEXT: begin
                        if (text_counter == 0) begin
                            rs <= 0;
                            data <= 8'h84; // Posiciona el cursor después de los caracteres especiales
                            text_counter <= text_counter + 1;
                        end else if (!writing_line2 && text_counter <= text_lenght) begin
                            rs <= 1;
                         if (test_mode == 1'b0) begin
                            if (vida == 0 ) begin 
                            data <= text_memory8[text_counter-1];
                            end else if (!sensor_pir)begin 
                            data <= text_memory7[text_counter-1];
                            end else if (felicidad <= 2)begin 
                            data <= text_memory6[text_counter-1];
                            end else if (vida <= 2)begin 
                            data <= text_memory5[text_counter-1];
                            end else if (hambre <= 2)begin 
                            data <= text_memory2[text_counter-1];
                            end else if (energia <= 2)begin 
                            data <= text_memory4[text_counter-1];
                            end else if (diversion <= 2)begin 
                            data <= text_memory3[text_counter-1];
                            end else if (felicidad > 2)begin 
                            data <= text_memory[text_counter  -1];
                            end 
                         end

                         if (test_mode == 1'b1) begin
                            if (debouncer_count_out == 4'd1 ) begin 
                            data <= text_memory8[text_counter-1];
                            end else if (debouncer_count_out == 4'd2)begin 
                            data <= text_memory7[text_counter-1];
                            end else if (debouncer_count_out == 4'd3)begin 
                            data <= text_memory6[text_counter-1];
                            end else if (debouncer_count_out == 4'd4)begin 
                            data <= text_memory5[text_counter-1];
                            end else if (debouncer_count_out == 4'd5)begin 
                            data <= text_memory2[text_counter-1];
                            end else if (debouncer_count_out == 4'd6)begin 
                            data <= text_memory4[text_counter-1];
                            end else if (debouncer_count_out == 4'd7)begin 
                            data <= text_memory3[text_counter-1];
                            end else if (debouncer_count_out == 4'd8)begin 
                            data <= text_memory[text_counter  -1];
                            end 
                         end

                            text_counter <= text_counter + 1;
									 if (text_counter == text_lenght) begin
                               writing_line2 <= 1;
                               text_counter2 <=0;
									 end
									 
						 end else if (writing_line2 && text_counter2 == 0) begin
                    rs <= 0;
                    data <= 8'hC4; // Posicionar cursor al inicio de la segunda línea
                    text_counter2 <= text_counter2 + 1;
                end else if (writing_line2 && text_counter2 <= text_lenght2) begin
                    rs <= 1;
                    if (test_mode) begin
                        data <= text_test_mode[text_counter2-1];
						  end else if (racing_mode) begin
						      data <= text_racing_mode[text_counter2-1];
                    end else begin 
						      data <= 8'h20;
						  end
                    text_counter2 <= text_counter2 + 1;
						  
                       end else begin
                            text_write_done <= 1'b1;
                            text_counter <= 0;
									 text_counter2 <= 0;
                            writing_line2 <= 0;
                        end
                    end

                endcase
            end
        end

//----------------------------------------------------------------------------------------------------------------------------\\

assign enable = clk_16ms;
assign done_cgram_write = (data_counter == num_data_all-1)? 'b1 : 'b0;



endmodule
//--------------------------------------------------------------------------------------------------------------------------------\\
