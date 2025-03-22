module comparator(
    input clk,
    input [7:0] a,
    input [7:0] b,
    output reg equal,
    output reg less,
    output reg greater
);

always @(posedge clk) begin
    if (a == b) begin
        equal <= 1;
        less <= 0;
        greater <= 0;
    end else if (a < b) begin
        equal <= 0;
        less <= 1;
        greater <= 0;
    end else begin
        equal <= 0;
        less <= 0;
        greater <= 1;
    end
end

endmodule