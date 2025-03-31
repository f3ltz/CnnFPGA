module RELU(clk,reset,en,output_fc,relu_out); 

parameter DATA_WIDTH = 32;
parameter OUTPUT_NEURONS = 32;

input clk, reset, en;
input [DATA_WIDTH*OUTPUT_NEURONS-1:0] output_fc;
output reg [DATA_WIDTH*OUTPUT_NEURONS-1:0]relu_out;

integer i;
always @ (negedge clk or posedge reset) 
begin
	if (reset == 1'b1) 
	begin
		relu_out = 0;
	end 
	else 
	begin
    if (en == 1'b1) 
    begin
        for (i = 0; i < OUTPUT_NEURONS; i = i + 1)
         begin
            if (output_fc[DATA_WIDTH*i-1+DATA_WIDTH] == 1'b1) //if input is negative then its 0  
                relu_out[DATA_WIDTH*i+:DATA_WIDTH] = 0; 
            else 
                relu_out[DATA_WIDTH*i+:DATA_WIDTH] = output_fc[DATA_WIDTH*i+:DATA_WIDTH];//if positive input=output
        end
    end
end
end
endmodule