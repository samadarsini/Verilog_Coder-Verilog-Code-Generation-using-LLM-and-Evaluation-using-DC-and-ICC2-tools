module decoder2to4 (
    input [1:0] input_bits,  // 2-bit input
    input clk,               // clock input
    output reg [3:0] output_bits  // 4-bit output
);

always @(posedge clk) begin
    output_bits[0] <= ~(input_bits[0] | input_bits[1]);
    output_bits[1] <= ~(input_bits[0] | ~input_bits[1]);
    output_bits[2] <= ~(~input_bits[0] | input_bits[1]);
    output_bits[3] <= ~(input_bits[0] & input_bits[1]);
end

endmodule

