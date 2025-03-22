module updown_counter (
    input clk,       // Clock input
    input rst,       // Reset input
    input up_down,   // Up/Down control input
    output reg [7:0] count  // 8-bit counter output
);

always @(posedge clk) begin
    if (rst) begin
        count <= 8'b00000000;  // Reset the counter
    end else begin
        if (up_down == 1'b1) begin
            // Increment the counter if up_down is high
            if (count == 8'b11111111) begin
                count <= 8'b00000000;
            end else begin
                count <= count + 1;
            end
        end else begin
            // Decrement the counter if up_down is low
            if (count == 8'b00000000) begin
                count <= 8'b11111111;
            end else begin
                count <= count - 1;
            end
        end
    end
end

endmodule

