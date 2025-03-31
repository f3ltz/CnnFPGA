`timescale 100 ns / 10 ps
module ConvMultiLayer(clk, reset, image, filters, outputConv);

parameter DATA_WIDTH = 16;
parameter D = 1; 
parameter H = 32; 
parameter W = 32; 
parameter F = 5; // (kernel size)
parameter K = 6; // Number of filters applied (First convolution layer filters)

// Port declarations
input clk, reset;
input [0:D*H*W*DATA_WIDTH-1] image; // Input image
input [0:K*D*F*F*DATA_WIDTH-1] filters; // Filter weights
output reg [0:K*(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputConv; // Output feature map

// Internal registers
reg [0:2*D*F*F*DATA_WIDTH-1] inputFilters; // Stores a subset of filters for processing
wire [0:2*(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputSingleLayers; // Stores the intermediate convolution results

reg internalReset; 

integer filterSet, counter, outputCounter; 

// Generate convolution layers for parallel processing
// This instantiates two convolution layers to process two filters at a time
// Each ConvLayer processes a portion of the input image with a given filter

genvar i;
generate
	for (i = 0; i < 2; i = i + 1) 
	begin 
		ConvLayer #(
		  .DATA_WIDTH(DATA_WIDTH),
		  .D(D),
		  .H(H),
		  .W(W),
		  .F(F)
		) UUT 
		(
			.clk(clk),
	    		.reset(internalReset),
	    		.image(image),
	    		.filter(inputFilters[i*D*F*F*DATA_WIDTH+:D*F*F*DATA_WIDTH]), // Assigns the correct filter subset
	    		.outputConv(outputSingleLayers[i*(H-F+1)*(W-F+1)*DATA_WIDTH+:(H-F+1)*(W-F+1)*DATA_WIDTH]) // Stores convolution results
      		);
  	end
endgenerate

always @ (posedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		internalReset = 1'b1; 
		filterSet = 0; 
		counter = 0; 
		outputCounter = 0; 
	end 
	else if (filterSet < K/2) 
	begin 
		if (counter == ((((H-F+1)*(W-F+1))/((H-F+1)/2))*(D*F*F+3)+1))
		 begin
			outputCounter = outputCounter + 1; 
			counter = 0; 
			internalReset = 1'b1; 
			filterSet = filterSet + 1; 
		end 
		else begin
			internalReset = 0; 
			counter = counter + 1;
		end
	end
end

always @ (*) begin
	inputFilters = filters[filterSet*2*D*F*F*DATA_WIDTH+:2*D*F*F*DATA_WIDTH]; // Select appropriate filters for processing
	outputConv[outputCounter*2*(H-F+1)*(W-F+1)*DATA_WIDTH+:2*(H-F+1)*(W-F+1)*DATA_WIDTH] = outputSingleLayers; // Store convolution results
end
endmodule