`timescale 1 ns / 10 ps
module ConvIntegration (clk, reset, CNNinput, Conv1F, Conv2F, iConvOutput);

// Parameter definitions
parameter DATA_WIDTH = 16; 
parameter ImgInW = 32; 
parameter ImgInH = 32; 
parameter Conv1Out = 28; // Output size after first convolution
parameter MvgP1out = 14; // Output size after first max pooling
parameter Conv2Out = 10; // Output size after second convolution
parameter Kernel = 5; // Kernel size
parameter MvgP2out = 5; // Output size after second max pooling
parameter DepthC1 = 6; // Depth of first convolutional layer
parameter DepthC2 = 16; // Depth of second convolutional layer

integer counter; 
// Port declarations
input clk, reset;
input [ImgInW*ImgInH*DATA_WIDTH-1:0] CNNinput; // Input image data
input [Kernel*Kernel*DepthC1*DATA_WIDTH-1:0] Conv1F; // Filters for first convolutional layer
input [DepthC2*Kernel*Kernel*DepthC1*DATA_WIDTH-1:0] Conv2F; // Filters for second convolutional layer
output [MvgP2out*MvgP2out*DepthC2*DATA_WIDTH-1:0] iConvOutput; // Final output


reg C1rst, C2rst, MP1rst, MP2rst, Relu1Reset, Relu2Reset, enRelu;


wire [Conv1Out*Conv1Out*DepthC1*DATA_WIDTH-1:0] C1out;
wire [Conv1Out*Conv1Out*DepthC1*DATA_WIDTH-1:0] C1outRelu;
wire [MvgP1out*MvgP1out*DepthC1*DATA_WIDTH-1:0] MP1out;
wire [Conv2Out*Conv2Out*DepthC2*DATA_WIDTH-1:0] C2out;
wire [Conv2Out*Conv2Out*DepthC2*DATA_WIDTH-1:0] C2outRelu;
wire [MvgP2out*MvgP2out*DepthC2*DATA_WIDTH-1:0] MP2out;

// First Convolutional Layer
ConvMultiLayer C1
(
	.clk(clk),
	.reset(reset),
	.image(CNNinput),
	.filters(Conv1F),
	.outputConv(C1out)
);

// First ReLU Activation
UsingRelu16
#(.OUTPUT_NEURONS(Conv1Out*Conv1Out*DepthC1))
relu_1
(
  .clk(clk),
  .reset(Relu1Reset),
  .en(enRelu),
  .input_fc(C1out),
  .output_fc(C1outRelu)
);

// First Max Pooling Layer
MaxPoolIntegration MP1
(
    .clk(clk),
    .reset(MP1rst),
    .apInput(C1outRelu),
    .apOutput(MP1out)
);

// Second Convolutional Layer
ConvMultiLayer 
#(
  .DATA_WIDTH(16),
  .D(6),
  .H(14),
  .W(14),
  .F(5),
  .K(16)
) C2 
(
	.clk(clk),
	.reset(C2rst),
	.image(MP1out),
	.filters(Conv2F),
	.outputConv(C2out)
);

// Second ReLU Activation
UsingRelu16
#(.OUTPUT_NEURONS(Conv2Out*Conv2Out*DepthC2))
relu_2
(
  .clk(clk),
  .reset(Relu2Reset),
  .en(enRelu),
  .input_fc(C2out),
  .output_fc(C2outRelu)
);

// Second Max Pooling Layer
MaxPoolIntegration 
#(
  .D(16),
  .H(10),
  .W(10)
) MP2
(
    .clk(clk),
    .reset(MP2rst),
    .apInput(C2outRelu),
    .apOutput(iConvOutput)
);

// Control Logic for Sequential Execution
always @(posedge clk or posedge reset) begin
  if (reset == 1'b1) begin
    C1rst = 1'b1;
    C2rst = 1'b1;
    MP1rst = 1'b1;
    MP2rst = 1'b1;
    Relu1Reset = 1'b1;
    Relu2Reset = 1'b1;
    enRelu = 1'b1;
    counter = 0;
  end
  else begin
    counter = counter + 1;
    if (counter > 0 && counter < 7*1457) begin
      C1rst = 1'b0;
    end
    else if (counter > 7*1457 && counter < 7*1457+6*784*6) begin
      Relu1Reset = 1'b0;
    end
    else if (counter > 7*1457+6*784*6 && counter < 7*1457+6*784*6+8) begin
      MP1rst = 1'b0;
    end
    else if (counter > 7*1457+6*784*6+8 && counter < 7*1457+6*784*6+8+18*22*152) begin
      C2rst = 1'b0;
    end
    else if (counter > 7*1457+6*784*6+8+18*22*152 && counter < 7*1457+6*784*6+8+18*22*152 + 6*1600) begin
      Relu2Reset = 1'b0;
    end
    else if (counter > 7*1457+6*784*6+8+18*22*152 + 6*1600 && counter < 7*1457+6*784*6+8+18*22*152 + 6*1600 + 20) begin
      MP2rst = 1'b0;
    end
  end
end

endmodule