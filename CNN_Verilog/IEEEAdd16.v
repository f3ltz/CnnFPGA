`timescale 100 ns / 10 ps
module IEEEAdd16 (floatA, floatB, sum);  // Here, the width is now 16-bits

input [15:0] floatA, floatB;
output reg [15:0] sum;

reg sign;
reg signed [5:0] exponent; // 5th bit is the sign of the exponent
reg [9:0] mantissa;
reg [4:0] exponentA, exponentB;
reg [10:0] fractionA, fractionB, fraction; // fraction = {1, mantissa}
reg [7:0] shiftAmount;
reg cout;

always @ (floatA or floatB) 
begin
    exponentA = floatA[14:10];
    exponentB = floatB[14:10];
    fractionA = {1'b1, floatA[9:0]};
    fractionB = {1'b1, floatB[9:0]}; 

    exponent = exponentA;

    if (floatA == 0) 
    begin  // special case (floatA = 0)
        sum = floatB;
    end 
    else if (floatB == 0) 
    begin  // special case (floatB = 0)
        sum = floatA;
    end 
    else if (floatA[14:0] == floatB[14:0] && floatA[15]^floatB[15]==1'b1)
     begin
        sum = 0;
    end 
    else 
    begin
        // Align exponents by shifting the fraction accordingly
        if (exponentB > exponentA) begin
            shiftAmount = exponentB - exponentA;
            fractionA = fractionA >> shiftAmount;
            exponent = exponentB;
        end 
        else if (exponentA > exponentB) 
        begin
            shiftAmount = exponentA - exponentB;
            fractionB = fractionB >> shiftAmount;
            exponent = exponentA;
        end

        if (floatA[15] == floatB[15]) 
        begin  // Same sign, addition
            {cout, fraction} = fractionA + fractionB;
            if (cout == 1'b1) 
            begin
                {cout, fraction} = {cout, fraction} >> 1;
                exponent = exponent + 1;
            end
            sign = floatA[15];
        end 
        else 
        begin  // Different signs, subtraction
            if (floatA[15] == 1'b1) 
                {cout, fraction} = fractionB - fractionA;
            else 
            begin
                {cout, fraction} = fractionA - fractionB;
            end
            sign = cout;
            if (cout == 1'b1) 
                fraction = -fraction;
        end

        // Normalize the fraction by shifting until the most significant bit is non-zero
        shiftAmount = 0;
        while (fraction[10] == 0 && shiftAmount < 11) 
        begin
            fraction = fraction << 1;
            shiftAmount = shiftAmount + 1;
        end
        exponent = exponent - shiftAmount;

        // Assign the mantissa from the normalized fraction
        mantissa = fraction[9:0];

        // Check for exponent overflow (negative exponent)
        if (exponent[5] == 1'b1) 
        begin  // exponent is negative
            sum = 0;  // Set sum to zero in case of underflow
        end 
        else 
            sum = {sign, exponent[4:0], mantissa};  // Assemble the final sum    
    end        
end

endmodule