module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State machine states
parameter IDLE = 2'b00;
parameter PULSE_START = 2'b01;
parameter PULSE_MIDDLE = 2'b10;

// State machine registers
reg [1:0] state, next_state;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state = PULSE_START;
                    data_out = 1'b0;
                end
                else begin
                    next_state = IDLE;
                    data_out = 1'b0;
                end
            end
            PULSE_START: begin
                next_state = PULSE_MIDDLE;
                data_out = 1'b0;
            end
            PULSE_MIDDLE: begin
                if (!data_in) begin
                    next_state = IDLE;
                    data_out = 1'b1;
                end
                else begin
                    next_state = PULSE_MIDDLE;
                    data_out = 1'b0;
                end
            end
        endcase
    end
end


endmodule