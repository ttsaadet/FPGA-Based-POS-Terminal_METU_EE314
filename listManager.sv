module listManager(
input wire clk,
input wire [15:0] H_counter,
input wire [15:0] V_counter,
input wire [3:0] soldItemCount,
input wire [2:0] barcode[0:4],
input reg [2:0] quantitylist[0:11],  //tüm meyvelerin kaç tane alındığının listesi
input wire [3:0] shopping_list [0:11],	//shopping listi oluşturmak için kronolojik alım listesi
output reg enable,
output reg [7:0] pixelValue );


parameter tableWidth = 244;
parameter tableX1 = 26 ;
parameter tableX2 = 270;
parameter tableY1 = 150;
parameter tableY2 = 414 ; //pixel where plus sign start	
parameter tableTitleY1 = 127; 
parameter tableTitleY2 = 149;

parameter rowHeight = 22;
parameter numberHeight = 22;
parameter numberWidth = 23;
parameter numberX2 = 256; //numaraların endX pixeli

parameter  priceX1 = 141;
parameter  priceY1 = 437;

parameter barcodeAreaX1 = numberX2 - 6*numberWidth;
parameter barcodeAreaY1 = 90;
parameter barcodeAreaY2 = barcodeAreaY1 + numberHeight;


reg [15:0] tableRowPosY;
reg [15:0] digitStartPosX;
reg [31:0] romAddressItemList;
reg [31:0] romAddressNumber;
reg [3:0] romValue_number;
reg [3:0] romValueItemList;
tableRomPort m1(romAddressItemList, clk, romValueItemList);
numbersRomPort m2(romAddressNumber, clk, romValue_number);

reg [3:0] gridRow = 0; 
reg [3:0] gridCollumn = 0; 
gridCounter GC_Q1(clk,H_counter, V_counter, gridRow,gridCollumn);
reg calc_complete;
reg [3:0] price_disp[0:4];
priceHandler PH_Q2(clk, quantitylist,calc_complete,price_disp );

always @(posedge clk)begin
	 if(H_counter >= tableX1 && H_counter < tableX2 && V_counter >= tableTitleY1  && V_counter <  tableTitleY2)begin // put table titles
		 	enable <=1; //module active
			romAddressItemList <= (V_counter -tableTitleY1)*tableWidth + H_counter- tableX1;
			pixelValue <= (romValueItemList << 4);
	end
	else if(H_counter >= tableX1 && H_counter < tableX2 && V_counter >= tableY1 && V_counter < tableY2)begin// meyve isimlerini geleceği alan
		enable <= 1;//tableY=149 
		if(soldItemCount > 0)begin
			tableRowPosY <= gridRow*rowHeight + tableY1; //tableRowPosY: rowun başladığı vetical pixel
			if(H_counter < (numberX2-numberWidth) && V_counter >= tableRowPosY && V_counter < tableRowPosY + rowHeight)begin
				//put item name here //shopping_list: satım sırasına göre idlerin tutulduğu array
				if(shopping_list[gridRow] == 15) //15:blank item, not sold yet
				pixelValue <= 8'hf0;
				else begin
				romAddressItemList <= (shopping_list[gridRow]+1)*tableWidth*rowHeight + (V_counter-tableRowPosY)*tableWidth + H_counter- tableX1 ;		
				pixelValue <= (romValueItemList << 4);
				end			
			end//quantity
			else if (H_counter >= numberX2 -numberWidth &&  H_counter <  numberX2 && V_counter >= tableRowPosY && V_counter < tableRowPosY + rowHeight)begin //put quantity here
				romAddressNumber <= quantitylist[shopping_list[gridRow]]*numberWidth*numberHeight + (V_counter - tableRowPosY)*numberWidth + H_counter -(numberX2 -numberWidth); 
				pixelValue <= romValue_number<<4;
			end
			else 
				pixelValue <= 8'hf0;
		end
		else pixelValue <= 8'hf0;
	end
	else if(H_counter >= tableX1 && H_counter < tableX2 && V_counter >= tableY2  && V_counter < priceY1 )begin // put plus sign
		enable <=1;		//14: plus sign location in png
		romAddressItemList <= 14*tableWidth*rowHeight +  (V_counter-tableY2)*tableWidth + H_counter-(tableX1) ; //5130: 270*19 total pixel count at each row of table	
		pixelValue <= romValueItemList <<4 ;		
	end
	else if (H_counter >= priceX1 && H_counter < numberX2 && V_counter >= priceY1 && V_counter < priceY1 + numberHeight)begin//put price here
		enable <= 1;
		digitStartPosX <= gridCollumn*numberWidth+26;
		if(gridCollumn >=5)begin
			romAddressNumber <= price_disp[gridCollumn-5]*numberWidth*numberHeight + (V_counter-priceY1)*numberWidth + H_counter-digitStartPosX;
			pixelValue <= romValue_number << 4;
		end
		else pixelValue <= 8'hf0; 
	end
	else if(H_counter >= barcodeAreaX1 && H_counter <numberX2 && V_counter >= barcodeAreaY1 && V_counter < barcodeAreaY2 )begin//girilen barkodu ekranda gösterecek alan
		enable <=1;	
		if(gridCollumn >= 4 && gridCollumn < 8)begin //5-8: barcode girişi,9: quantity,10: quantity 
			romAddressNumber <= barcode[gridCollumn - 4]*numberWidth * numberHeight + (V_counter - barcodeAreaY1)*numberWidth + H_counter - (gridCollumn*numberWidth + 26);
			pixelValue <= romValue_number << 4;
		end
		else if(gridCollumn == 9)begin
			romAddressNumber <= barcode[gridCollumn - 5]*numberWidth * numberHeight + (V_counter - barcodeAreaY1)*numberWidth + H_counter - (gridCollumn*numberWidth + 26);
			pixelValue <= romValue_number <<4;
		end
		else begin
			pixelValue <= 8'hf0;
		end
	end 
	else begin
		enable <= 0;
	end
end
endmodule

module gridCounter(
input wire clk,
input wire [15:0] H_counter,
input wire [15:0] V_counter,
output reg [3:0] gridRow,
output reg [3:0] gridCollumn);

parameter tableX1 = 26 ;
parameter tableX2 = 270;
parameter tableY1 = 150;
parameter tableY2 = 414 ; //pixel where plus sign start	
parameter rowHeight = 22;
parameter numberHeight = 22;
parameter numberWidth = 23;
initial begin
gridRow <= 0;
gridCollumn <=0;	 
end
always @(posedge clk) begin
	if(V_counter >= tableY1 && V_counter < tableY2)begin
		if(V_counter - tableY1 - rowHeight*gridRow >=  rowHeight)begin
			gridRow = gridRow + 1;
		end
	end
	else
		gridRow = 0;
	if(H_counter >= tableX1 && H_counter < tableX2)begin
		if(H_counter - tableX1 - numberWidth*gridCollumn >= numberWidth)begin
			gridCollumn = gridCollumn + 1;
		end
	end
	else gridCollumn = 0;
end
endmodule