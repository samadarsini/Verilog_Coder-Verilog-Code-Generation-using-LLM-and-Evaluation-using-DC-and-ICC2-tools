module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [2:0] state;
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @(posedge CLK, posedge RST) begin
    if (RST) begin
        MATCH <= 0;
        state <= S0;
    end
    else begin
        case (state)
            S0: begin
                if (IN) begin
                    MATCH <= 0;
                    state <= S1;
                end
                else begin
                    MATCH <= 0;
                    state <= S0;
                end
            end
            S1: begin
                if (IN) begin
                    MATCH <= 0;
                    state <= S2;
                end
                else begin
                    MATCH <= 0;
                    state <= S0;
                end
            end
            S2: begin
                if (IN) begin
                    MATCH <= 0;
                    state <= S3;
                end
                else begin
                    MATCH <= 0;
                    state <= S0;
                end
            end
            S3: begin
                if (IN) begin
                    MATCH <= 0;
                    state <= S4;
                end
                else begin
                    MATCH <= 0;
                    state <= S0;
                end
            end
            S4: begin
                if (IN) begin
                    MATCH <= 1;
                    state <= S5;
                end
                else begin
                    MATCH <= 0;
                    state <= S0;
                end
            end
            S5: begin
                if (IN) begin
                    MATCH <= 1;
                    state <= S0;
                end
                else begin
                    MATCH <= 0;
                    state <= S0;
                end
            end
        endcase
    end
end


endmodule