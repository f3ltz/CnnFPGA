module IEEEMult (floatA, floatB, product); // Floating-point multiplier following IEEE 754 standard

input [31:0] floatA, floatB;  // Two 32-bit floating-point inputs
output reg [31:0] product;  // 32-bit floating-point product output

reg sign; // Sign bit
reg [7:0] exponent; 
reg [22:0] mantissa; 
reg [23:0] fractionA, fractionB; // Fraction representation including implicit leading 1
reg [47:0] fraction; // Intermediate result for multiplication
integer shift_count; // Counter for normalization

always @ (floatA or floatB) begin
    if (floatA == 0 || floatB == 0) begin
        product = 0; // Handle multiplication by zero case
    end else begin
        //if both numbers are of opposite signs,sign of result is 1
        sign = floatA[31] ^ floatB[31];
        
        // Compute the exponent sum and adjust bias
        exponent = floatA[30:23] + floatB[30:23] - 8'd127 + 8'd2;
        
        // Extract and add implicit 1 to the fraction parts
        fractionA = {1'b1, floatA[22:0]};
        fractionB = {1'b1, floatB[22:0]};
        fraction = fractionA * fractionB;
        
        // Normalize the fraction to fit IEEE 754 format
        shift_count = 0;
        while (fraction[47] == 1'b0 && shift_count < 23) begin
            fraction = fraction << 1;
            exponent = exponent - 1;
            shift_count = shift_count + 1;
        end
        
        // Assign the mantissa (removing the implicit leading 1)
        mantissa = fraction[46:24];
        
        // Combine sign, exponent, and mantissa to form the final product
        product = {sign, exponent, mantissa};
    end
end

endmodule