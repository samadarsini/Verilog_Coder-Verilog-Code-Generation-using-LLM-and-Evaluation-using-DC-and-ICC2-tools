module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output reg o_en
);

reg [DATA_WIDTH-1:0] add_reg [0:STG_WIDTH-1];
reg [DATA_WIDTH:0] sum_reg [0:STG_WIDTH-1];
reg [STG_WIDTH-1:0] carry_reg [0:STG_WIDTH-1];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < STG_WIDTH; i = i + 1) begin
            add_reg[i] <= 0;
            sum_reg[i] <= 0;
            carry_reg[i] <= 0;
        end
        o_en <= 0;
    end
    else begin
        if (i_en) begin
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                add_reg[i] <= {adda[DATA_WIDTH-1:DATA_WIDTH-(i*DATA_WIDTH/STG_WIDTH)], addb[DATA_WIDTH-1:DATA_WIDTH-(i*DATA_WIDTH/STG_WIDTH)]};
                sum_reg[i] <= add_reg[i] + carry_reg[i-1];
                carry_reg[i] <= {sum_reg[i][DATA_WIDTH-1], sum_reg[i][DATA_WIDTH-1:DATA_WIDTH-(i*DATA_WIDTH/STG_WIDTH)]};
            end
            o_en <= 1;
        end
        else begin
            o_en <= 0;
        end
    end
end

assign result = {carry_reg[STG_WIDTH-1], sum_reg[STG_WIDTH-1]};


endmodule