`timescale 1ns/1ps  // Set time scale for simulation in microseconds and nanoseconds
module tb_i2c_master2(

    // Declarar las señales que se conectarán al DUT (Device Under Test)
    reg rst;
    reg clk;
    reg rw; // Read/Write control
    reg scl_enable;
    reg [6:0] i2c_address;
    reg [7:0] i2c_data_in;
    reg [7:0] i2c_wData;
    wire sda_out_m;
    wire scl_out_m;
    wire addr_ack;
    wire data_ack;
    wire [7:0] i2c_rData;
);
    
    i2c_master2 uut (
        .rst(rst),
        .clk(clk),
        .rw(rw),
        .scl_enable(scl_enable),
        .i2c_address(i2c_address),
        .i2c_data_in(i2c_data_in),
        .sda_out_m(sda_out_m),
        .scl_out_m(scl_out_m),
        .addr_ack(addr_ack),
        .data_ack(data_ack),
        .i2c_wData(i2c_wData),
        .i2c_rData(i2c_rData)
    );

    // Generar el reloj (Clock) para la simulación
    always begin
        #5 clk = ~clk; // Cambiar el estado cada 5 unidades de tiempo
    end

    // Inicializar los valores y ejecutar la simulación
    initial begin
        // Inicialización de señales
        rst = 1;
        clk = 0;
        rw = 0; // Inicialmente, Write
        scl_enable = 0;
        i2c_address = 7'h29; // Dirección del TCS3502
        i2c_data_in = 8'h00;
        i2c_wData = 8'h00;

        // Soltar el reset después de unos ciclos
        #10 rst = 0;
        #10 rst = 1;

        // Simular un ciclo de escritura al registro de habilitación del sensor
        #20 rw = 0; // Write operation
        scl_enable = 1;
        i2c_address = 7'h29; // Dirección del TCS3502
        i2c_wData = 8'h03; // Valor para habilitar el sensor (escribir en REG_ENABLE)

        #50 scl_enable = 0; // Desactivar SCL después de la operación de escritura

        // Simular un ciclo de lectura del registro CLEAR del sensor
        #100 rw = 1; // Leer
        scl_enable = 1;
        i2c_address = 7'h29; // Dirección del TCS3502

        #50 scl_enable = 0; // Desactivar SCL después de la operación de lectura

        // Finalizar la simulación
        #200 $finish;
    end

    // Monitoreo de señales
 initial begin
  $monitor("Time = %0t, rst = %b, scl_enable = %b, rw = %b, i2c_address = %h, i2c_wData = %h, sda_out_m = %b, scl_out_m = %b, addr_ack = %b, data_ack = %b, i2c_rData = %h",
         $time, rst, scl_enable, rw, i2c_address, i2c_wData, sda_out_m, scl_out_m, addr_ack, data_ack, i2c_rData);
 end

endmodule