module decoder2to4 (
    input wire clk,         // Clock input
    input wire [1:0] in,    // 2-bit input
    output reg [3:0] out    // 4-bit output
);

// Decoder logic triggered on the rising edge of the clock
always @(posedge clk) begin
    case (in)
        2'b00: out = 4'b0001;  // Output line 0 is high
        2'b01: out = 4'b0010;  // Output line 1 is high
        2'b10: out = 4'b0100;  // Output line 2 is high
        2'b11: out = 4'b1000;  // Output line 3 is high
        default: out = 4'b0000; // Default to 0, should not happen
    endcase
end

endmodule

