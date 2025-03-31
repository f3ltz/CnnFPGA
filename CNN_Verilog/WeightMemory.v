module WeightMemory(clk, address, weights);

// These are default parameters and can be changed during instantiation
parameter DATA_WIDTH = 32; 
parameter INPUT_NEURONS = 100; // Number of input nodes
parameter OUTPUT_NEURONS = 32; // Number of output nodes
parameter file = "E:/Parameters With No Separators/weights1_IEEE.txt"; // Input weight file

localparam TOTAL_WEIGHT_SIZE = INPUT_NEURONS * OUTPUT_NEURONS; // Total number of weights

input clk; 
input [8:0] address; 
output reg [DATA_WIDTH*OUTPUT_NEURONS-1:0] weights; // Output weights

reg [DATA_WIDTH-1:0] memory [0:TOTAL_WEIGHT_SIZE-1]; // Memory to store weights

integer i;

always @ (posedge clk) 
begin
	if (address > INPUT_NEURONS-1 || address < 0) 
	begin
		weights = 0;
	end 
	else 
	begin
		for (i = 0; i < OUTPUT_NEURONS; i = i + 1) 
		begin
			weights[(OUTPUT_NEURONS-1-i)*DATA_WIDTH+:DATA_WIDTH] = memory[(address*OUTPUT_NEURONS)+i];
		end
	end
end

initial 
begin
	$readmemh(file, memory);
end
endmodule