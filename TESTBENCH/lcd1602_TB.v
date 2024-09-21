`timescale 1ns / 1ps
`include "lcd1602_cust_char.v"

module LCD1602_controller_TB();
    reg clk;
    reg rst;
    reg ready_i;

    LCD1602_controller #(3, 56, 8, 7, 50) uut (
        .clk(clk),
        .reset(rst),
        .ready_i(ready_i)
    );

    initial begin
        clk = 0;
        rst = 1;
        ready_i = 1;
        #10 rst = 0;
        #10 rst = 1;
    end

    always #10 clk = ~clk;

    initial begin: TEST_CASE
        $dumpfile("C:/CARAS_2/feliz_cara.txt");
        $dumpvars(-1, uut);
        #(1000000) $finish;
    end


endmodule