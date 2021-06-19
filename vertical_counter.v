`timescale 1ns / 1ps
module vertical_counter(clk_25mhz, v_counter_trigger, v_counter);

input clk_25mhz;
input v_counter_trigger;
output reg [15:0] v_counter = 0;

always @(posedge clk_25mhz)
  begin
	if(v_counter_trigger == 1'b1) begin
		 if(v_counter < 524)
			  v_counter <= v_counter + 1;
		 else
			v_counter = 0;
	end
end

endmodule