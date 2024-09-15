module display_7seg_4digitos(
    input wire clk,
    input wire reset,
    input wire [3:0] digit_0,
    input wire [3:0] digit_1,
    input wire [3:0] digit_2,
    input wire [3:0] digit_3,
    input wire [3:0] digit_4,
    output reg [6:0] seg_0,
    output reg [4:0] an
);

reg [19:0] counter_7seg;

function [6:0] seven_seg;
    input [3:0] digit;
    begin
        case(digit)
            4'h0: seven_seg = 7'b1000000; // 0
            4'h1: seven_seg = 7'b1111001; // 1
            4'h2: seven_seg = 7'b0100100; // 2
            4'h3: seven_seg = 7'b0110000; // 3
            4'h4: seven_seg = 7'b0011001; // 4
            4'h5: seven_seg = 7'b0010010; // 5
            4'h6: seven_seg = 7'b0000010; // 6
            4'h7: seven_seg = 7'b1111000; // 7
            4'h8: seven_seg = 7'b0000000; // 8
            4'h9: seven_seg = 7'b0010000; // 9
            default: seven_seg = 7'b1111111; // Todos apagados
        endcase
    end
endfunction

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        counter_7seg <= 0;
        seg_0 <= 7'b1111111; // Todos los segmentos apagados
        an <= 5'b11111; // Todos los ánodos desactivados
    end else begin
        counter_7seg <= counter_7seg + 1;
        
        case(counter_7seg[19:17])
            3'b000: begin
                an <= 5'b11110; // Dígito más a la derecha
                seg_0 <= seven_seg(digit_0);
            end
            3'b001: begin
                an <= 5'b11101; // Segundo desde la derecha
                seg_0 <= seven_seg(digit_1);
            end
            3'b010: begin
                an <= 5'b11011; // Segundo desde la izquierda
                seg_0 <= seven_seg(digit_2);
            end
            3'b011: begin
                an <= 5'b10111; // Dígito más a la izquierda
                seg_0 <= seven_seg(digit_3);
            end
            3'b100: begin
                an <= 5'b01111; // Dígito más a la izquierda
                seg_0 <= seven_seg(digit_4);
            end

        endcase
    end
end

endmodule
