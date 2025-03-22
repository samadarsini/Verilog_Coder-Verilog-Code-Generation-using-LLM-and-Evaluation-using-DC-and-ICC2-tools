module serial_adder(
    input clk,
    input [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] sum;
reg carry;

always @(posedge clk) begin
    sum <= data_in + {carry, 8'b0};
    carry <= (sum[8] == 1);
end

assign data_out = sum;

endmodule