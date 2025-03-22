`timescale 1ns / 1ps

module tb_multi_16bit;

    
    reg clk;
    reg rst_n;
    reg start;
    reg [15:0] ain;
    reg [15:0] bin;

    
    wire [31:0] yout;
    wire done;

    
    multi_16bit uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .ain(ain),
        .bin(bin),
        .yout(yout),
        .done(done)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    
    initial begin
        
        rst_n = 1; 
        start = 0;
        ain = 0;
        bin = 0;

        
        #10;
        rst_n = 0; 
        #10;
        rst_n = 1; 

        
        #1000;
        $display("Simulation End - Timeout");
        $finish;
    end

    
    initial begin
        
        @(negedge rst_n);
        #20; 

       
        @(posedge clk);
        start = 1;
        ain = 16'h1234;
        bin = 16'h5678;
        @(posedge clk);
        start = 0;

        
        wait(done == 1);
        @(posedge clk);

        
        if (yout == ain * bin) begin
            $display("Test Passed - Correct Result: %h", yout);
        end else begin
            $display("Test Failed - Incorrect Result: %h, Expected: %h", yout, ain * bin);
        end

        $finish; 
    end

    
    initial begin
        $dumpfile("multi_16bit_waveform.vcd");
        $dumpvars(0, tb_multi_16bit);
    end

endmodule
