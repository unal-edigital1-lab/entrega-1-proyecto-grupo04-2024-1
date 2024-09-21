`timescale 1ns / 1ps
module ultrasonic_controller (
    input clk,
    output trigger,
    input echo,
	 input reset,
    output state
	 

);

reg [25:0] count;
reg n_trigger;
reg old_echo;
reg [32:0] count_out;
reg [32:0] echo_count;
reg [32:0] status;


initial begin
    count = 25'b0;
    n_trigger = 1'b0;
    old_echo = 1'b0;
    count_out = 33'b0;
    echo_count = 33'b0;
    status = 33'b0;

end

always @(posedge clk) begin
    if(!reset)begin 
      count_out <= 0;
      count <=0;
      echo_count <= 0;
      old_echo <= 0;
      n_trigger <=0;
    end else begin
    count = count + 1;
    n_trigger = ~&(count[24:10]);
    
    if (~&(count[24:11])) begin
        if (n_trigger) begin
            if (echo == 1) begin
                echo_count = echo_count + 1;
            end
            if ((old_echo == 1) && (echo == 0)) begin
                count_out = echo_count;
                echo_count = 0;
            end
        end
    end
    
    if (count_out > 33'd15000) begin
        status = status << 1;
        status[0] = 1;
    end else begin
        status = status << 1;
        status[0] = 0;
        
    end
    
    old_echo = echo;
end
end
assign trigger = n_trigger;
assign state = |status;


endmodule