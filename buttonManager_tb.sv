`timescale 1 ns / 1 ps
module buttonManager_tb();
reg clk;
reg[3:0] buttons;
reg [3:0] switches;
reg [3:0] soldItemCount;            //kaç çeşit item satıldığının sayısı
reg [3:0] rowIndex;


reg [3:0] shopping_list[0:11]; //shopping listi oluşturmak için kronolojik alım listesi
reg [9:0] highligthPosX[0:11];
reg [9:0] highligthPosY[0:11];

reg [2:0] quantitylist[0:11];  //tüm meyvelerin kaç tane alındığının listesi


reg calc_complete;
reg [3:0] price_disp[0:3];
buttonManager buttonsModule(clk, buttons, switches,soldItemCount,
	rowIndex,quantitylist,shopping_list, highligthPosX,highligthPosY);
initial begin
switches = 3'b000;
buttons = 4'b0000;
clk =0;
end

always begin
	clk <= 0; #10 ;  clk <= 1; #10 ;
end


always begin
	switches = 4'b0000; //buy using barcode
	buttons = 4'b0000; #40_000;
	buttons = 4'b0100; #40_000;
	buttons = 4'b0000; #40_000;
	buttons = 4'b0001; #40_000;
	buttons = 4'b0000; #40_000;
	buttons = 4'b0010; #40_000;
	buttons = 4'b0000; #40_000;
	buttons = 4'b1000; #40_000;
	buttons = 4'b0000; #40_000;
	buttons = 4'b0100; #40_000;
	buttons = 4'b0000; #100_000;
	buttons = 4'b0011; #300_000;
	
	switches = 4'b0100; //buy using navigating
	buttons = 4'b0000; #40_000;
	buttons = 4'b1000; #40_000; 
	buttons = 4'b0000; #40_000;
	buttons = 4'b1000; #40_000;
	buttons = 4'b0000; #40_000;
	buttons = 4'b0001; #40_000;
	buttons = 4'b0000; #40_000;
	switches = 4'b1100; #10_000;
	buttons = 4'b0001; #60_000;
	buttons = 4'b0000; #50_000;
	switches = 4'b0100; #100_0000;
	
	switches = 4'b0010; #40_000; //navigate in list and delete first item
	buttons = 4'b0011;  #50_000;
	
end
endmodule