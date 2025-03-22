module serial_adder(
    input wire clk,       // Clock input
    input wire reset,     // Reset input
    input wire enable,    // Enable input
    input wire [7:0] A,  // 8-bit input A
    input wire [7:0] B,  // 8-bit input B
    output reg [7:0] sum // 8-bit output sum
);

reg [7:0] register;     // Internal register to hold the sum

always @(posedge clk or posedge reset) begin
    if (reset) begin    // Reset condition
        register <= 8'b0;
    end else if (enable) begin  // When enable is high, add A and B serially
        register <= register + A;
    end
end

assign sum = register;  // Output the sum

endmodule

