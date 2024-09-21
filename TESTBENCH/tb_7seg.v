`timescale 1ns / 1ps

module tb_display7SEG();

// Definir las señales del testbench
reg clk;              // Señal de reloj
reg reset;            // Señal de reset
reg [3:0] hambre;     // Primer dígito (hambre)
reg [3:0] diversion;  // Segundo dígito (diversión)
reg [3:0] energia;    // Tercer dígito (energía)
reg [3:0] felicidad;  // Cuarto dígito (felicidad)
reg [3:0] vida;       // Quinto dígito (vida)

wire [6:0] seg_0;     // Señal de salida de segmentos
wire [3:0] an;        // Señal de activación de los dígitos

// Instancia del módulo a testear
display7SEG uut (
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

// Generar la señal de reloj
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Período del reloj de 10 unidades de tiempo
end

// Proceso inicial
initial begin
    // Inicializar las señales
    reset = 1'b0;    // Aplicar reset inicialmente
    hambre = 4'h0;
    diversion = 4'h0;
    energia = 4'h0;
    felicidad = 4'h0;
    vida = 4'h0;

    // Esperar un poco y luego liberar el reset
    #20;
    reset = 1'b1;   // Liberar reset

    // Simular cambios en los valores de los dígitos
    #50;
    hambre = 4'h6;
    diversion = 4'h5;
    energia = 4'h4;
    felicidad = 4'h3;
    vida = 4'h2;

    // Esperar y cambiar de nuevo
    #100;
    hambre = 4'h9;
    diversion = 4'h8;
    energia = 4'h7;
    felicidad = 4'h6;
    vida = 4'h5;

    // Esperar un poco más
    #100;
    reset = 1'b0;  // Resetear de nuevo
    #10;
    reset = 1'b1;  // Quitar el reset

    #200;
    $stop;         // Terminar la simulación
end

endmodule
