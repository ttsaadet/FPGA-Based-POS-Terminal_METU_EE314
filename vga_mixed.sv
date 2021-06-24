`timescale 1ns / 1ps
module vga_mixed(
input clk, 
input [3:0] buttons,
input [2:0] switches,
output HSync,
output VSync, 
output reg [7:0] Red, 
output reg [7:0] Green,
output reg [7:0]  Blue, 
output reg clk_25mhz, 
output SYNC_BLANK_N);

parameter logoStartPosX = 103 - 1; 
parameter logoEndPosX = 173 - 1;
parameter logoStartPosY = 5 - 1;
parameter logoEndPosY = 75 - 1;
parameter menuStartPosX = 270 - 1;

assign SYNC_BLANK_N = 1;
initial begin
clk_25mhz =0;
end 
wire v_counter_trigger;
wire [15:0] H_counter;
wire [15:0] V_counter;


always @(posedge clk)begin     
  clk_25mhz <= ~clk_25mhz;
end

horizontal_counter h_vga(clk_25mhz, v_counter_trigger, H_counter);
vertical_counter v_vga(clk_25mhz, v_counter_trigger, V_counter);
assign HSync = (H_counter > (640 + 15) && (H_counter < (640 + 16 + 95)));
assign VSync = (V_counter > (480 + 9) && (V_counter < (480 + 10 + 1))); 

reg [2:0] barcode[4:0];
reg sold_flag;
reg [9:0] highligthPosX[0:11] = '{280,400,520,280,400,520,280,400,520,280,400,520};
reg [9:0] highligthPosY[0:11] = '{5,5,5,125,125,125,245,245,245,365,365,365};
/*buttonManager buttonsModuke(clk_25mhz,buttons, switches,barcode,sold_flag,
	highligthPosX,highligthPosY);
*/

reg [2:0] menu_column = 0;
reg [2:0] menu_row = 0;
reg [2:0] fruitIndex = 0;
reg [6:0] pixelCounterX = 0;
reg [15:0] pixelCounterY = 0;

reg [18:0] menuRomAdress;
reg [12:0] logoRomAdress;
wire [3:0] R_romValue_menu;
wire [3:0] G_romValue_menu;
wire [3:0] B_romValue_menu;
wire [3:0 ] R_romValue_logo;
wire [3:0 ] G_romValue_logo;
wire [3:0 ] B_romValue_logo;

/*
menu_redRom port1(menuRomAdress, clk_25mhz, R_romValue_menu); 
menu_greenRom port2(menuRomAdress, clk_25mhz, G_romValue_menu);
menu_blueRom port3(menuRomAdress, clk_25mhz, B_romValue_menu);

logo_redRom port4(logoRomAdress, clk_25mhz, R_romValue_logo);
logo_greenRom port5(logoRomAdress, clk_25mhz, G_romValue_logo);
logo_blueRom port6(logoRomAdress, clk_25mhz, B_romValue_logo);
*/
always @(posedge clk_25mhz) begin
	if(H_counter < 640 &&  V_counter < 480)begin// vga active area
		if(H_counter > logoStartPosX && H_counter < logoEndPosX //menu active area
		 && V_counter > logoStartPosY && V_counter < logoEndPosY) begin
			logoRomAdress <= (V_counter - logoStartPosY + 1)*70 +(H_counter - logoStartPosX + 1);
			Red <= (R_romValue_logo << 4);
			Green <= (G_romValue_logo << 4);
			Blue <= (B_romValue_logo << 4);
		end
		else if(H_counter > menuStartPosX)begin //269: h_pixel number where menu starts
			if(H_counter == menuStartPosX + 1) menu_column <= 0;
			menuRomAdress <= (V_counter)*370+(H_counter-270);
			/*if(pixelCounterX < 120)
				pixelCounterX <= pixelCounterX +1; 
			else begin 
				pixelCounterX <= 0;
				menu_column <= menu_column + 1;
			end
			if(pixelCounterY < 44400) //44400 pixel: one row area
				pixelCounterY <= pixelCounterY +1;
			else begin
				pixelCounterY <= 0;
				menu_row <= menu_row + 1;
			end
			if(menu_row == 4) menu_row <=0;
			fruitIndex <= menu_row*3 + menu_column;
			*/
			if(H_counter > 280 && H_counter < 390 && V_counter > 5 && V_counter < 125)
				fruitIndex <= 0;
			else if (H_counter > 400 && H_counter < 520 && V_counter > 5 && V_counter < 125)
				fruitIndex <= 1;
			else if (H_counter > 520 && H_counter < 640 && V_counter > 5 && V_counter < 125)
				fruitIndex <= 2;
			/************** else if lerin devamı tüm meyve çerçeveleri için *////////
				
			if(H_counter > highligthPosX[fruitIndex] && H_counter < (highligthPosX[fruitIndex] + 20) 
				&& V_counter > highligthPosY[fruitIndex] && V_counter < highligthPosY[fruitIndex] +20)begin
				Red <= 0;
				Green <= 0;
				Blue <= 8'hff;
			end
			else begin	 // out of highlighted area, put rom values
				Red <= (R_romValue_menu << 4) ;
				Green <= (G_romValue_menu << 4);
				Blue <= (B_romValue_menu << 4);
			end
		end
		else begin //out of menu area
			Red <= 8'hff;
			Green <= 8'hff;
			Blue <= 8'hff;
		end	
	end
	else begin
		Red <= 8'h00 ;
		Green <= 8'h00;
		Blue <= 8'h00;
	end
end

endmodule
/*
if(H_counter > 280 && H_counter < 390 && V_counter > 5 && V_counter < 125)
	fruitIndex <= 0;
else if (H_counter > 400 && H_counter < 520 && V_counter > 5 && V_counter < 125)
	fruitIndex <= 1;
else if (H_counter > 520 && H_counter < 640 && V_counter > 5 && V_counter < 125)
	fruitIndex <= 2;

	
if(H_counter > 280 && H_counter < 390 && V_counter > 125 && V_counter < 245)
	fruitIndex <= 6;
else if (H_counter > 400 && H_counter < 520 && V_counter > 125 && V_counter < 245)
	fruitIndex <= 7;
else if (H_counter > 520 && H_counter < 640 && V_counter > 125 && V_counter < 245)
	fruitIndex <= 8;
*/