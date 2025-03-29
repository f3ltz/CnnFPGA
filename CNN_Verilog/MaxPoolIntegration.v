`timescale 1 ns / 10 ps
module MaxPoolIntegration(clk, reset, apInput, apOutput);

// Parameter definitions
parameter DATA_WIDTH = 16; 
parameter D = 6; // Number of depth channels
parameter H = 28; // Height of input feature map
parameter W = 28; // Width of input feature map

// Port declarations
input reset, clk; 
input [0:H*W*D*DATA_WIDTH-1] apInput; // Flattened input feature map
output reg [0:(H/2)*(W/2)*D*DATA_WIDTH-1] apOutput; // Flattened output after max pooling

// Internal signals
reg [0:H*W*DATA_WIDTH-1] apInput_s; // Temporary storage for a single depth slice
wire [0:(H/2)*(W/2)*DATA_WIDTH-1] apOutput_s; // Output of the max-pooling operation for a single depth slice
integer counter; 

// Instantiating the MaxPoolSingle module
// This module performs max pooling on a single depth slice
MaxPoolSingle
  #(
      .DATA_WIDTH(DATA_WIDTH),
      .InputH(H),
      .InputW(W)
  ) maxPool
  (
      .aPoolIn(apInput_s), // Providing a single depth slice as input
      .aPoolOut(apOutput_s) // Receiving the pooled output
  );

// Sequential logic to iterate through depth slices
always @ (posedge clk or posedge reset) begin
  if (reset == 1'b1) 
  begin
    counter = 0; // Reset the counter to start from the first depth slice
  end
  else if (counter < D) begin 
    counter = counter + 1; // Increment counter to process the next depth slice
    // The final value of counter will be 6 (D = 6)
  end
end

// extract and store depth slices
always @ (*) begin
  // Extracting the current depth slice from the input tensor
  apInput_s = apInput[counter*H*W*DATA_WIDTH+:H*W*DATA_WIDTH];
  // Storing the corresponding pooled output in the output tensor
  apOutput[counter*(H/2)*(W/2)*DATA_WIDTH+:(H/2)*(W/2)*DATA_WIDTH] = apOutput_s;
end
endmodule
