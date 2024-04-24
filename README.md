# Entrega 1 del proyecto WP01

## Integrantes 

Juan Manuel Beltrán Botello

Oscar Jhondairo Siabato León

Willian Mauricio Meza Patiño

Jhon Alejandro Cuaspud


# Propuesta Inicial para el Proyecto en FPGA: 
Implementación de un Tamagotchi
Introducción: En este proyecto, proponemos  implementar un Tamagotchi en una FPGA Cyclone IV. El Tamagotchi será una mascota virtual que responderá a la interacción del usuario mediante botones y a estímulos ambientales a través de sensores de sonido y luz. La salida del sistema incluirá un display de 7 segmentos para mostrar los niveles y puntuación de la mascota, así como una matriz de puntos de 8x8 para representar su estado gráficamente.

## Objetivos:

Diseñar e implementar un sistema de interacción para el usuario mediante cinco botones: alimentar, premiar, regañar, reset y test.
Integrar dos sensores, uno de sonido para detectar cuando la mascota es despertada y otro de luz para determinar si es de día o de noche.
Desarrollar la lógica de control para coordinar las interacciones del usuario y los estímulos ambientales.
Implementar salidas visuales utilizando un display de 7 segmentos y una matriz de puntos de 8x8 para representar el estado y la puntuación de la mascota.
Optimizar el diseño para minimizar el uso de recursos en la FPGA Cyclone IV.
## Especificaciones

Se realizo las especificaciones generales del funcionamiento del proyecto, representado en la caja negra en general de la FPGA representando cada modulo que se va a usar, y tambien representando las cajas negras de los respectivos modulos 

<img src= "especificacion.jpg">

# Especificacion del sistema

# Arquitectura del sistma 
## Periférico: Sensor de Luz

Funcionalidad: Un sensor de luz es un dispositivo que detecta la intensidad de la luz en el ambiente. Se utilizará para determinar el nivel de iluminación en nuestro entorno ,con esto se definirá la noche y el día para nuestra mascota  

Implementación en HDL: En el lenguaje de descripción de hardware, el sensor de luz se implementa como un módulo que tiene una interfaz de entrada y salida. La interfaz de entrada se utiliza para recibir las señales del sensor de luz cuando detecta un cambio en la intensidad de la luz. La interfaz de salida se utiliza para enviar estos datos al sistema principal.

Comunicación con el sistema: El sensor de luz se comunica con el sistema principal a través de una interfaz de bus. Cuando el sensor detecta un cambio en la intensidad de la luz,solo tendremos dos estados, iluminación máxima e iluminación mínima.osea solo un 1 y un 0, cero para cuando el sensor esté en su mínimo valor.  

### b) Uso de un lenguaje adecuado para describir el sistema.

#### Módulo principal del Tamagotchi: 
Este módulo coordinará todas las funcionalidades y componentes del Tamagotchi. Contendrá la lógica de control principal y estará conectado a los botones, sensores y salidas.

se define un módulo que detecte cuándo se presionan los botones y genere señales correspondientes para indicar qué botón se ha presionado.
Utiliza un registro de retardo para evitar rebotes en los botones y garantizar una detección precisa de las pulsaciones.
luego se Asigna a cada botón una función específica (alimentar, premiar, regañar, reset, test).


    '''

    module botones(
        input wire clk, // Señal de reloj
        input wire [4:0] botones, // Señales de los botones
        output reg alimentar_pressed, // Señales de salida para cada botón
        output reg premiar_pressed,
        output reg regañar_pressed,
        output reg reset_pressed,
        output reg test_pressed);
     
     always @(posedge clk) begin 

     alimentar_pressed <= (botones[0]) ? 1'b1 : 1'b0;
     premiar_pressed <= (botones[1]) ? 1'b1 : 1'b0;
     regañar_pressed <= (botones[2]) ? 1'b1 : 1'b0;
     reset_pressed <= (botones[3]) ? 1'b1 : 1'b0;
     test_pressed <= (botones[4]) ? 1'b1 : 1'b0;
     end
     endmodule

### Módulo de sensor de sonido: 

Este módulo leerá el sensor de sonido y generará una señal para indicar si se ha detectado sonido (la mascota ha sido despertada).
con esto buscamos un módulo que lea el sensor de sonido y genere una señal cuando se detecte sonido.
para esto considera la sensibilidad del sensor y establece un umbral adecuado para detectar sonido de manera confiable. Ademas identificar los estados en los que puede transicionar el Tamagotchi dependiendo la proximidad de su amo.

```
 module sensor_sonido(input wire clk, // Señal de reloj
    input wire sonido, // Señal del sensor de sonido
    output reg despertar); // Señal de salida para despertar

 reg [3:0] contador;

 always @(posedge clk) begin
    if (sonido) begin
    contador <= 4'd5; // Tiempo de espera para estabilizar la señal
    despertar <= 1'b1;
    end else if (contador > 0) begin
    contador <= contador - 1;
     despertar <= 1'b1; // Mantener señal alta durante el tiempo de estabilización
    end else begin
        despertar <= 1'b0;
    end
 end
 endmodule 
 
 ```
### Módulo de sensor de luz:

Este módulo leerá el sensor de luz y generará una señal para indicar si es de día o de noche.
en este caso se crea un módulo que lea el sensor de luz y determine si es de día o de noche.
con esto podemos definir umbrales para distinguir entre la luz del día y la oscuridad (noche), y poder hacer trancisiones entre los estados del Tamagotchi .

```
module sensor_luz(input wire luz, // Señal del sensor de luz
                  output reg dia); // Señal de salida para indicar si es de día

always @(*) begin
    dia = (luz) ? 1'b1 : 1'b0; // Si la señal de luz está activa, es de día
end
endmodule
```