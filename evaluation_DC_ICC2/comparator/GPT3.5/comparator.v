module comparator(
    input clk,        // Clock input
    input [7:0] a,    // Input operand A
    input [7:0] b,    // Input operand B
    output reg eq,    // Output equal
    output reg lt,    // Output less than
    output reg gt     // Output greater than
);

reg [7:0] a_reg, b_reg; // Registers to store operands

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    eq <= (a_reg == b_reg);
    lt <= (a_reg < b_reg);
    gt <= (a_reg > b_reg);
end

endmodule