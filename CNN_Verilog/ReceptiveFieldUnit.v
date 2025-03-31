`timescale 100 ns / 10 ps

module ReceptiveFieldUnit(image, rowNumber, column, receptiveField);

parameter DATA_WIDTH = 16;  // Define data width for the inputs/outputs (16-bit data)
parameter D = 1;            // Depth of the filter (e.g., number of channels)
parameter H = 32;           // Height of the image
parameter W = 32;           // Width of the image
parameter F = 5;            // Size of the filter (5x5 filter)

input [0:D*H*W*DATA_WIDTH-1] image;   // Input image (flattened to a 1D array)
input [5:0] rowNumber, column;        // Row and column for selecting receptive field
output reg [0:(((W-F+1)/2)*D*F*F*DATA_WIDTH)-1] receptiveField;  // Output receptive field

integer address, col, k, i; 

always @ (image or rowNumber or column) begin
    address = 0; 
    //processing 2 halves of a row at the same time to increase efficiency
    // Select the receptive field based on the column value (left or right part of the image)
    //processes 14 cxolumns from the left
    if (column == 0) begin
        // If the column is at the left, select the receptive field from the first part of the image
        for (col = 0; col < (W-F+1)/2; col = col + 1) begin
            for (k = 0; k < D; k = k + 1) begin
                for (i = 0; i < F; i = i + 1) begin
                    // Copy a 5x5 patch of the image (along the depth and height) into receptiveField
                    receptiveField[address*F*DATA_WIDTH+:F*DATA_WIDTH] = 
                        image[rowNumber*W*DATA_WIDTH+col*DATA_WIDTH+k*H*W*DATA_WIDTH+i*W*DATA_WIDTH+:F*DATA_WIDTH];
                    address = address + 1;  // Increment the address for the next receptive field patch
                end
            end
        end
    end else begin
        // If the column is in the right part, select the receptive field from the second part of the image
        //processes 14 to 28th column
        for (col = (W-F+1)/2; col < (W-F+1); col = col + 1) begin
            for (k = 0; k < D; k = k + 1) 
            begin
                for (i = 0; i < F; i = i + 1) 
                begin
                    // Copy a 5x5 patch of the image (along the depth and height) into receptiveField
                    receptiveField[address*F*DATA_WIDTH+:F*DATA_WIDTH] = 
                        image[rowNumber*W*DATA_WIDTH+col*DATA_WIDTH+k*H*W*DATA_WIDTH+i*W*DATA_WIDTH+:F*DATA_WIDTH];
                    address = address + 1;  // Increment the address for the next receptive field patch
                end
            end
        end
    end
end

endmodule
