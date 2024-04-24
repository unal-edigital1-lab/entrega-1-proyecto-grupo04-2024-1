# Entrega 1 del proyecto WP01

# Propuesta Inicial para el Proyecto en FPGA: 
Implementación de un Tamagotchi
Introducción: En este proyecto, proponemos  implementar un Tamagotchi en una FPGA Cyclone IV. El Tamagotchi será una mascota virtual que responderá a la interacción del usuario mediante botones y a estímulos ambientales a través de sensores de sonido y luz. La salida del sistema incluirá un display de 7 segmentos para mostrar los niveles y puntuación de la mascota, así como una matriz de puntos de 8x8 para representar su estado gráficamente.
## Objetivos:
Diseñar e implementar un sistema de interacción para el usuario mediante cinco botones: alimentar, premiar, regañar, reset y test.
Integrar dos sensores, uno de sonido para detectar cuando la mascota es despertada y otro de luz para determinar si es de día o de noche.
Desarrollar la lógica de control para coordinar las interacciones del usuario y los estímulos ambientales.
Implementar salidas visuales utilizando un display de 7 segmentos y una matriz de puntos de 8x8 para representar el estado y la puntuación de la mascota.
Optimizar el diseño para minimizar el uso de recursos en la FPGA Cyclone IV.

## Periféricos 
# Periférico: Sensor de Luz

Funcionalidad: Un sensor de luz es un dispositivo que detecta la intensidad de la luz en el ambiente. Se utilizará para determinar el nivel de iluminación en nuestro entorno ,con esto se definirá la noche y el día para nuestra mascota  

Implementación en HDL: En el lenguaje de descripción de hardware, el sensor de luz se implementa como un módulo que tiene una interfaz de entrada y salida. La interfaz de entrada se utiliza para recibir las señales del sensor de luz cuando detecta un cambio en la intensidad de la luz. La interfaz de salida se utiliza para enviar estos datos al sistema principal.

Comunicación con el sistema: El sensor de luz se comunica con el sistema principal a través de una interfaz de bus. Cuando el sensor detecta un cambio en la intensidad de la luz,solo tendremos dos estados, iluminación máxima e iluminación mínima.osea solo un 1 y un 0, cero para cuando el sensor esté en su mínimo valor.  
