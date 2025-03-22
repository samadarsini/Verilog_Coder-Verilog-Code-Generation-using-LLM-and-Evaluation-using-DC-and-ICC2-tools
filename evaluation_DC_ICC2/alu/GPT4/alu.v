module alu(
    input clk,                  // Clock input
    input enable,               // Enable input for operations
    input [2:0] opcode,         // Operation code
    input [7:0] operand1,       // First operand
    input [7:0] operand2,       // Second operand
    output reg [7:0] result,    // Result of the ALU operation
    output reg carry_out        // Carry out flag for arithmetic operations
);

// Define operation codes
localparam [2:0] ADD = 3'b000,
                 SUB = 3'b001,
                 AND = 3'b010,
                 OR  = 3'b011,
                 XOR = 3'b100,
                 NOT = 3'b101;

// ALU operations
always @(posedge clk) begin
    if (enable) begin
        carry_out = 0; // Default to 0
        case (opcode)
            ADD: {carry_out, result} = operand1 + operand2; // Handle carry
            SUB: {carry_out, result} = operand1 - operand2; // Handle borrow
            AND: result = operand1 & operand2;
            OR:  result = operand1 | operand2;
            XOR: result = operand1 ^ operand2;
            NOT: result = ~operand1; // NOT uses only the first operand
            default: result = 8'b0; // Default case to avoid latches
        endcase
    end
end

endmodule
