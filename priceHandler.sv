module priceHandler(
input wire clk,
input wire [2:0] quantitylist[0:11], // TODO: DEFINE ITS SIZE PROPERLY
output reg calc_complete,
output reg [3:0] price_disp[0:3]
);

reg [15:0] totalPrice;    
initial begin
totalPrice = 0;     
price_disp = '{0,0,0,0};
end

reg [11:0] priceList[0:11] = '{200,250,100, 995,665,350, 50,75,80, 125,150,90};

always @(posedge clk) begin
    totalPrice = 0;
    calc_complete = 0;
    for(reg[3:0] i= 0; i <12; i = i +1 )begin
        totalPrice = totalPrice + priceList[i]*quantitylist[i];
    end
    //decompese number
    price_disp[0] = totalPrice % 10000; // ex: 2150, take = 2 here
    price_disp[1] = totalPrice % 1000;
    price_disp[2] = totalPrice % 100;
    price_disp[3] = totalPrice % 10;
    calc_complete = 1 ;
    
end


endmodule