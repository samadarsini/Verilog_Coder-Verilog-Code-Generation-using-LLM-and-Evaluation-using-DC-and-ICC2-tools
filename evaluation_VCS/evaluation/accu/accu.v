module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [7:0] data_reg [3:0];
    reg [9:0] sum_reg;
    reg [1:0] count_reg;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            valid_out <= 0;
            data_out <= 0;
            count_reg <= 0;
            sum_reg <= 0;
        end
        else begin
            if (valid_in) begin
                data_reg[count_reg] <= data_in;
                count_reg <= count_reg + 1;
                if (count_reg == 3) begin
                    sum_reg <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                    valid_out <= 1;
                    data_out <= {sum_reg, 2'b0};
                    count_reg <= 0;
                end
            end
            else begin
                valid_out <= 0;
                data_out <= 0;
            end
        end
    end


endmodule