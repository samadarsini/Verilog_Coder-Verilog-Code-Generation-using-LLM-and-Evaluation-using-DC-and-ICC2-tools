module tb_signal_generator;

    
    reg clk;
    reg rst_n;
    wire [4:0] wave;

    
    signal_generator dut (
        .clk(clk),
        .rst_n(rst_n),
        .wave(wave)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    
    initial begin
        
        rst_n = 0;

        
        #10 rst_n = 1;

        
        #500;

        
        $stop;
    end

    
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_signal_generator);
    end

    
    initial begin
        $monitor("Time=%0t : rst_n=%b, wave=%d", $time, rst_n, wave);
    end

endmodule
