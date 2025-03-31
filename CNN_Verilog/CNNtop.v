module CNNtop(clk,reset,CNNinput,Conv1F,Conv2F,LeNetoutput);

parameter DATA_WIDTH_1 = 16;
parameter DATA_WIDTH_2 = 32;
parameter ImgInW = 32;
parameter ImgInH = 32;
parameter Kernel = 5;
parameter MP2out = 5;
parameter DepthC1 = 6;
parameter DepthC2 = 16;

integer counter;

input clk, reset;
input [ImgInW*ImgInH*DATA_WIDTH_1-1:0] CNNinput; 
input [Kernel*Kernel*DepthC1*DATA_WIDTH_1-1:0] Conv1F; // Weights for the first convolutional layer
input [DepthC2*Kernel*Kernel*DepthC1*DATA_WIDTH_1-1:0] Conv2F; // Weights for the second convolutional layer
output [3:0] LeNetoutput; // Output, 10-class classification

reg reset1,reset2; // Reset signals for convolution and ANN layers

wire [MP2out*MP2out*DepthC2*DATA_WIDTH_1-1:0] CNNout;   // Output of the convolutional layers, 5x5x16x16=6400
wire [MP2out*MP2out*DepthC2*DATA_WIDTH_2-1:0] ANNin;  // Output of the convolutional layers, 5x5x16x16=6400 (to be input into the ANN)

ConvIntegration C1
(
    .clk(clk),
    .reset(reset1),
    .CNNinput(CNNinput),
    .Conv1F(Conv1F),
    .Conv2F(Conv2F),
    .iConvOutput(CNNout)
);

Convert16to32
#(.NODES(400))
  T1
  (
    .clk(clk),
    .reset(reset),
    .input_fc(CNNout),
    .output_fc(ANNin)
  );
  
ANNtop A1
(
    .clk(clk),
    .reset(reset2),
    .input_ANN(ANNin),
    .output_ANN(LeNetoutput)
);

always @(posedge clk or posedge reset) begin
  if (reset == 1'b1) 
  begin
            // If reset is high, initialize reset signals and counter
            reset1 = 1'b1;  // Reset convolutional layers
            reset2 = 1'b1;  // Reset ANN layers
            counter = 0;     // Reset the counter
  end
else begin
  counter = counter + 1;
  if (counter < 7*1457+6*784*6+8+18*22*152 + 6*1600 + 20 + 10000) 
    reset1 = 1'b0;
   else 
    reset2 = 1'b0;
   end
 end
endmodule