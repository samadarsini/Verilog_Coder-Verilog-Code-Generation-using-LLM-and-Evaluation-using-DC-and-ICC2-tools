module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

wire [7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;

// 8-bit adder implementation
adder_8bit adder0 (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(Cin),
    .y(s0),
    .Co(c0)
);

adder_8bit adder1 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(c0),
    .y(s1),
    .Co(c1)
);

adder_8bit adder2 (
    .a(s0),
    .b(s1),
    .Cin(c1),
    .y(s2),
    .Co(c2)
);

adder_8bit adder3 (
    .a(s2),
    .b(s3),
    .Cin(c2),
    .y(s4),
    .Co(c3)
);

adder_8bit adder4 (
    .a(s4),
    .b(s5),
    .Cin(c3),
    .y(s6),
    .Co(c4)
);

adder_8bit adder5 (
    .a(s6),
    .b(s7),
    .Cin(c4),
    .y(s8),
    .Co(c5)
);

adder_8bit adder6 (
    .a(s8),
    .b(s9),
    .Cin(c5),
    .y(s10),
    .Co(c6)
);

adder_8bit adder7 (
    .a(s10),
    .b(s11),
    .Cin(c6),
    .y(s12),
    .Co(c7)
);

adder_8bit adder8 (
    .a(s12),
    .b(s13),
    .Cin(c7),
    .y(s14),
    .Co(c8)
);

adder_8bit adder9 (
    .a(s14),
    .b(s15),
    .Cin(c8),
    .y(y),
    .Co(Co)
);

endmodule

module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

wire [3:0] s0, s1, s2, s3;
wire c0, c1, c2, c3;

// 4-bit adder implementation
adder_4bit adder0 (
    .a(a[3:0]),
    .b(b[3:0]),
    .Cin(Cin),
    .y(s0),
    .Co(c0)
);

adder_4bit adder1 (
    .a(a[7:4]),
    .b(b[7:4]),
    .Cin(c0),
    .y(s1),
    .Co(c1)
);

adder_4bit adder2 (
    .a(s0),
    .b(s1),
    .Cin(c1),
    .y(s2),
    .Co(c2)
);

adder_4bit adder3 (
    .a(s2),
    .b(s3),
    .Cin(c2),
    .y(y),
    .Co(c3)
);

endmodule

module adder_4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire Cin,
    output wire [3:0] y,
    output wire Co
);

wire [1:0] s0, s1;
wire c0, c1;

// 2-bit adder implementation
adder_2bit adder0 (
    .a(a[1:0]),
    .b(b[1:0]),
    .Cin(Cin),
    .y(s0),
    .Co(c0)
);

adder_2bit adder1 (
    .a(a[3:2]),
    .b(b[3:2]),
    .Cin(c0),
    .y(s1),
    .Co(c1)
);

adder_2bit adder2 (
    .a(s0),
    .b(s1),
    .Cin(c1),
    .y(y),
    .Co(Co)
);

endmodule

module adder_2bit (
    input wire [1:0] a,
    input wire [1:0] b,
    input wire Cin,
    output wire [1:0] y,
    output wire Co
);

wire [0:0] s0, s1;
wire c0;

// 1-bit adder implementation
xor x0 (
    .a(a[0]),
    .b(b[0]),
    .y(s0)
);

xor x1 (
    .a(a[1]),
    .b(b[1]),
    .y(s1)
);

xor x2 (
    .a(s0),
    .b(s1),
    .y(y[0])
);

and a0 (
    .a(a[0]),
    .b(b[0]),
    .y(c0)
);

and a1 (
    .a(a[1]),
    .b(b[1]),
    .y(Co)
);


endmodule