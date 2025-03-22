module serial_adder(
    input clk,        // Clock input
    input rst,        // Reset input
    input [7:0] a,    // Input operand A
    input [7:0] b,    // Input operand B
    output reg [8:0] sum, // Output sum (8 bits plus carry)
    output reg cout   // Output carry out
);

reg [7:0] a_reg, b_reg; // Registers to store operands
reg [8:0] sum_reg;      // Register to store sum
reg cin_reg;            // Register to store carry in

always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        sum_reg <= 9'b0;
        cin_reg <= 1'b0;
    end else begin
        a_reg <= a;
        b_reg <= b;
        cin_reg <= sum_reg[8]; // Previous sum's carry out becomes current carry in
        sum_reg <= {cin_reg, a_reg} + b_reg; // Add operands and carry in
    end
end

assign sum = sum_reg[7:0]; // Output sum (discard carry out)
assign cout = sum_reg[8];  // Output carry out

endmodule
