module LCD1602_top #(parameter num_commands = 3, 
                                      num_data_all = 48,  
                                      char_data = 8, 
                                      num_cgram_addrs = 6,
                                      text_lenght = 12,
												  text_lenght2 = 12,
                                      COUNT_MAX = 800000)(
    input clk,            
    input reset,          
    input ready_i,
    output reg rs,        
    output reg rw,
    output enable,   
    output reg [7:0] data,


    input btn_vida,
    input btn_alimentar,
    input btn_racing_mode,
	 
//---------------------- 7 segmentos ---------------------------------------------\\

    output wire [6:0] seg_0,
    output wire [4:0] an, 
//--------------------------------------------------------------------------------\\

//---------------------------------sensor pir------------------------------\\

     input sensor_pir,

//--------------------------------------------------------------------------------\\  

//----------------------------Sensor vibracion----------------------------------------\\

     input sensor_vibracion,

//------------------------------------------sensor ultasonido----------------------------\\

    input echo,
    output trigger,


//----------------------------------------------------------------------------------------\\

		  
//----------------------------------- boton ----------------------------------------\\

    input wire btn_in,
    output wire debounced_out,
    output wire debouncer_led,
    output wire [3:0] debouncer_count_out

//-----------------------------------------------------------------------------------\\

    
     
);




// Definir los estados del controlador

localparam IDLE = 0;
localparam INIT_CONFIG = 1;
localparam CLEAR_COUNTERS0 = 2;
localparam CREATE_CHARS = 3;
localparam CLEAR_COUNTERS1 = 4;
localparam SET_CURSOR_AND_WRITE = 5;
localparam WRITE_ADDITIONAL_TEXT = 6;

 

localparam SET_CGRAM_ADDR = 0;
localparam WRITE_CHARS = 1;
localparam SET_CURSOR = 2;
localparam WRITE_LCD = 3;
localparam CHANGE_LINE = 4;

// Direcciones de escritura de la CGRAM 
localparam CGRAM_ADDR0 = 8'h40;
localparam CGRAM_ADDR1 = 8'h48;
localparam CGRAM_ADDR2 = 8'h50;
localparam CGRAM_ADDR3 = 8'h58;
localparam CGRAM_ADDR4 = 8'h60;
localparam CGRAM_ADDR5 = 8'h68;
localparam CGRAM_ADDR6 = 8'h70;

//Registros de la maquina de estados LCD
reg [3:0] fsm_state;
reg [3:0] next;
reg clk_16ms;

// Definir un contador para el divisor de frecuencia
reg [$clog2(COUNT_MAX)-1:0] counter_div_freq;

// Comandos de configuración
localparam CLEAR_DISPLAY = 8'h01;
localparam SHIFT_CURSOR_RIGHT = 8'h06;
localparam DISPON_CURSOROFF = 8'h0C;
localparam DISPON_CURSORBLINK = 8'h0E;
localparam LINES2_MATRIX5x8_MODE8bit = 8'h38;
localparam LINES2_MATRIX5x8_MODE4bit = 8'h28;
localparam LINES1_MATRIX5x8_MODE8bit = 8'h30;
localparam LINES1_MATRIX5x8_MODE4bit = 8'h20;
localparam START_2LINE = 8'hC0;

// Definir un contador para controlar el envío de comandos
reg [$clog2(num_commands):0] command_counter;
// Definir un contador para controlar el envío de cada dato
reg [$clog2(num_data_all):0] data_counter;
// Definir un contador para controlar el envío de caracteres a la CGRAM
reg [$clog2(char_data):0] char_counter;
// Definir un contador para controlar el envío de comandos
reg [$clog2(num_cgram_addrs):0] cgram_addrs_counter;
// Definir un contador para controlar el envío de texto linea 1
reg[$clog2(text_lenght):0] text_counter;
// Definir un contador para controlar el envío de texto linea 1
reg[$clog2(text_lenght):0] text_counter2;



// -----------------------Bancos de registros---------------------------------------------\\

//registros de caras 
reg [7:0] data_memory [0:num_data_all-1];
reg [7:0] data_memory2 [0:num_data_all-1];
reg [7:0] data_memory3 [0:num_data_all-1];
reg [7:0] data_memory4 [0:num_data_all-1];
reg [7:0] data_memory5 [0:num_data_all-1];
reg [7:0] data_memory6 [0:num_data_all-1];
reg [7:0] data_memory7 [0:num_data_all-1];
reg [7:0] data_memory8 [0:num_data_all-1];

//registro de texto

reg [7:0] text_memory [0:text_lenght-1];
reg [7:0] text_memory2 [0:text_lenght-1];
reg [7:0] text_memory3 [0:text_lenght-1];
reg [7:0] text_memory4 [0:text_lenght-1];
reg [7:0] text_memory5 [0:text_lenght-1];
reg [7:0] text_memory6 [0:text_lenght-1];
reg [7:0] text_memory7 [0:text_lenght-1];
reg [7:0] text_memory8 [0:text_lenght-1];
reg [7:0] text_test_mode [0:text_lenght-1];
reg [7:0] text_racing_mode [0:text_lenght-1];

//Registro de la cgram
reg [7:0] config_memory [0:num_commands-1]; 
reg [7:0] cgram_addrs [0: num_cgram_addrs-1];
reg [1:0] create_char_task;
reg init_config_executed;
wire done_cgram_write;
reg done_lcd_write;

//Registos de escribir texto
reg text_write_done;
reg writing_line2;

//--------------------------------------Contadores--------------------------\\

reg [35:0]counter_tiempo;
reg [35:0]counter_tiempo_racing;
wire [31:0] echo_counter;

//--------------------------------------------------------------------------------\\

//-------------------------------Registros modos-----------------------------------\\

reg game_over;
reg test_mode;
reg racing_mode;

//----------------------------------------------------------------------------------\\

//----------------7 segmentos-------------------------------\\

reg [4:0] hambre, diversion, energia, felicidad, vida;

//------------------------------------------------------------\\

initial begin
    fsm_state <= IDLE;
    data <= 'b0;
    command_counter <= 'b0;
    data_counter <= 'b0;
    rw <= 0;
	rs <= 0;
    clk_16ms <= 'b0;
    counter_div_freq <= 'b0;
    init_config_executed <= 'b0;
    cgram_addrs_counter <= 'b0; 
    char_counter <= 'b0;
    done_lcd_write <= 1'b0; 
    

    create_char_task <= SET_CGRAM_ADDR;

    counter_tiempo = 31'd0;

    game_over <= 1'b0; 
    test_mode <=1'b0;
    racing_mode <= 1'b0;


    text_write_done <= 1'b0;
    text_counter <=0;
	 text_counter2 <=0;
	 writing_line2 <=0;

//------------------------------------------------------------------------------------------------------\\

//caracteres

    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/feliz_cara.txt", data_memory);
	 $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/hambriento_cara.txt", data_memory2);
	 $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/aburrido_cara.txt", data_memory3); 
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/cansado_cara.txt", data_memory4);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/enfermo_cara.txt", data_memory5);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/triste_cara.txt", data_memory6);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/dormido_cara.txt", data_memory7);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/muerto_cara.txt", data_memory8);

//Texto

    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/feliz_texto.txt", text_memory); 
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/hambriento_texto.txt", text_memory2); 
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/aburrido_texto.txt", text_memory3);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/cansado_texto.txt", text_memory4);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/enfermo_texto.txt", text_memory5);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/triste_texto.txt", text_memory6);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/dormido_texto.txt", text_memory7);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/muerto_texto.txt", text_memory8);
	 $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/test_mode_texto.txt", text_test_mode);
	 $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/racing_mode_texto.txt", text_racing_mode);

	config_memory[0] <= LINES2_MATRIX5x8_MODE8bit;
	config_memory[1] <= DISPON_CURSOROFF;
	config_memory[2] <= CLEAR_DISPLAY;

    cgram_addrs[0] <= CGRAM_ADDR0;
    cgram_addrs[1] <= CGRAM_ADDR1;
    cgram_addrs[2] <= CGRAM_ADDR2;
    cgram_addrs[3] <= CGRAM_ADDR3;
    cgram_addrs[4] <= CGRAM_ADDR4;
    cgram_addrs[5] <= CGRAM_ADDR5;
end

//----------------------------Contadol tiempo-------------------------------------------------------------\\

    always @(posedge clk or negedge reset ) begin
        if (!reset) begin      
            counter_tiempo <= 36'b0;     
        end else begin
            if(racing_mode == 1'b0)begin 
            if (counter_tiempo == 36'd45000000000) begin
                counter_tiempo = 36'b0;
            end else begin
                counter_tiempo = counter_tiempo + 1;
            end 
         end
			
			//contador acelerado
			
         if(racing_mode == 1'b1)begin
          if (counter_tiempo_racing == 36'd45000000000) begin
                counter_tiempo_racing = 36'b0;
            end else begin
                counter_tiempo_racing = counter_tiempo_racing + 8;
            end 
            counter_tiempo <= counter_tiempo_racing;
         end
        end
    end


//-------------------------------------------------------------------------------------------------\\

//------------------------7 segmentos---------------------------------------------------------------\\

display_7seg_4digitos display(
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


always @(posedge clk or negedge reset) begin
    if (!reset) begin
        hambre <= 4'h6;
        diversion <= 4'h6;
        energia <= 4'h6;
        felicidad <= 4'h5;
        vida <= 4'h5;
        game_over <= 1'b0;
        test_mode <= 1'b0;
        racing_mode <= 1'b0;
    end else begin 
        
     if (vida == 4'h0) begin
        game_over <= 1'b1;
     end

//---------------------------------------------modo test-------------------------------------------------\\

     if (btn_in == 1'b0 && counter_tiempo % 250000000 == 0 && racing_mode == 1'b0) begin
        test_mode <= 1'b1;
     end
     if (test_mode == 1'b1) begin
        hambre <= 4'h5;
        diversion <= 4'h5;
        energia <= 4'h5;
        felicidad <= 4'h5;
        vida <= 4'h5;
     end

     if(btn_in == 1'b0 && counter_tiempo % 250000000 == 0 && test_mode == 1'b1)begin 
        test_mode <= 1'b0;
     end
//-----------------------------------------------------------------------------------------------\\

//--------------------------------------------modo rapido------------------------------------------\\

    if(btn_racing_mode == 1'b0 && counter_tiempo % 250000000 == 0 && test_mode == 1'b0) begin
       racing_mode <= 1'b1;
    end
    if(btn_racing_mode == 1'b0 && counter_tiempo % 2000000000 == 0 && racing_mode == 1'b1) begin
       racing_mode <= 1'b0;
    end
    

//-------------------------------------------------------------------------------------------------------\\

//------------------------------------------------------------Logica de puntajes---------------------------------------------------------\\

    if (game_over) begin 

        if(!reset)  begin

        hambre <= 4'h6;
        diversion <= 4'h6;
        energia <= 4'h6;
        felicidad <= 4'h5;
        vida <= 4'h5;
        game_over <= 1'b0;

    end

    end else begin 
	 
	 if (counter_tiempo % 2500000000 == 0 && hambre > 4'h0) begin
        hambre <= hambre - 4'h1;
    end 

	 
    if (counter_tiempo % 1250000000 == 0 && diversion > 4'h0 && sensor_pir == 1) begin
        diversion <= diversion - 4'h1;
    end

    if (counter_tiempo % 5000000000 == 0 && energia > 4'h0 && sensor_pir == 1) begin 
        energia <= energia - 4'h1;      
     end
	  
//---------------------------------logica dormido-----------------------------------------------------\\

    if (sensor_pir == 0 && counter_tiempo % 625000000 == 0 && energia<5) begin 
      energia <= energia + 1;
    end
    if (sensor_pir == 0 && counter_tiempo % 2500000000 == 0 && energia > 4 && vida<5) begin 
        vida <= vida + 1;
    end

//-----------------------------------------------------------------------------------------------\\

//---------------------logicas de felicidad------------------------------------------------\\

     if (counter_tiempo % 2500000000 == 0 && diversion<=2 && felicidad>0) begin 
        felicidad <= felicidad - 4'h1;      
     end
     if (counter_tiempo % 3750000000 == 0 && hambre<=2 && felicidad>0) begin 
        felicidad <= felicidad - 4'h2;      
     end
     if (counter_tiempo % 50000000000 == 0 && energia<=2 && felicidad>0 && sensor_pir == 1) begin 
        felicidad <= felicidad - 4'h2;      
     end
     if (counter_tiempo % 12500000000 == 0 && vida<=2 && felicidad>0 && sensor_pir == 1) begin 
        felicidad <= felicidad - 4'h2;      
     end 
	  if (sensor_ultrasonido == 0 && counter_tiempo % 100000000 == 0  && felicidad<5 && sensor_pir == 1) begin 
        felicidad <= felicidad + 4'h1;      
     end

//----------------------------------------------------------------------------------------------\\

//-----------------------------logica vida----------------------------------------------------\\

     if (counter_tiempo % 2500000000 == 0 && hambre<=2 && vida>0) begin 
        vida <= vida - 4'h1;      
     end
     if (counter_tiempo % 2500000000 == 0 && energia<=2 && vida>0) begin 
        vida <= vida - 4'h1;      
     end
     if (counter_tiempo % 2500000000 == 0 && felicidad<=2 && vida>0) begin 
        vida <= vida - 4'h1;      
     end
     if (btn_vida==1'b0 && vida<5 && hambre>0) begin 
        vida <= 5;
        hambre <= hambre - 4'h1;
     end

//-------------------------------------------------------------------------------------------------------\\

//-------------------------------------logica diversion-----------------------------------------\\

     if (sensor_vibracion == 1'b1 && diversion < 5 && sensor_pir == 1) begin 
        diversion <= 5;      
     end
     if (sensor_vibracion == 1'b1 && diversion < 5 && energia>0 && sensor_pir == 1) begin 
        energia <= energia - 1;      
     end

//----------------------------------------------------------------------------------------------------\\

//-------------------------------------logica alimentar-------------------------------------\\
	
		
     if (btn_alimentar == 1'b0 && hambre < 5 && sensor_pir == 1) begin 
        hambre <= 5;      
     end

//----------------------------------------------------------------------------------------------------\\


	  
end
end
end

//-----------------------------------------------------------------------------------------------------------------------------------\\

//------------------------------------ boton -----------------------------\\

boton_antirrebote boton_antirrebote_inst (
    .btn_in(btn_in),
    .clk(clk),
    .reset(reset),
    .out(debounced_out),
    .led(debouncer_led),
    .count_out(debouncer_count_out)
);

//------------------------------------------------------------------------\\

//---------------------------------------ultrasonido---------------------------------------------\\

wire sensor_ultrasonido;

ultrasonido ultrasonido_inst (
    .clk(clk),
    .reset(reset),
    .trigger(trigger),
    .echo(echo),
    .state(sensor_ultrasonido)
);

//-------------------------------------------------------------------------------------------------\\

//------------------------------------------------------Visualización LCD--------------------------------------------------------\\

//Divisor de frecuencia
always @(posedge clk) begin
    if (counter_div_freq == COUNT_MAX-1) begin
        clk_16ms <= ~clk_16ms;
        counter_div_freq <= 0;
    end else begin
        counter_div_freq <= counter_div_freq + 1;
    end
end

//Estado inicial
always @(posedge clk_16ms)begin
    if(reset == 0)begin
        fsm_state <= IDLE;
    end else begin
        fsm_state <= next;
    end
end

//Maquina de cambio de estados
always @(*) begin
    case(fsm_state)
        IDLE: begin
            next <= (ready_i)? ((init_config_executed)? CREATE_CHARS : INIT_CONFIG) : IDLE;
        end
        INIT_CONFIG: begin 
            next <= (command_counter == num_commands)? CLEAR_COUNTERS0 : INIT_CONFIG;
        end
        CLEAR_COUNTERS0: begin
            next <= CREATE_CHARS;
        end
        CREATE_CHARS:begin
            next <= (done_cgram_write)? CLEAR_COUNTERS1 : CREATE_CHARS;
        end
        CLEAR_COUNTERS1: begin
            next <= SET_CURSOR_AND_WRITE;
        end
        SET_CURSOR_AND_WRITE: begin 
            next <= (done_lcd_write)?  WRITE_ADDITIONAL_TEXT : SET_CURSOR_AND_WRITE;
        end
        WRITE_ADDITIONAL_TEXT: begin 
            next <= (text_write_done)? CLEAR_COUNTERS0 : WRITE_ADDITIONAL_TEXT;
        end

        default: next = IDLE;
    endcase
end


//Maquina de logica de los estados
always @(posedge clk_16ms) begin
    if (reset == 0) begin
        command_counter <= 'b0;
        data_counter <= 'b0;
		  data <= 'b0;
        char_counter <= 'b0;
        init_config_executed <= 'b0;
        cgram_addrs_counter <= 'b0;
        done_lcd_write <= 1'b0; 
        text_counter <= 0;
        text_write_done <= 0;
		  text_counter2 <=0;
	     writing_line2 <=0;


    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/feliz_cara.txt", data_memory);
	 $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/hambriento_cara.txt", data_memory2);
  	 $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/aburrido_cara.txt", data_memory3); 
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/cansado_cara.txt", data_memory4);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/enfermo_cara.txt", data_memory5);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/triste_cara.txt", data_memory6);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/dormido_cara.txt", data_memory7);
    $readmemb("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/muerto_cara.txt", data_memory8);

    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/feliz_texto.txt", text_memory); 
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/hambriento_texto.txt", text_memory2); 
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/aburrido_texto.txt", text_memory3);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/cansado_texto.txt", text_memory4);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/enfermo_texto.txt", text_memory5);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/triste_texto.txt", text_memory6);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/dormido_texto.txt", text_memory7);
    $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/muerto_texto.txt", text_memory8);
	 $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/test_mode_texto.txt", text_test_mode);
	 $readmemh("C:/Users/OSCAR/Documents/Proyecto_Digital/proyecto/racing_mode_texto.txt", text_racing_mode);

    end else begin
        case (next)
		  //Estado inicial
            IDLE: begin
                char_counter <= 'b0;
                command_counter <= 'b0;
                data_counter <= 'b0;
                rs <= 'b0;
                cgram_addrs_counter <= 'b0;
                done_lcd_write <= 1'b0;
                text_write_done <= 0;
                text_counter <= 0;
					 text_counter2 <=0;
	             writing_line2 <=0;
            end
		 
            INIT_CONFIG: begin
                rs <= 'b0;
                command_counter <= command_counter + 1;
			    data <= config_memory[command_counter];
                if(command_counter == num_commands-1) begin
                    init_config_executed <= 1'b1;
                end
            end
            CLEAR_COUNTERS0: begin
                data_counter <= 'b0;
                char_counter <= 'b0;
                create_char_task <= SET_CGRAM_ADDR;
                cgram_addrs_counter <= 'b0;
                done_lcd_write <= 1'b0;
                rs <= 'b0;
                data <= 'b0;
                text_write_done <= 0;
                text_counter <= 0;

            end
            CREATE_CHARS: begin
                case(create_char_task)
                    SET_CGRAM_ADDR: begin 
                        rs <= 'b0; data <= cgram_addrs[cgram_addrs_counter]; 
                        create_char_task <= WRITE_CHARS; 
                    end
                    WRITE_CHARS: begin
                        rs <= 1;
                    if (test_mode == 1'b0) begin
                    if (vida == 0)begin
				        data <= data_memory8[data_counter];
                   end else if (!sensor_pir)begin
                        data <= data_memory7[data_counter];
                    end else if (felicidad <= 2)begin
                        data <= data_memory6[data_counter];
                    end else if (vida <= 2)begin 
                        data <= data_memory5[data_counter];
                    end else if (hambre <= 2)begin
                        data <= data_memory2[data_counter];
                    end else if (energia <= 2)begin
                        data <= data_memory4[data_counter];
                    end else if (diversion <= 2)begin
                        data <= data_memory3[data_counter];
                    end else if (felicidad > 2)begin
                        data <= data_memory[data_counter];
                    end 
                    end 
                    
                    if (test_mode == 1'b1) begin

                    if (debouncer_count_out == 4'd1)begin
				        data <= data_memory8[data_counter];
                   end else if (debouncer_count_out == 4'd2)begin
                        data <= data_memory7[data_counter];
                    end else if (debouncer_count_out == 4'd3)begin
                        data <= data_memory6[data_counter];
                    end else if (debouncer_count_out == 4'd4)begin 
                        data <= data_memory5[data_counter];
                    end else if (debouncer_count_out == 4'd5)begin
                        data <= data_memory2[data_counter];
                    end else if (debouncer_count_out == 4'd6)begin
                        data <= data_memory4[data_counter];
                    end else if (debouncer_count_out == 4'd7)begin
                        data <= data_memory3[data_counter];
                    end else if (debouncer_count_out == 4'd8)begin
                        data <= data_memory[data_counter];
                    end 

                    end

                        data_counter <= data_counter + 1;
                        if(char_counter == char_data -1) begin
                            char_counter = 0;
                            create_char_task <= SET_CGRAM_ADDR;
                            cgram_addrs_counter <= cgram_addrs_counter + 1;
                        end else begin
                            char_counter <= char_counter +1;
                        end
                    end
                endcase
            end
            CLEAR_COUNTERS1: begin
                data_counter <= 'b0;
                char_counter <= 'b0;
                create_char_task <= SET_CURSOR;
                cgram_addrs_counter <= 'b0;
            end
            SET_CURSOR_AND_WRITE: begin
                case(create_char_task)
					SET_CURSOR: begin
                        rs <= 0; data <= (cgram_addrs_counter > 2)? 8'h80 + (cgram_addrs_counter%3) + 8'h40 : 8'h80 + (cgram_addrs_counter%3);
                        create_char_task <= WRITE_LCD; 
                    end
                    WRITE_LCD: begin
                        rs <= 1; 
                        data <=  8'h00 + cgram_addrs_counter;
                        if(cgram_addrs_counter == num_cgram_addrs-1)begin
                            cgram_addrs_counter = 'b0;
                            done_lcd_write <= 1'b1;
                        end else begin
                            cgram_addrs_counter <= cgram_addrs_counter + 1;
                        end
                        create_char_task <= SET_CURSOR; 
                    end
                endcase
            end
                    WRITE_ADDITIONAL_TEXT: begin
                        if (text_counter == 0) begin
                            rs <= 0;
                            data <= 8'h84; // Posiciona el cursor después de los caracteres especiales
                            text_counter <= text_counter + 1;
                        end else if (!writing_line2 && text_counter <= text_lenght) begin
                            rs <= 1;
                         if (test_mode == 1'b0) begin
                            if (vida == 0 ) begin 
                            data <= text_memory8[text_counter-1];
                            end else if (!sensor_pir)begin 
                            data <= text_memory7[text_counter-1];
                            end else if (felicidad <= 2)begin 
                            data <= text_memory6[text_counter-1];
                            end else if (vida <= 2)begin 
                            data <= text_memory5[text_counter-1];
                            end else if (hambre <= 2)begin 
                            data <= text_memory2[text_counter-1];
                            end else if (energia <= 2)begin 
                            data <= text_memory4[text_counter-1];
                            end else if (diversion <= 2)begin 
                            data <= text_memory3[text_counter-1];
                            end else if (felicidad > 2)begin 
                            data <= text_memory[text_counter  -1];
                            end 
                         end

                         if (test_mode == 1'b1) begin
                            if (debouncer_count_out == 4'd1 ) begin 
                            data <= text_memory8[text_counter-1];
                            end else if (debouncer_count_out == 4'd2)begin 
                            data <= text_memory7[text_counter-1];
                            end else if (debouncer_count_out == 4'd3)begin 
                            data <= text_memory6[text_counter-1];
                            end else if (debouncer_count_out == 4'd4)begin 
                            data <= text_memory5[text_counter-1];
                            end else if (debouncer_count_out == 4'd5)begin 
                            data <= text_memory2[text_counter-1];
                            end else if (debouncer_count_out == 4'd6)begin 
                            data <= text_memory4[text_counter-1];
                            end else if (debouncer_count_out == 4'd7)begin 
                            data <= text_memory3[text_counter-1];
                            end else if (debouncer_count_out == 4'd8)begin 
                            data <= text_memory[text_counter  -1];
                            end 
                         end

                            text_counter <= text_counter + 1;
									 if (text_counter == text_lenght) begin
                               writing_line2 <= 1;
                               text_counter2 <=0;
									 end
									 
						 end else if (writing_line2 && text_counter2 == 0) begin
                    rs <= 0;
                    data <= 8'hC4; // Posicionar cursor al inicio de la segunda línea
                    text_counter2 <= text_counter2 + 1;
                end else if (writing_line2 && text_counter2 <= text_lenght2) begin
                    rs <= 1;
                    if (test_mode) begin
                        data <= text_test_mode[text_counter2-1];
						  end else if (racing_mode) begin
						      data <= text_racing_mode[text_counter2-1];
                    end else begin 
						      data <= 8'h20;
						  end
                    text_counter2 <= text_counter2 + 1;
						  
                       end else begin
                            text_write_done <= 1'b1;
                            text_counter <= 0;
									 text_counter2 <= 0;
                            writing_line2 <= 0;
                        end
                    end

                endcase
            end
        end

//----------------------------------------------------------------------------------------------------------------------------\\

assign enable = clk_16ms;
assign done_cgram_write = (data_counter == num_data_all-1)? 'b1 : 'b0;



endmodule
