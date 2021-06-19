`timescale 1ns / 1ps
module vga(clk, HSync, VSync, Red, Green, Blue);

input clk;
output HSync;
output VSync;
output [3:0] Red;
output [3:0] Green;
output [3:0] Blue;

reg clk_25mhz;
wire v_counter_trigger;
wire [15:0] H_counter;
wire [15:0] V_counter;

always @(posedge clk)begin     
  clk_25mhz <= ~clk_25mhz;
end

horizontal_counter h_vga(clk_25mhz, v_counter_trigger, h_counter);
horizontal_counter v_vga(clk_25mhz, v_counter_trigger, v_counter);

assign HSync = (H_counter < 96) ? 1'b1:1'b0;
assign VSync = (V_counter < 2) ? 1'b1:1'b0;

assign Red = (H_counter < 784 && H_counter > 143 && V_counter < 515 &&  V_counter > 34) ? 4'hF:4'h0;
assign Green = (H_counter < 784 && H_counter > 143 && V_counter < 515 &&  V_counter > 34) ? 4'hF:4'h0;
assign Blue = (H_counter < 784 && H_counter > 143 && V_counter < 515 &&  V_counter > 34) ? 4'hF:4'h0;

endmodule
