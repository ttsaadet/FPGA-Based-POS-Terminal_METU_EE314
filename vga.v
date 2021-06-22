`timescale 1ns / 1ps
module vga(clk, HSync, VSync, Red, Green, Blue);

input clk;
output HSync;
output VSync;
output [7:0] Red;
output [7:0] Green;
output [7:0] Blue;

reg clk_25mhz = 0;
wire v_counter_trigger;
wire [15:0] H_counter;
wire [15:0] V_counter;

always @(posedge clk)begin     
  clk_25mhz <= ~clk_25mhz;
end

horizontal_counter h_vga(clk_25mhz, v_counter_trigger, H_counter);
vertical_counter v_vga(clk_25mhz, v_counter_trigger, V_counter);

assign HSync = (H_counter < 96) ? 1'b1:1'b0;
assign VSync = (V_counter < 2) ? 1'b1:1'b0;

assign Red = (H_counter < 784 && H_counter > 143 && V_counter < 515 &&  V_counter > 34) ? 8'hF_F:8'h00;
assign Green = (H_counter < 784 && H_counter > 143 && V_counter < 515 &&  V_counter > 34) ? 8'hF_F:8'h00;
assign Blue = (H_counter < 784 && H_counter > 143 && V_counter < 515 &&  V_counter > 34) ? 8'hF_F:8'h00;

endmodule