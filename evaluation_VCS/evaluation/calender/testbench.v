`timescale 1ns / 1ps

module testbench_calendar;

    
    parameter CLOCK_PERIOD = 10; 

    
    reg CLK = 0; 
    reg RST;

    
    wire [5:0] Hours, Mins, Secs;

    
    calendar uut (
        .CLK(CLK),
        .RST(RST),
        .Hours(Hours),
        .Mins(Mins),
        .Secs(Secs)
    );

    
    always #(CLOCK_PERIOD / 2) CLK = ~CLK; 

    
    initial begin
        RST = 1; 
        #100;    
        RST = 0; 
    end

    
    initial begin
        
        forever begin
            @(posedge CLK);
            #5000; 
            $display("Time=%t Hours=%d Mins=%d Secs=%d", $time, Hours, Mins, Secs);
        end
    end

    
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, testbench_calendar);
        #100000; 
        $finish;
    end

endmodule
