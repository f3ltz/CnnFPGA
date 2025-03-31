`timescale 100 ns / 10 ps

module IEEEMult16 (floatA, floatB, product); // 16-bit wide

input [15:0] floatA, floatB;
output reg [15:0] product;

reg sign;
reg signed [5:0] exponent; // 6th bit is the sign
reg [9:0] mantissa;
reg [10:0] fractionA, fractionB;  // fraction = {1, mantissa}
reg [21:0] fraction;
reg [7:0] shiftAmount;  // For shifting the fraction

always @ (floatA or floatB) 
begin
    if (floatA == 0 || floatB == 0) 
    begin
        product = 0;
    end 
    else 
    begin
        // Calculate sign (XOR of the sign bits)
        sign = floatA[15] ^ floatB[15];
        
        // Calculate exponent (sum of the exponents, adjusted for bias)
        exponent = floatA[14:10] + floatB[14:10] - 5'd15 + 5'd2;
        
        // Normalize the fractions by adding the implicit leading 1
        fractionA = {1'b1, floatA[9:0]};
        fractionB = {1'b1, floatB[9:0]};
        
        // Multiply the fractions
        fraction = fractionA * fractionB;

        // Normalize the result using a while loop
        shiftAmount = 0;
        while (fraction[21] == 1'b1 && shiftAmount < 22) 
        begin
            fraction = fraction << 1;  // Shift the fraction to normalize
            shiftAmount = shiftAmount + 1;
        end
        exponent = exponent - shiftAmount;  // Adjust the exponent based on shifts

        // Handle the case where the fraction is not normalized
        mantissa = fraction[21:12];  // The resulting mantissa is the upper 10 bits

        // If exponent is negative (overflow), set product to zero
        if (exponent[5] == 1'b1) 
        begin  // Exponent is negative
            product = 0;  // Set product to zero
        end 
        else 
        begin
            product = {sign, exponent[4:0], mantissa};  // Assemble the final product
        end
    end
end

endmodule