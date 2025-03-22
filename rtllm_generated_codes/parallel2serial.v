module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

    reg [3:0] data;
    reg [1:0] cnt;
    wire valid;

    assign valid_out = valid;
    assign dout = data[0];

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cnt <= 0;
            data <= 0;
            valid <= 0;
        end
        else begin
            if (cnt == 3) begin
                data <= d;
                cnt <= 0;
                valid <= 1;
            end
            else begin
                cnt <= cnt + 1;
                valid <= 0;
                data <= {data[2:0], d[3]};
            end
        end
    end


endmodule