module alu(
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [2:0] ALU_control,
    input wire clk,
    output reg [7:0] result
);

// Internal signals
reg [7:0] temp_result;

always @(posedge clk) begin
    case(ALU_control)
        3'b000: temp_result <= A + B; // Addition
        3'b001: temp_result <= A - B; // Subtraction
        3'b010: temp_result <= A & B; // Bitwise AND
        3'b011: temp_result <= A | B; // Bitwise OR
        3'b100: temp_result <= A ^ B; // Bitwise XOR
        3'b101: temp_result <= A << 1; // Shift left
        3'b110: temp_result <= A >> 1; // Shift right
        default: temp_result <= 8'b0;  // Default behavior
    endcase
end

always @(posedge clk) begin
    result <= temp_result;
end

endmodule
