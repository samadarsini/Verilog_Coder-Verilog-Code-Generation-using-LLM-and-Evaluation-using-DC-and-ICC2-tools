module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
    end else begin
        if (Secs == 59) begin
            Secs <= 0;
            if (Mins == 59) begin
                Mins <= 0;
                if (Hours == 23) begin
                    Hours <= 0;
                end else begin
                    Hours <= Hours + 1;
                end
            end else begin
                Mins <= Mins + 1;
            end
        end else begin
            Secs <= Secs + 1;
        end
    end
end


endmodule