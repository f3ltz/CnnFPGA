module IEEEAdd (floatA,floatB,sum); // 
	
input [31:0] floatA, floatB; // 2 32 bit floating oint numbers
output reg [31:0] sum; 

reg sign; //sign bit 
reg [22:0] mantissa; //23 bits for mantissa or factional part
reg [7:0] exponentA, exponentB, exponent; // 8 bits allocated for the exponent part
reg [23:0] fractionA, fractionB, fraction;	//fraction = {1,mantissa}
reg [7:0] shiftAmount;
reg cout;
integer shift_count;

always @ (floatA or floatB) begin
	exponentA = floatA[30:23]; //exponent part of the first number
	exponentB = floatB[30:23];// exponeny part of the second number
	fractionA = {1'b1,floatA[22:0]};//fractional part with implicit 1 for normalisation
	fractionB = {1'b1,floatB[22:0]}; 
	
	exponent = exponentA;

	if (floatA == 0) 
		//special case (floatA = 0)
		sum = floatB;
	else if (floatB == 0) //special case (floatB = 0)
		sum = floatA;
	else if (floatA[30:0] == floatB[30:0] && floatA[31]^floatB[31]==1'b1) //when numbers are equal and opposite
		sum=0;
	else 
	begin
		if (exponentB > exponentA) 
		begin
			shiftAmount = exponentB - exponentA; //B is greater
			fractionA = fractionA >> (shiftAmount); //divide fractional part
			exponent = exponentB;//multiply the exponent part
		end 
		else if (exponentA > exponentB) begin 
			shiftAmount = exponentA - exponentB;
			fractionB = fractionB >> (shiftAmount);
			exponent = exponentA;
		end
		if (floatA[31] == floatB[31])
		 begin			//same sign
			{cout,fraction} = fractionA + fractionB;
			if (cout == 1'b1) 
			begin
				{cout,fraction} = {cout,fraction} >> 1; //rightshift to accomodate the fractional part
				exponent = exponent + 1; //increase by 1
			end
			sign = floatA[31];
		end 
		else 
		begin						//different signs
			if (floatA[31] == 1'b1)
				{cout,fraction} = fractionB - fractionA; // to keep the number positive b- (-a)
			else 
			begin
				{cout,fraction} = fractionA - fractionB;//a-(-b)
			end
			sign = cout;
			if (cout == 1'b1) //negative
			begin
				fraction = -fraction;
			end 
			
		if (fraction[23] == 0) 
		begin //to make the 23rd bit 0(making sure 1 for normalisation)
			shift_count = 0;
			while (fraction[23] == 0 && shift_count < 23) 
			begin
				fraction = fraction << 1;
				shift_count = shift_count + 1;
			end
			exponent = exponent - shift_count;
		end
				end
				mantissa = fraction[22:0];
				sum = {sign,exponent,mantissa};			
			end		
		end

endmodule