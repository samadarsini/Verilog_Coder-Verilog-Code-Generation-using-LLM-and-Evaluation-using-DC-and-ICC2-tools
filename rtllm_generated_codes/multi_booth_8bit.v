`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] multiplier = 16'h0;
   reg [15:0] multiplicand = 16'h0;
   reg [4:0] ctr = 5'h0;
   reg [15:0] p_reg = 16'h0;
   wire [7:0] a_shifted = {a, 8'b0};
   wire [7:0] b_shifted = {b, 8'b0};
   wire [15:0] p_shifted = {p_reg, 8'b0};

   always @(posedge clk, posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         ctr <= 5'h0;
         p_reg <= 16'h0;
      end
      else begin
         if (ctr < 5'h10) begin
            multiplicand <= {multiplicand[14:0], multiplicand[15]};
            if (multiplier[ctr] == 1'b1) begin
               p_reg <= p_reg + multiplicand;
            end
            ctr <= ctr + 1;
         end
         else begin
            rdy <= 1'b1;
         end
      end
   end

   assign p = p_shifted;


endmodule