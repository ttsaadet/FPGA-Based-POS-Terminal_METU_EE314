`timescale 1ns / 1ps

module horizontal_counter(clk_25mhz, v_counter_trigger, h_counter);

input clk_25mhz;
output reg v_counter_trigger;
output reg [15:0] h_counter = 0;

always @(posedge clk_25mhz)
begin
	if(h_counter  < 799) 
		begin
			h_counter <= h_counter + 1;
			v_counter_trigger <= 0;
		end
	else 
		begin
			h_counter <= 0;
			v_counter_trigger <= 1;
		end
end
endmodule
