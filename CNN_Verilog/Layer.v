module Layer(clk, reset, input_fc, weights, output_fc); // First fully connected layer

// Parameter definitions
parameter DATA_WIDTH = 32; 
parameter INPUT_NEURONS = 100; 
parameter OUTPUT_NEURONS = 32; 

// Port declarations
input clk, reset; 
input [DATA_WIDTH*INPUT_NEURONS-1:0] input_fc; // Input feature vector, flattened
input [DATA_WIDTH*OUTPUT_NEURONS-1:0] weights; // Weights for the layer
output [DATA_WIDTH*OUTPUT_NEURONS-1:0] output_fc; // Output feature vector

reg [DATA_WIDTH-1:0] selectedInput; 
integer j; 

// Generate multiple processing elements (PEs) for computation
// Each PE performs a multiplication between an input value and a weight
// and stores the result in the corresponding output position

genvar i;
generate
    for (i = 0; i < OUTPUT_NEURONS; i = i + 1) 
    begin : processing_elements
        ProcessingElement PE (
            .clk(clk),
            .reset(reset),
            .floatA(selectedInput), // Input value selected sequentially
            .floatB(weights[DATA_WIDTH*i+:DATA_WIDTH]), // Corresponding weight
            .result(output_fc[DATA_WIDTH*i+:DATA_WIDTH]) // Computed result
        );
    end
endgenerate

// Sequential logic to select input NEURONS one by one
always @ (posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        selectedInput <= 0; 
        j <= INPUT_NEURONS - 1; // Start from the last input node
    end 
    else if (j < 0) 
        selectedInput <= 0; // Stop when all inputs are processed
    else 
    begin
        selectedInput <= input_fc[DATA_WIDTH*j+:DATA_WIDTH]; // Select the current input node
        j <= j - 1; 
    end
end
endmodule