module updown_counter(
    input clk,           // Clock input
    input rst,           // Synchronous reset input
    input up_down,       // Up/Down control input (1 for up, 0 for down)
    output reg [7:0] out // 8-bit counter output
);

// Counter operation
always @(posedge clk) begin
    if (rst)
        out <= 0;       // Reset counter to 0
    else if (up_down)
        out <= out + 1; // Increment counter
    else
        out <= out - 1; // Decrement counter
end

endmodule

