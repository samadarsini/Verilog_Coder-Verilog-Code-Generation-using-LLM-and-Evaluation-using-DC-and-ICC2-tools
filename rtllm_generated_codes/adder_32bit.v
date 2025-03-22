module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     wire [15:1] g[31:0];
     wire [15:1] p[31:0];
     wire [15:1] c[32:1];

     genvar i;
     generate
         for (i=0; i<32; i=i+1) begin : gen_cla
             cla_16bit cla_inst(.A(A[15:0]), .B(B[15:0]), .g(g[i]), .p(p[i]), .c(c[i+1]));
             assign S[i] = g[i][15] ^ p[i][15];
             assign c[i+1] = g[i][15] & p[i][15];
         end
     endgenerate

     assign C32 = c[32];

endmodule

module cla_16bit(A,B,g,p,c);
     input [15:1] A;
     input [15:1] B;
     output [15:1] g;
     output [15:1] p;
     output [15:1] c;

     assign g = A & B;
     assign p = A ^ B;
     assign c[0] = g[0];
     assign c[1] = g[1] | (p[1] & c[0]);
     assign c[2] = g[2] | (p[2] & c[1]);
     assign c[3] = g[3] | (p[3] & c[2]);
     assign c[4] = g[4] | (p[4] & c[3]);
     assign c[5] = g[5] | (p[5] & c[4]);
     assign c[6] = g[6] | (p[6] & c[5]);
     assign c[7] = g[7] | (p[7] & c[6]);
     assign c[8] = g[8] | (p[8] & c[7]);
     assign c[9] = g[9] | (p[9] & c[8]);
     assign c[10] = g[10] | (p[10] & c[9]);
     assign c[11] = g[11] | (p[11] & c[10]);
     assign c[12] = g[12] | (p[12] & c[11]);
     assign c[13] = g[13] | (p[13] & c[12]);
     assign c[14] = g[14] | (p[14] & c[13]);
     assign c[15] = g[15] | (p[15] & c[14]);


endmodule