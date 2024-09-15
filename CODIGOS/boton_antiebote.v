    module boton_antirrebote(
        input wire btn_in, clk,reset,
        output wire out,
        output reg led,
        output wire [3:0] count_out  
    );

//------------------------------------Registros-----------------------------------------------------\\
    // Estado anterior del boton
    reg btn_prev = 0;
	 // Estado debounced del botón 
    reg btn_out = 0;
	 // Contador de ruido (para debouncing)
    reg [16:0] counter = 0;
    reg [3:0] press_counter = 0;  

//----------------------------------------------------------------------------------------------------\\

//-------------------------------------------Logica boton antirrebote--------------------------------------\\

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        press_counter <= 0;
        btn_prev <= 0;
        btn_out <= 0;
        counter <= 0;
    end else begin
        if (btn_prev ^ btn_in == 1'b1) begin
            counter <= 0;
            btn_prev <= btn_in;
        end else if (counter[16] == 1'b0) begin
            counter <= counter + 1;
        end else begin
            btn_out <= btn_prev;
            
            if (btn_out == 1'b1 && btn_prev == 1'b0) begin
				if (press_counter == 4'd8) begin
                press_counter <= 4'b0;                 
                end else begin
                    press_counter <= press_counter + 4'b1;
            end
          end
        end
    end
end


    assign out = btn_out;
    assign count_out = press_counter;

    endmodule
