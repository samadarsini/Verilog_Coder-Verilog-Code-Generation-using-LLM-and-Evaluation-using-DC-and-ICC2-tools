module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

wire [7:0] sum_0_7;
wire [7:0] sum_8_15;
wire [7:0] carry_0_7;
wire [7:0] carry_8_15;


adder_8bit adder_0 (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(Cin),
    .y(sum_0_7),
    .Co(carry_0_7)
);

adder_8bit adder_1 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(carry_0_7),
    .y(sum_8_15),
    .Co(carry_8_15)
);

assign y = {sum_8_15, sum_0_7};
assign Co = carry_8_15;

endmodule

module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

wire [7:0] sum;
wire [7:0] carry;


full_adder fa_0 (
    .a(a[0]),
    .b(b[0]),
    .Cin(Cin),
    .y(sum[0]),
    .Co(carry[0])
);

full_adder fa_1 (
    .a(a[1]),
    .b(b[1]),
    .Cin(carry[0]),
    .y(sum[1]),
    .Co(carry[1])
);

full_adder fa_2 (
    .a(a[2]),
    .b(b[2]),
    .Cin(carry[1]),
    .y(sum[2]),
    .Co(carry[2])
);

full_adder fa_3 (
    .a(a[3]),
    .b(b[3]),
    .Cin(carry[2]),
    .y(sum[3]),
    .Co(carry[3])
);

full_adder fa_4 (
    .a(a[4]),
    .b(b[4]),
    .Cin(carry[3]),
    .y(sum[4]),
    .Co(carry[4])
);

full_adder fa_5 (
    .a(a[5]),
    .b(b[5]),
    .Cin(carry[4]),
    .y(sum[5]),
    .Co(carry[5])
);

full_adder fa_6 (
    .a(a[6]),
    .b(b[6]),
    .Cin(carry[5]),
    .y(sum[6]),
    .Co(carry[6])
);

full_adder fa_7 (
    .a(a[7]),
    .b(b[7]),
    .Cin(carry[6]),
    .y(sum[7]),
    .Co(Co)
);

assign y = sum;

endmodule

module full_adder (
    input wire a,
    input wire b,
    input wire Cin,
    output wire y,
    output wire Co
);

wire s;
wire c;


xor_gate xg_0 (
    .a(a),
    .b(b),
    .y(s)
);


xor_gate xg_1 (
    .a(s),
    .b(Cin),
    .y(y)
);


and_gate ag_0 (
    .a(a),
    .b(b),
    .y(c)
);


or_gate og_0 (
    .a(c),
    .b(Cin),
    .y(Co)
);

endmodule

module xor_gate (
    input wire a,
    input wire b,
    output wire y
);

assign y = a ^ b;

endmodule

module and_gate (
    input wire a,
    input wire b,
    output wire y
);

assign y = a & b;

endmodule

module or_gate (
    input wire a,
    input wire b,
    output wire y
);

assign y = a | b;


endmodule