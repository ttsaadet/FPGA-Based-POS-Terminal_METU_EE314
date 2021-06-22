`timescale 1 ns / 1 ps
module buttonManager_tb();
reg clk;
reg [3:0] buttons;
reg [2:0] switches;
reg [2:0] barcode[4:0];	// first 4 digit barcode + last 1 digit quantity
reg sold_flag;
reg [8:0] highligthPosX[11:0];
reg [8:0] highligthPosY[11:0];


buttonManager m1(clk,buttons,switches,barcode,sold_flag,highligthPosX,highligthPosY);
initial begin
switches = 3'b000;
buttons = 4'b0000;
clk =0;
end

always begin
	clk <= 0; #10 ;  clk <= 1; #10 ;
end


always begin
	switches = 3'b000;
	buttons = 4'b0000; #35;
	buttons = 4'b0100; #20;
	buttons = 4'b0000; #35;
	buttons = 4'b0001; #20;
	buttons = 4'b0000; #40;
	buttons = 4'b0010; #20;
	buttons = 4'b0000; #40;
	buttons = 4'b1000; #20;
	buttons = 4'b0000; #40;
	buttons = 4'b0100; #20;
	buttons = 4'b0000; #40;
	buttons = 4'b0011; #20;
	
	switches = 3'b100;
	buttons = 4'b0000; #35;
	buttons = 4'b0100; #20;
	buttons = 4'b0000; #35;
	buttons = 4'b0001; #20;
	buttons = 4'b0000; #40;
	buttons = 4'b0010; #20;
	buttons = 4'b0000; #40;
	buttons = 4'b1000; #20;
	buttons = 4'b0000; #40;
	buttons = 4'b0100; #20;
	buttons = 4'b0000; #40;
	buttons = 4'b0011; #20;
end
endmodule