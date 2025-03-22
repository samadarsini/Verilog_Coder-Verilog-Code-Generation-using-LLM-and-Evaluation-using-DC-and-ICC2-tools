`timescale 1ns / 1ps

module testbench_fsm;

    
    reg IN;
    reg CLK;
    reg RST;

   
    wire MATCH;

    fsm uut (
        .IN(IN),
        .MATCH(MATCH),
        .CLK(CLK),
        .RST(RST)
    );

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  
    end

    
    initial begin
        RST = 1;
        #10;
        RST = 0;
    end

    
    initial begin
        IN = 0;
        #10;     
        IN = 1;  
        #10;
        IN = 1;
        #10;
        IN = 1;
        #10;
        IN = 1;
        #10;
        IN = 1;  
        #10;
        IN = 0;  
        #10;
        IN = 1;  
        #10;
        IN = 1;
        #10;
        IN = 1;
        #10;
        IN = 1;
        #10;
        IN = 1;  
        #20;     
    end

    
    initial begin
        $dumpfile("fsm_waveform.vcd"); 
        $dumpvars(0, testbench_fsm);   
        #200;                           
        $finish;                       
    end

    
    initial begin
        $monitor("Time = %t, IN = %b, MATCH = %b, State = %b", $time, IN, MATCH, uut.state);
    end

endmodule
