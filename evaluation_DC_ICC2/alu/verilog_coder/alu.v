module alu(
    input clk,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result
);

reg [7:0] temp;

always @ (posedge clk) begin
    case (temp)
        8'b00000001: result <= a + 1; // increment
        8'b00000010: result <= a - 1; // decrement
        8'b00000100: result <= a & b; // bitwise and
        8'b00001000: result <= a | b; // bitwise or
        8'b00010000: result <= a ^ b; // bitwise xor
        8'b00100000: result <= a << 1; // shift left by one
        8'b01000000: result <= a >> 1; // shift right by one
        8'b10000000: result <= ~a; // invert all bits
        default: result <= 8'h00; // default to zero
    endcase
end

always @ (posedge clk) begin
    temp <= a & b;
end

endmodule