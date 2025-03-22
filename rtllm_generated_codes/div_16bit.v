module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [3:0] count;
    reg [15:0] remainder;
    reg [15:0] quotient;
    reg [15:0] temp;

    always @(*) begin
        a_reg = A;
        b_reg = B;
        count = 4'd0;
        quotient = 16'd0;
        remainder = 16'd0;
        temp = 16'd0;

        while (count < 4) begin
            if (a_reg[15] == 1) begin
                quotient[count] = 1'b1;
                remainder = a_reg - (b_reg << (4 - count));
            end else begin
                quotient[count] = 1'b0;
                remainder = a_reg;
            end

            a_reg = remainder;
            count = count + 1;
        end

        result = quotient;
        odd = remainder;
    end


endmodule