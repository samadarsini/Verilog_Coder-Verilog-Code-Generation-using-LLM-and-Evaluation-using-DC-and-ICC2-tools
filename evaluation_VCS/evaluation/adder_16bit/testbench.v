`timescale 1ns / 1ps

module testbench_adder_16bit;

    
    reg [15:0] a;
    reg [15:0] b;
    reg Cin;

    
    wire [15:0] y;
    wire Co;

    
    adder_16bit uut (
        .a(a),
        .b(b),
        .Cin(Cin),
        .y(y),
        .Co(Co)
    );

    initial begin
        
        a = 0; b = 0; Cin = 0;

        
        #100;
        
        
        a = 16'h1234; b = 16'h0001; Cin = 0;
        #20;  // Delay to observe the result

        
        a = 16'h00FF; b = 16'h0001; Cin = 0;
        #20;

        
        a = 16'h00FF; b = 16'hFFFF; Cin = 0;
        #20;

        
        a = 16'hFFFF; b = 16'h0001; Cin = 1;
        #20;

        
        a = 16'hFFFF; b = 16'hFFFF; Cin = 1;
        #20;  

        $finish;  
    end

    
    initial begin
        $dumpfile("adder_16bit_waveform.vcd"); 
        $dumpvars(0, testbench_adder_16bit);   
    end

    
    initial begin
        $monitor("Time=%t | a=%h, b=%h, Cin=%b | y=%h, Co=%b", 
                  $time, a, b, Cin, y, Co);
    end

endmodule
