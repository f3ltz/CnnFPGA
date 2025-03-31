module UsingRelu16(clk,reset,en,input_fc,output_fc);

parameter DATA_WIDTH = 16;
parameter OUTPUT_NEURONS = 32;

input clk, reset, en;
input [DATA_WIDTH*OUTPUT_NEURONS-1:0] input_fc;
output reg [DATA_WIDTH*OUTPUT_NEURONS-1:0] output_fc;

integer i;

always @ (negedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		output_fc = 0;
	end else begin
		if (en == 1'b1) begin
			for (i = 0; i < OUTPUT_NEURONS; i = i + 1) begin
				if (input_fc[DATA_WIDTH*i-1+DATA_WIDTH] == 1'b1) 
					output_fc[DATA_WIDTH*i+:DATA_WIDTH] = 0;
				else 
					output_fc[DATA_WIDTH*i+:DATA_WIDTH] = input_fc[DATA_WIDTH*i+:DATA_WIDTH];
			end
		end
	end
end
endmodule