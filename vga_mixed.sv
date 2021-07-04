`timescale 1ns / 1ps
module vga_mixed(
input clk, 
input [3:0] buttons,
input [3:0] switches,
output HSync,
output VSync, 
output reg [7:0] Red, 
output reg [7:0] Green,
output reg [7:0]  Blue, 
output reg clk_25mhz, 
output SYNC_BLANK_N);

parameter logoX1 = 103 - 1; 
parameter logoX2 = 173 - 1;
parameter logoY1 = 5 - 1;
parameter logoY2 = 75 - 1;
parameter menuX1 = 270 - 1;
parameter tableWidth = 270;
parameter tableTitleStartY = 80-1; //start from 80th pixel
parameter tableTitleEndPosY = 99 -1;
parameter rowHeight = 19;
parameter numberHeight = 18;
parameter numberWidth = 19;
parameter tableEndY = 270 ; //pixel where total price start

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

reg sold_flag;
reg [9:0] highligthPosX[0:11];
reg [9:0] highligthPosY[0:11];
reg [2:0] quantitylist[0:11];
wire [3:0] highlightedRow;
wire [3:0] shopping_list [0:11];
wire [3:0] soldItemCount;
wire [2:0] barcode[4:0];
buttonManager buttonsModule(clk_25mhz, buttons, switches,soldItemCount,
	highlightedRow,barcode,quantitylist,shopping_list, highligthPosX,highligthPosY);

reg list_manager_active;
reg [7:0] pixelValue_list;

listManager listModule(clk_25mhz,H_counter,V_counter,soldItemCount,barcode,quantitylist, shopping_list,
 list_manager_active,pixelValue_list);
reg [2:0] fruitIndex = 0;


reg [18:0] romAddress_menu;
reg [12:0] romAddress_logo;
wire [3:0] R_romValue_menu;
wire [3:0] G_romValue_menu;
wire [3:0] B_romValue_menu;
wire [3:0 ] R_romValue_logo;
wire [3:0 ] G_romValue_logo;
wire [3:0 ] B_romValue_logo;

wire [3:0] romValueItemList;
reg[18:0] romAddressItemList;

reg [7:0] pixelValue_number;
reg priceHandler_enable = 0;
/*
menu_redRom port1(romAddress_menu, clk_25mhz, R_romValue_menu); 
menu_greenRom port2(romAddress_menu, clk_25mhz, G_romValue_menu);
menu_blueRom port3(romAddress_menu, clk_25mhz, B_romValue_menu);

logo_redRom port4(romAddress_logo, clk_25mhz, R_romValue_logo);
logo_greenRom port5(romAddress_logo, clk_25mhz, G_romValue_logo);
logo_blueRom port6(romAddress_logo, clk_25mhz, B_romValue_logo);
*/

always @(posedge clk_25mhz) begin
	if(H_counter < 640 &&  V_counter < 480)begin// vga active area
		if(H_counter > logoX1 && H_counter < logoX2 //menu active area
		 && V_counter > logoY1 && V_counter < logoY2) begin
			romAddress_logo <= (V_counter - (logoY1 + 1))*70 +(H_counter - logoX1 + 1);
			Red <= (R_romValue_logo << 4);
			Green <= (G_romValue_logo << 4);
			Blue <= (B_romValue_logo << 4);
		end
		else if(H_counter > menuX1)begin //269: h_pixel number where menu starts
			romAddress_menu <= (V_counter)*370+(H_counter-270);
			
			if(H_counter > 280 && H_counter < 390 && V_counter > 5 && V_counter < 125)
				fruitIndex <= 0;
			else if (H_counter > 400 && H_counter < 520 && V_counter > 5 && V_counter < 125)
				fruitIndex <= 1;
			else if (H_counter > 520 && H_counter < 640 && V_counter > 5 && V_counter < 125)
				fruitIndex <= 2;
			else if(H_counter > 280 && H_counter < 390 && V_counter > 125 && V_counter < 245)
				fruitIndex <= 3;
			else if (H_counter > 400 && H_counter < 520 && V_counter > 125 && V_counter < 245)
				fruitIndex <= 4;
			else if (H_counter > 520 && H_counter < 640 && V_counter > 125 && V_counter < 245)
				fruitIndex <= 5;
			if(H_counter > 280 && H_counter < 390 && V_counter > 245 && V_counter < 365)
				fruitIndex <= 6;
			else if (H_counter > 400 && H_counter < 520 && V_counter > 245 && V_counter < 365)
				fruitIndex <= 7;
			else if (H_counter > 520 && H_counter < 640 && V_counter > 245 && V_counter < 365)
				fruitIndex <= 8;
			if(H_counter > 280 && H_counter < 390 && V_counter > 365 && V_counter < 480)
				fruitIndex <= 9;
			else if (H_counter > 400 && H_counter < 520 && V_counter > 365 && V_counter < 480)
				fruitIndex <= 10;
			else if (H_counter > 520 && H_counter < 640 && V_counter > 365 && V_counter < 480)
				fruitIndex <= 11;		
				
			if(H_counter > highligthPosX[fruitIndex] && H_counter < (highligthPosX[fruitIndex] + 20)  //highlighted area
				&& V_counter > highligthPosY[fruitIndex] && V_counter < highligthPosY[fruitIndex] +20)begin
				Red <= 0;
				Green <= 0;
				Blue <= 8'hff;
			end
			else begin	 							// out of highlighted area, put rom values
				Red <= (R_romValue_menu << 4) ;
				Green <= (G_romValue_menu << 4);
				Blue <= (B_romValue_menu << 4);
			end
		end
		else if(list_manager_active == 1 )begin //put fruit lists and qty.
			Red <= pixelValue_list;
			Green <= pixelValue_list;
			Blue <= pixelValue_list;
		end
		else if(H_counter >= 3 && H_counter < 18 && V_counter >= highlightedRow*22+151 && 
		V_counter < highlightedRow*22+166 && switches[1] == 1)begin //highlight list item while navigating in list
			Red <= 8'h00;
			Green <= 8'h00;
			Blue <= 8'hff;
		end
		else begin //out of menu area and list area
			Red <= 8'hff;
			Green <= 8'hff;
			Blue <= 8'hff;			
		end	
	end
	else begin // out of active vga area
		Red <= 8'h00 ;
		Green <= 8'h00;
		Blue <= 8'h00;
	end
end
endmodule