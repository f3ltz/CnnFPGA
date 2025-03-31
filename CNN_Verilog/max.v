module max (n1, n2, n3, n4, max);

parameter DATA_WIDTH = 16; 

input [DATA_WIDTH-1:0] n1; //4 input numbers
input [DATA_WIDTH-1:0] n2; 
input [DATA_WIDTH-1:0] n3; 
input [DATA_WIDTH-1:0] n4; 
output [DATA_WIDTH-1:0] max; // Output for the maximum value

// Calculate the maximum of the four inputs using nested ternary operators
assign max = (n1 > n2) ? ( (n3 > n4) ? n3 : n4 ) : ( (n2 > n4) ? n2 : n4 );
endmodule
