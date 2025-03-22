module ring_counter(
    input clk,          // Clock input
    input rst,          // Synchronous reset input
    output reg [7:0] out // 8-bit output of the counter
);

// Initial block for simulation purposes, to define the initial output state
initial begin
    out = 8'b00000001;  // Initialize with first bit set
end

// Logic for the ring counter
always @(posedge clk) begin
    if (rst) begin
        out <= 8'b00000001; // Reset the counter to the initial state
    end else begin
        out <= {out[6:0], out[7]}; // Rotate the bits to the left
    end
end

endmodule
