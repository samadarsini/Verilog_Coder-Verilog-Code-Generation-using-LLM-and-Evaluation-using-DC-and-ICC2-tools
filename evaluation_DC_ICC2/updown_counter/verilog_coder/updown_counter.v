module updown_counter(
    input clk,
    input reset,
    output reg [7:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 8'b0;
    end else begin
        if (count == 8'hFF) begin
            count <= 8'b0;
        end else if (count == 8'b0) begin
            count <= 8'hFF;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule
