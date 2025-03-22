module tb_right_shifter;

    reg clk;
    reg d;
    wire [7:0] q;

   
    right_shifter dut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    
    initial begin
        
        d = 0;

        
        #10 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 d = 1;
        #10 d = 0;
        #10 d = 0;
        #10 d = 1;
        #10 d = 1;
        #10 d = 0;
        #10 d = 1;

        
        #100;
        $stop;
    end

    
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_right_shifter);
    end

endmodule
