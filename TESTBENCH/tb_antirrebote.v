`timescale 1ns / 1ps

module tb_boton_antirrebote();

// Definir señales del testbench
reg clk;
reg reset;
reg btn_in;
wire out;
wire [3:0] count_out;

// Instanciar el módulo bajo prueba (DUT - Device Under Test)
boton_antirrebote uut (
    .btn_in(btn_in),
    .clk(clk),
    .reset(reset),
    .out(out),
    .count_out(count_out)
);

// Generar reloj con un periodo de 20ns (50 MHz)
initial begin
    clk = 0;
    forever #10 clk = ~clk;  // Cada ciclo de 20ns
end

// Proceso de simulación
initial begin
    // Inicialización
    btn_in = 0;
    reset = 0;

    // Reset del sistema
    #50 reset = 1;  // Activar reset después de 50 ns

    // Simular pulsaciones de botón
    #100 btn_in = 1;  // Pulsar botón
    #500 btn_in = 0;  // Soltar botón
    #200 btn_in = 1;  // Pulsar botón nuevamente
    #300 btn_in = 0;  // Soltar botón
    #200 btn_in = 1;  // Pulsar botón otra vez
    #300 btn_in = 0;  // Soltar botón

    // Terminar la simulación después de un tiempo
    #1000 $finish;
end

// Monitorear señales importantes
initial begin
    $monitor("Time: %0d ns | clk: %b | reset: %b | btn_in: %b | out: %b | count_out: %d", 
             $time, clk, reset, btn_in, out, count_out);
end

endmodule
