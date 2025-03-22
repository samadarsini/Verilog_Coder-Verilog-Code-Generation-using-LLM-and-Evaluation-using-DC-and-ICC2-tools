module ring_counter(
    input clk,
    output reg [7:0] q);

    always @(posedge clk) begin
        q <= {q[6:0], q[7]};
    end

endmodule