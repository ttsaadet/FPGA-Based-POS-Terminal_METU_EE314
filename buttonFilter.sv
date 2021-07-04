module buttonFilter(input clk_down,
input wire button,
output reg filtered_button);

reg button_state = 0;
integer counter = 0;


always @(posedge clk_down) begin
    if(button == 1 && button_state == 0)begin
        filtered_button <= 1;  
        button_state <= 1;
    end
    else if (button == 1 && button_state == 1) 
        filtered_button <= 0;
    else if (button == 0)begin
        filtered_button <= 0; 
        button_state <= 0;
    end
end
endmodule

