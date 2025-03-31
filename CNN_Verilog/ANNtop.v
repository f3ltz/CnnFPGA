`timescale 1 ns / 10 ps
module ANNtop(clk, reset, input_ANN, output_ANN);

// Parameter definitions
parameter DATA_WIDTH = 32; 
parameter INPUT_NEURONS_L1 = 400; 
parameter INPUT_NEURONS_L2 = 120; 
parameter INPUT_NEURONS_L3 = 84; 
parameter OUTPUT_NEURONS = 10; //

input clk, reset;
input [DATA_WIDTH*INPUT_NEURONS_L1-1:0] input_ANN; // Flattened input data
output [3:0] output_ANN; // Encoded output class index

reg rstLayer;
reg rstRelu; 
reg enRelu; 
reg [8:0] address; // Address for accessing weights

// Internal wire declarations
wire [DATA_WIDTH*INPUT_NEURONS_L2-1:0] output_L1;
wire [DATA_WIDTH*INPUT_NEURONS_L2-1:0] output_L1_relu;
wire [DATA_WIDTH*INPUT_NEURONS_L3-1:0] output_L2;
wire [DATA_WIDTH*INPUT_NEURONS_L3-1:0] output_L2_relu;
wire [DATA_WIDTH*OUTPUT_NEURONS-1:0] output_L3;

// Weight memory for storing layer weights
wire [DATA_WIDTH*INPUT_NEURONS_L2-1:0] WL1;
wire [DATA_WIDTH*INPUT_NEURONS_L3-1:0] WL2;
wire [DATA_WIDTH*OUTPUT_NEURONS-1:0] WL3;

// Instantiate weight memory for each layer
WeightMemory 
#(.INPUT_NEURONS(INPUT_NEURONS_L1),
  .OUTPUT_NEURONS(INPUT_NEURONS_L2),
  .file("C:/Users/nagen/Downloads/CNN_Verilog_Files/FullyConnected1.txt"))
  W1(
    .clk(clk),
    .address(address),
    .weights(WL1)
    );
    
WeightMemory 
#(.INPUT_NEURONS(INPUT_NEURONS_L2),
  .OUTPUT_NEURONS(INPUT_NEURONS_L3),
  .file("C:/Users/nagen/Downloads/CNN_Verilog_Files/FullyConnected2.txt"))
  W2(
    .clk(clk),
    .address(address),
    .weights(WL2)
    );

WeightMemory 
#(.INPUT_NEURONS(INPUT_NEURONS_L3),
  .OUTPUT_NEURONS(OUTPUT_NEURONS),
  .file("C:/Users/nagen/Downloads/CNN_Verilog_Files/Classifier.txt"))
  W3(
    .clk(clk),
    .address(address),
    .weights(WL3)
    );

// Instantiate fully connected layers and activation functions
Layer
#(.INPUT_NEURONS(INPUT_NEURONS_L1),
  .OUTPUT_NEURONS(INPUT_NEURONS_L2))
 L1(
    .clk(clk),
    .reset(rstLayer),
    .input_fc(input_ANN),
    .weights(WL1),
    .output_fc(output_L1)
    );
    
RELU #(.OUTPUT_NEURONS(INPUT_NEURONS_L2)) relu_1
(
  .clk(clk),
  .reset(rstRelu),
  .en(enRelu),
  .output_fc(output_L1),
  .relu_out(output_L1_relu)
);
    
Layer
#(.INPUT_NEURONS(INPUT_NEURONS_L2),
  .OUTPUT_NEURONS(INPUT_NEURONS_L3))
 L2(
    .clk(clk),
    .reset(rstLayer),
    .input_fc(output_L1_relu),
    .weights(WL2),
    .output_fc(output_L2)
    );

RELU #(.OUTPUT_NEURONS(INPUT_NEURONS_L3)) relu_2
(
  .clk(clk),
  .reset(rstRelu),
  .en(enRelu),
  .output_fc(output_L2),
  .relu_out(output_L2_relu)
);

Layer
#(.INPUT_NEURONS(INPUT_NEURONS_L3),
  .OUTPUT_NEURONS(OUTPUT_NEURONS))
 L3(
    .clk(clk),
    .reset(rstLayer),
    .input_fc(output_L2_relu),
    .weights(WL3),
    .output_fc(output_L3)
    );

// Find the maximum value from the output layer (final classification)
FindMax findmax1
(
    .n(output_L3),
    .max_index(output_ANN)
);

// Control logic for managing reset and enable signals
always @(posedge clk or posedge reset) 
begin
  if (reset == 1'b1) 
  begin
    rstRelu = 1'b1;
    rstLayer = 1'b1;
    address = -1;
    enRelu = 1'b0;
  end
  else 
  begin
      rstRelu = 1'b0;
      rstLayer = 1'b0;
    if (address == INPUT_NEURONS_L1+1) 
    begin
      address = address + 1;
      enRelu = 1'b1;
    end
    else if (address == INPUT_NEURONS_L1+2) 
    begin
      address = -1;
      enRelu = 1'b0;
      rstLayer = 1'b1;
    end
    else 
    begin
      address = address + 1;
    end
  end
end

endmodule