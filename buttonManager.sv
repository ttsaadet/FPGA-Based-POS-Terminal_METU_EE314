`timescale 1 ns / 1 ps
module buttonManager(
	input wire clk,
	input wire [3:0] buttons,
	input wire [2:0] switches,
	output reg [2:0] barcode[4:0],	// first 4 digit barcode + last 1 digit quantity
	output reg sold_flag,
	output reg [8:0] highligthPosX[11:0],
	output reg [8:0] highligthPosY[11:0]
);


reg[2:0] index; //barcode digit index
reg clk_down;   //button requires too slow clock ~10hz
integer counter;

//fruit id
reg[2:0] fruit_list[0:11][0:3] = '{ 
'{3,1,2,1},'{3,1,2,4},'{3,1,3,3},
'{3,2,1,4},'{3,2,2,2},'{3,2,3,1},
'{4,1,3,2},'{4,1,3,3},'{4,1,3,4},
'{4,2,4,4},'{4,3,3,1},'{4,4,3,2}};

reg[8:0] fruit_posX[0:11] = '{267,388,509,267,388,509,267,388,509,267,388,509};
reg[8:0] fruit_posY[0:11] = '{6,6,6,128,128,128,244,244,244,363,363,363};
reg [3:0] fruitIndex = 0;
reg [2:0] quantity = 0;
reg [2:0] soldItem[3:0];
reg[2:0] success_digit_count;
initial begin 
	index <= 0;
	sold_flag <= 0;
	clk_down <=0;
	success_digit_count <=0;
end

always @(posedge clk)begin
	if(counter < 499) //change it according to desired frequncy 
	counter <= counter + 1;
	else begin
	clk_down <= ~clk_down;
	counter <=0;
	end 
end
always @(posedge clk)begin
	case(switches)
		3'b000:begin  // all switches off, barcode entry mode active
			if(buttons[0] == 1'b1 && buttons[1] == 1'b1) begin  // sold complete, reset all
				index <= 0;
				for(reg[2:0] i = 0; i < 4; i = i+1)
					soldItem[i] = barcode[i];
				quantity <= barcode[4];
				barcode <='{0,0,0,0,0};
				sold_flag <=1;
				for(reg [3:0] i = 0; i< 12; i = i +1)begin
				highligthPosX[i] <=0;
				highligthPosY[i] <=0;
				end
			end
			else sold_flag <= 0;						
			if(index < 5)begin
				case(buttons)
					4'b0001: begin
						barcode[index] <= 3'b001;  //1 inserted
						index <= index + 1;
					end
					4'b0010:begin
						barcode[index] <= 3'b010;  //2 inserted
						index <= index + 1;
					end
					4'b0100: begin 
						barcode[index] <= 3'b011;	//3 inserted
						index <= index+1;
					end
					4'b1000: begin
						barcode[index] <= 3'b100;	// 4 insterted
						index <= index+1;
					end
				endcase
				
				for(reg[3:0] fruit_index = 0; fruit_index < 12 ; fruit_index = fruit_index+1)begin
					success_digit_count = 0;
					for(reg[2:0] digit = 0; digit < 4 ; digit = digit + 1)begin
						if (fruit_list[fruit_index][digit] == barcode[digit] && digit < index) begin
							success_digit_count = success_digit_count + 1;
							if(success_digit_count == index) begin
								highligthPosX[fruit_index] <= fruit_posX[fruit_index];
								highligthPosY[fruit_index] <= fruit_posY[fruit_index];
							end
							else begin
								highligthPosX[fruit_index] <= 0;
								highligthPosY[fruit_index] <= 0;
							end
						end
						else if (barcode[digit] != 0 && fruit_list[fruit_index][digit] != barcode[digit]) begin
							highligthPosX[fruit_index] <=0;
							highligthPosY[fruit_index] <=0;
						end			
					end	
				end
				
			end
			else index <=0;
		end
		3'b100:begin //sw-3 active navigation between images active
				
				if(buttons[0] == 1'b1 &&  fruitIndex < 11) //right move
					fruitIndex <= fruitIndex + 1;
				else if(buttons[1] == 1'b1 && fruitIndex > 0)  //left move
					fruitIndex <= fruitIndex - 1;
				else if (buttons[2] == 1'b1 && fruitIndex > 2) //up move
					fruitIndex <= fruitIndex - 3;
				else if (buttons[3] == 1'b1 && fruitIndex < 9) //down move
					fruitIndex <= fruitIndex + 3;
				
				for(reg[3:0] i = 0 ; i<12 ; i = i + 1)begin
					if(i == fruitIndex)begin
						highligthPosX[fruitIndex] <= fruit_posX[fruitIndex];
						highligthPosY[fruitIndex] <= fruit_posY[fruitIndex];
					end
					else begin
						highligthPosX[i] <=0;
						highligthPosY[i] <=0;
					end
				end
				
				if(switches[1] == 1)begin // SW-1 on, sell item and ask for quantity
					soldItem <= fruit_list[fruitIndex]; //***TODO: quantity nasıl sorarız
					fruitIndex <=0;
					case (buttons)
						4'b0001: quantity <=1;
						4'b0010: quantity <=2;
						4'b0100: quantity <=3;
						4'b1000: quantity <=4;
					endcase
				end
						
		end		
	endcase
end

endmodule