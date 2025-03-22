`timescale 1ns / 1ps

module testbench_counter_12;

    
    reg rst_n;
    reg clk;
    reg valid_count;

    
    wire [3:0] out;

    
    counter_12 uut (
        .rst_n(rst_n),
        .clk(clk),
        .valid_count(valid_count),
        .out(out)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  
    end

    
    initial begin
        
        rst_n = 0;  
        valid_count = 0;

        
        #10 rst_n = 1;  
        #10 valid_count = 1;  

        
        #240;  

        
        #10 valid_count = 0;
        #20;

        $finish;  
    end

    
    initial begin
        $dumpfile("counter_12_waveform.vcd");  
        $dumpvars(0, testbench_counter_12);    
    end

    
    initial begin
        $monitor("Time=%t | clk=%b, rst_n=%b, valid_count=%b | out=%d", 
                 $time, clk, rst_n, valid_count, out);
    end

endmodule
