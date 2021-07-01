module listManager(
input wire clk,
input wire [15:0] H_counter,
input wire [15:0] V_counter,
input wire [3:0] soldItemCount,
input reg [2:0] quantitylist[0:11],  //tüm meyvelerin kaç tane alındığının listesi
input wire [3:0] shopping_list [0:11],	//shopping listi oluşturmak için kronolojik alım listesi
input reg  [3:0] price_disp[0:3], //decomposed total price 
output reg enable,
output reg [7:0] pixelValue );

// TODO: QUANTITY LIST REQUIRED L:39

parameter tableWidth = 244;
parameter tableX1 = 26 ;
parameter tableX2 = 270;
parameter tableY1 = 150;
parameter tableY2 = 414 ; //pixel where plus sign start	
parameter tableTitleY1 = 137; 
parameter tableTitleY2 = 149;

parameter rowHeight = 22;
parameter numberHeight = 22;
parameter numberWidth = 23;

parameter  priceX1 = tableX2 - numberWidth*5;
parameter  priceY1 = tableY2 + rowHeight;

reg [15:0] tableRowPosY;
reg [31:0] romAddressItemList;
reg [31:0] romAddressNumber;
reg [3:0] romValue_number;
reg [3:0] romValueItemList;
/*tableRomPort m1(romAddressItemList, clk, romValueItemList);
numbersRomPort m2(romAddressNumber, clk, romValue_number);
*/
reg [3:0] rowArea_index = 0; 
rowCounter m3(H_counter, V_counter, rowArea_index);

always @(posedge clk)begin
	 if(H_counter >= tableX1 && H_counter < tableX2 && V_counter >= tableTitleY1  && V_counter <  tableTitleY2)begin // put table titles
		 	enable <=1; //module active
			romAddressItemList <= V_counter - (tableTitleY1)*tableWidth + H_counter- tableX1;
			pixelValue <= (romValueItemList << 4);
	end
	else if(H_counter >= tableX1 && H_counter < tableX2 && V_counter >= tableY1 && V_counter < tableY2)begin// meyve isimlerini geleceği alan
		enable <= 1;//tableY=149 
		if(soldItemCount > 0)begin
			tableRowPosY <= rowArea_index*rowHeight + tableY1; //tableRowPosY: rowun başladığı vetical pixel
			if(H_counter < tableX2 - 40 && V_counter >= tableRowPosY && V_counter < tableRowPosY + rowHeight)begin
				//-40= quantity yazılacak alan //put item name here //soldItemList: satım sırasına göre idlerin tutulduğu array
				if(shopping_list[rowArea_index] == 15)
				pixelValue <= 8'hff;
				else begin
				romAddressItemList <= shopping_list[rowArea_index]*tableWidth*rowHeight + (V_counter-tableRowPosY)*tableWidth + H_counter- tableX1 ; //5130: 244*22 total pixel count at each row of table			
				pixelValue <= (romValueItemList << 4);
				end			
			end
			else if (H_counter >= tableX2 -40 &&  H_counter < tableX2 - 17 && V_counter >= tableRowPosY && V_counter < tableRowPosY + rowHeight)begin //put quantity here
				romAddressNumber <= quantitylist[shopping_list[rowArea_index]]*numberWidth*numberHeight + (V_counter - tableRowPosY)*numberWidth + H_counter -(tableX2 - 40); 
				pixelValue <= romValue_number<<4;
			end
			else 
				pixelValue <= 8'hff;
		end
		else pixelValue <= 8'hff;
	end
	else if(H_counter >= tableX1 && H_counter < tableX2 && V_counter >= tableY2  && V_counter < tableY2 +rowHeight )begin // put plus sign
		enable <=1;		//14: plus sign location in png
		romAddressItemList <= 14*tableWidth*rowHeight +  (V_counter-tableY2)*tableWidth + H_counter-(tableX1) ; //5130: 270*19 total pixel count at each row of table	
		pixelValue <= romValueItemList <<4 ;		
	end
	else if (H_counter >= priceX1 && H_counter < tableX2 && V_counter >= priceY1 && V_counter < priceY1 + numberHeight)begin//put price here
		enable <= 1;//*********TODO: DRAW DOT 
		if(H_counter >= priceX1 && H_counter < priceX1 + numberWidth)begin
			romAddressItemList <= price_disp[0]*numberWidth*numberHeight + (V_counter-priceY1)*numberWidth + H_counter-priceX1;
			pixelValue <= romValue_number << 4; 
		end
		else if(H_counter >= priceX1 + numberWidth && H_counter < priceX1 + 2*numberWidth)begin
			romAddressItemList <= price_disp[1]*numberWidth*numberHeight + (V_counter-priceY1)*numberWidth + H_counter-(priceX1 + numberWidth);
			pixelValue <= romValue_number << 4;
		end
		else if(H_counter >= priceX1 + 2*numberWidth && H_counter < priceX1 + 3*numberWidth)begin
			romAddressItemList <= price_disp[2]*numberWidth*numberHeight + (V_counter-priceY1)*numberWidth + H_counter-(priceX1 + numberWidth);
			pixelValue <= romValue_number << 4;
		end
		else if(H_counter >= priceX1 + 3*numberWidth && H_counter < priceX1 + 4*numberWidth)begin
			romAddressItemList <= price_disp[3]*numberWidth*numberHeight + (V_counter-priceY1)*numberWidth + H_counter-(priceX1 + numberWidth);
			pixelValue <= romValue_number << 4;
		end
	end
	else begin
		enable <= 0;
	end
end


endmodule

module rowCounter(
input wire clk,
input wire [15:0] H_counter,
input wire [15:0] V_counter,
output reg [3:0] rowArea_index);

parameter tableX1 = 26 ;
parameter tableX2 = 270;
parameter tableY1 = 150;
parameter tableY2 = 414 ; //pixel where plus sign start	
parameter rowHeight = 22;
parameter numberHeight = 22;
parameter numberWidth = 23;
reg [15:0] V_ref = 0;


always @(posedge clk) begin
	if(V_counter >= tableY1 && V_counter < tableY2)begin
		if(V_counter - tableY1 - V_ref >=  rowHeight)begin
			V_ref <= V_counter;
			rowArea_index <= rowArea_index + 1;
		end
		else begin
			rowArea_index <= 0;
			V_ref <= 0;
		end
	end
end
endmodule