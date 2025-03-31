`timescale 1 ns / 10 ps
module MaxPoolingUnit(aPoolIn, aPoolOut);
  
// Parameter definitions
parameter DATA_WIDTH = 16; 
parameter InputH = 28; // Height of input feature map
parameter InputW = 28; // Width of input feature map
parameter Depth = 1; // Number of depth channels


input [0:InputH*InputW*Depth*DATA_WIDTH-1] aPoolIn; // Flattened input feature map
output [0:(InputH/2)*(InputW/2)*Depth*DATA_WIDTH-1] aPoolOut; // Flattened output after max pooling

// Generate variables
genvar i, j;

generate 
  // Iterating over the height and width of the feature map in steps of 2 (2x2 pooling)
  for (i = 0; i < InputH; i = i + 2) begin
    for (j = 0; j < InputW; j = j + 2) begin
      // Instantiating the max pooling operation for each 2x2 region
      max
      #(
        .DATA_WIDTH(DATA_WIDTH)
      ) max1
      (
        .n1(aPoolIn[(i*InputH + j) * DATA_WIDTH +: DATA_WIDTH]), // Top-left element of 2x2 window
        .n2(aPoolIn[(i*InputH + j + 1) * DATA_WIDTH +: DATA_WIDTH]), // Top-right element
        .n3(aPoolIn[((i + 1) * InputH + j) * DATA_WIDTH +: DATA_WIDTH]), // Bottom-left element
        .n4(aPoolIn[((i + 1) * InputH + j + 1) * DATA_WIDTH +: DATA_WIDTH]), // Bottom-right element
        .max(aPoolOut[(i/2 * (InputH/2) + j/2) * DATA_WIDTH +: DATA_WIDTH]) // Storing max value in output feature map
      );
    end
  end
endgenerate
endmodule