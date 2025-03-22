module multi_pipe_8bit#(
    parameter size = 8
)(
          clk,      
          rst_n,       
          mul_a,       
          mul_b, 
          mul_en_in,
 
          mul_en_out,      
          mul_out    
);
   input clk;           
   input rst_n; 
   input mul_en_in;      
   input [size-1:0] mul_a;       
   input [size-1:0] mul_b;       
 
   output reg mul_en_out;  
   output reg [size*2-1:0] mul_out;    

   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg [size-1:0] mul_a_reg_next;
   reg [size-1:0] mul_b_reg_next;
   reg [size*2-1:0] sum;
   reg [size*2-1:0] sum_next;
   reg [size*2-1:0] mul_out_reg;
   reg [size*2-1:0] mul_out_reg_next;
   reg [size-1:0] temp;
   reg [size-1:0] temp_next;
 
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_en_out <= 0;
         mul_a_reg <= 0;
         mul_b_reg <= 0;
         sum <= 0;
         mul_out_reg <= 0;
      end
      else begin
         mul_en_out <= mul_en_in;
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
         sum <= 0;
         mul_out_reg <= 0;
         sum_next <= {temp, {size{1'b0}}};
         mul_out_reg_next <= {mul_out_reg[size*2-2:0], temp};
      end
   end
   
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         temp <= 0;
      end
      else begin
         temp <= mul_b_reg & {size{1'b0}};
      end
   end
   
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_out <= 0;
      end
      else begin
         mul_out <= mul_out_reg;
      end
   end
   
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_out_reg <= 0;
      end
      else begin
         mul_out_reg <= mul_out_reg_next;
      end
   end
   

endmodule