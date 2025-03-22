module comparator(
    input clk,                 // Clock input
    input [7:0] a, b,          // 8-bit inputs for comparison
    output reg a_gt_b,         // Output: a > b
    output reg a_lt_b,         // Output: a < b
    output reg a_eq_b          // Output: a == b
);

// Perform comparison on clock's rising edge
always @(posedge clk) begin
    if (a > b) begin
        a_gt_b <= 1;
        a_lt_b <= 0;
        a_eq_b <= 0;
    end
    else if (a < b) begin
        a_gt_b <= 0;
        a_lt_b <= 1;
        a_eq_b <= 0;
    end
    else begin
        a_gt_b <= 0;
        a_lt_b <= 0;
        a_eq_b <= 1;
    end
end

endmodule
