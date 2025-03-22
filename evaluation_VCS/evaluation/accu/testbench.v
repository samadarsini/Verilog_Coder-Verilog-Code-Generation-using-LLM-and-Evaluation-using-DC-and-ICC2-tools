`timescale 1ns / 1ps

module testbench_accu;


    reg clk;
    reg rst_n;
    reg [7:0] data_in;
    reg valid_in;


    wire valid_out;
    wire [9:0] data_out;

    accu uut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .valid_in(valid_in),
        .valid_out(valid_out),
        .data_out(data_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  
    end

    initial begin
        rst_n = 0;  
        valid_in = 0;
        data_in = 0;
        #10 rst_n = 1;  
        
        #10 valid_in = 1; data_in = 8'd10;  
        #10 data_in = 8'd20;                
        #10 data_in = 8'd30;                
        #10 data_in = 8'd40;                
        #10 valid_in = 0;                   

        
        #20 valid_in = 1; data_in = 8'd15;
        #10 data_in = 8'd25;
        #10 data_in = 8'd35;
        #10 data_in = 8'd45;                
        #10 valid_in = 0;                   
        #30;
        
        $finish;  
    end

    
    initial begin
        $dumpfile("accu_waveform.vcd");  
        $dumpvars(0, testbench_accu);    
    end

    
    initial begin
        $monitor("Time=%t | clk=%b, rst_n=%b, valid_in=%b, data_in=%d | valid_out=%b, data_out=%d", 
                 $time, clk, rst_n, valid_in, data_in, valid_out, data_out);
    end

endmodule
