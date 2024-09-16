module ultrasonido(
    input clk,
    output trigger,
    input echo,
    input reset,
    output state
);

//--------------------------------Registros-------------------------------------------\\
 reg [25:0] count;
 reg n_trigger;
 reg old_echo;
 reg [32:0] count_out;
 reg [32:0] echo_count;
 reg [32:0] status;
//------------------------------------------------------------------------------------\\

 initial begin
    count = 25'b0;
    n_trigger = 1'b0;
    old_echo = 1'b0;
    count_out = 33'b0;
    echo_count = 33'b0;
    status = 33'b0;

 end

//--------------------------------------------------Logica del ultrasonido-------------------------------------\\
 always @(posedge clk) begin
    if(!reset)begin 
      count_out <= 0;
      count <=0;
      echo_count <= 0;
      old_echo <= 0;
      n_trigger <=0;
      end else begin
      count = count + 1;
     //reduccion AND negado, Generació del tigger, activa el tigger durante cierto tiempo
      n_trigger = ~&(count[24:10]);
  // Comprobación del tiempo de disparo  
    if (~&(count[24:11])) begin
        if (n_trigger) begin
            if (echo == 1) begin
                echo_count = echo_count + 1;
            end
	// Reinicio del contador si se detecta un cambio en el registro echo
            if ((old_echo == 1) && (echo == 0)) begin
                count_out = echo_count;
                echo_count = 0;
            end
        end
    end
    // actualizació del registro estados 
    if (count_out > 33'd15000) begin
	//desplaza el estado a la izquierda
        status = status << 1;
        status[0] = 1;
    end else begin
        status = status << 1;
        status[0] = 0;
        
    end
   // Se guarda un valor de echo para comparar en el siguiente ciclo 
    old_echo = echo;
 end
 end
//---------------------------------------------------------------------------------------------------------------------\\

// asignacion de registros
 assign trigger = n_trigger;
 assign state = |status;


 endmodule
