
`timescale 1ns/1ps  // Set time scale for simulation in microseconds and nanoseconds
module i2c_master2 (
    input rst, // Reset input
    input clk, // Clock input
    input rw, // Read/Write input
    input scl_enable, // SCL enable input
    input [6:0] i2c_address, // I2C address input (TCS3502)
    input [7:0] i2c_data_in, // I2C data input
    output reg sda_out_m, // SDA output
    output reg scl_out_m, // SCL output
    output reg addr_ack, // Address acknowledge output
    output reg data_ack, // Data acknowledge output
    input [7:0] i2c_wData, // I2C write data input
    output reg [7:0] i2c_rData // I2C read data output
);

parameter I2C_START = 3'b000; 
parameter I2C_IDLE = 3'b001;
parameter I2C_CLOCK_LOW = 3'b010;
parameter I2C_CLOCK_HIGH = 3'b011;
parameter I2C_STOP = 3'b100;
parameter I2C_DATA_SHIFT = 3'b101;
parameter I2C_ACK_CHECK = 3'b110; // Verificación de ACK
parameter I2C_READ = 3'b111; // Lectura de datos del sensor

reg [2:0] state_M; // Estado de la máquina de estados
reg [4:0] bit_count; 
reg [17:0] i2c_shift_reg;
reg [7:0] shift_reg;
reg sda_in_m; 

// Direcciones y registros del TCS3502
parameter TCS3502_ADDR = 7'h29; // Dirección del TCS3502
parameter REG_ENABLE = 8'h00;   // Registro de habilitación
parameter REG_CLEAR = 8'h14;    // Registro de datos Clear

always @(posedge clk or negedge rst) begin
    if(~rst) begin
        sda_out_m <= 1'b1;
        scl_out_m <= 1'b1;
        bit_count <= 0;
        i2c_rData <= 8'h00;
        state_M <= I2C_IDLE;
    end else begin
        case(state_M)
            I2C_IDLE: begin
                if (scl_enable) begin
                    state_M <= I2C_START;
                end
            end

            I2C_START: begin
                sda_out_m <= 1'b0; // Start condition
                scl_out_m <= 1'b1;
                state_M <= I2C_CLOCK_LOW;
                i2c_shift_reg <= {TCS3502_ADDR, rw}; // Enviar dirección del sensor
            end

            I2C_CLOCK_LOW: begin
                scl_out_m 
                
                <= 1'b0;
                sda_out_m <= i2c_shift_reg[17]; // Enviar bit por bit
                i2c_shift_reg <= i2c_shift_reg << 1;
                state_M <= I2C_CLOCK_HIGH;
            end

            I2C_CLOCK_HIGH: begin
                scl_out_m <= 1'b1;
                bit_count <= bit_count + 1;
                if (bit_count == 8) begin
                    state_M <= I2C_ACK_CHECK; // Comprobar el ACK
                end else if (bit_count == 16) begin
                    state_M <= (rw == 1) ? I2C_READ : I2C_STOP; // Lectura o parada
                end else begin
                    state_M <= I2C_CLOCK_LOW;
                end
            end

            I2C_ACK_CHECK: begin
                // Esperar el ACK del esclavo
                if (sda_in_m == 0) begin
                    addr_ack <= 1'b1; // Recibido correctamente
                end else begin
                    addr_ack <= 1'b0; // Error de ACK
                end
                state_M <= I2C_CLOCK_LOW;
            end

            I2C_READ: begin
                scl_out_m <= 1'b0;
                sda_in_m <= 1'bz; // Liberar SDA para lectura
                state_M <= I2C_CLOCK_HIGH;
            end

            I2C_STOP: begin
                sda_out_m <= 1'b1; // Stop condition
                scl_out_m <= 1'b1;
                state_M <= I2C_IDLE;
            end

            default: state_M <= I2C_IDLE;
        endcase
    end
end

endmodule