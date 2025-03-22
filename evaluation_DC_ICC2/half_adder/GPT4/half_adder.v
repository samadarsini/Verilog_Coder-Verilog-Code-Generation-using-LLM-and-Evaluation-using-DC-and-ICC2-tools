module half_adder(
    input clk,        // Clock input
    input [1:0] A,    // 2-bit input A
    input [1:0] B,    // 2-bit input B
    output reg [1:0] Sum,  // 2-bit sum output
    output reg Carry      // Carry output
);

// Intermediate signals
wire [1:0] sum_intermediate;
wire carry_out_intermediate0, carry_out_intermediate1;

// First bit half adder
assign sum_intermediate[0] = A[0] ^ B[0];
assign carry_out_intermediate0 = A[0] & B[0];

// Second bit half adder
assign sum_intermediate[1] = A[1] ^ B[1] ^ carry_out_intermediate0;
assign carry_out_intermediate1 = (A[1] & B[1]) | (B[1] & carry_out_intermediate0) | (A[1] & carry_out_intermediate0);

always @(posedge clk) begin
    Sum <= sum_intermediate;  // Register the sum output
    Carry <= carry_out_intermediate1;  // Register the carry output
end

endmodule

