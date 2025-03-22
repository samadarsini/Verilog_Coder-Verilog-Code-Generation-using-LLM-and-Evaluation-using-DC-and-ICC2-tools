module ring_counter(
    input wire clk,  // Clock input
    input wire rst,  // Asynchronous reset input
    output reg [3:0] out // Output of the ring counter
);

// Define internal state register
reg [3:0] state;

// Always block for clocked behavior
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset condition
        state <= 4'b0000;
    end else begin
        // Shift the state left
        state <= {state[2:0], state[3]};
    end
end

// Assign output
assign out = state;

endmodule
