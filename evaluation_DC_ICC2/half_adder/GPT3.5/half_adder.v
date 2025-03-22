module half_adder (
    input [1:0] a1,
    input [1:0] a2,
    input clk,
    output [1:0] sum,
    output carry
);

reg [1:0] sum_reg;
reg carry_reg;

always @(posedge clk) begin
    // XOR operation for each bit of the inputs
    sum_reg[0] <= a1[0] ^ a2[0];
    sum_reg[1] <= a1[1] ^ a2[1];
    
    // AND operation for generating carry
    carry_reg <= (a1[0] & a2[0]) | (a1[1] & a2[1]);
end

assign sum = sum_reg;
assign carry = carry_reg;

endmodule

