    module boton_antirrebote(
        input wire btn_in, clk,reset,
        output wire out,
        output reg led,
        output wire [3:0] count_out  
    );

//------------------------------------Registros-----------------------------------------------------\\
    // Estado anterior del boton
    reg btn_prev = 0;
    // Estado rebote del botón 
    reg btn_out = 0;
    // Contador de ruido (para rebote)
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
	// Se cumple si alguno los valores son diferentes
        if (btn_prev ^ btn_in == 1'b1) begin
            counter <= 0;
            btn_prev <= btn_in;
	// Comprobar que el boton se ha encontrado en un estado estable
        end else if (counter[16] == 1'b0) begin
            counter <= counter + 1;
        end else begin
	   // Estado verdadero despues de elimina los rebotes 	
            btn_out <= btn_prev;
          // Logica de detectar cuantas veces se a oprimido el boton
            if (btn_out == 1'b1 && btn_prev == 1'b0) begin
		// Reinicia el contador si se a pulsado 8 veces
		if (press_counter == 4'd8) begin
                press_counter <= 4'b0;                 
                end else begin
                    press_counter <= press_counter + 4'b1;
            end
          end
        end
    end
end
//----------------------------------------------------------------------------------------------------------\\

// Asigación de registros
    assign out = btn_out;
    assign count_out = press_counter;

    endmodule
