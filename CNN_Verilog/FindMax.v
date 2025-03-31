module FindMax(n,max_index);

 parameter DATA_WIDTH = 320;
 parameter NUM_VALUES = 10;
 parameter VALUE_WIDTH = DATA_WIDTH / NUM_VALUES;

input  [DATA_WIDTH-1:0] n;
output reg [$clog2(NUM_VALUES)-1:0] max_index;

reg [VALUE_WIDTH-1:0] max_value;
    integer i;

    always @(*) begin
        max_value = n[VALUE_WIDTH-1:0];
        max_index = 0;
        for (i = 1; i < NUM_VALUES; i = i + 1) 
        begin
            if (n[i*VALUE_WIDTH +: VALUE_WIDTH] > max_value) 
            begin
                max_value = n[i*VALUE_WIDTH +: VALUE_WIDTH];
                max_index = i;
            end
        end
    end
endmodule