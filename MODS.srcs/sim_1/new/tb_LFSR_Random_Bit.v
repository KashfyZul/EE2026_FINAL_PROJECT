`timescale 1ns / 1ps

module tb_LFSR_Random_Bit;

    // Testbench signals
    reg clk;
    wire [11:0] random;  
    reg rst;

    // Instantiate the LFSR_Random_Bit module
    LFSR_random test (
        .CLOCK(clk),
        .rst(rst),
        .n(2),
        .random(random)
    );

    // Clock generation: 10ns period (100 MHz)
    always begin
        #5 clk = ~clk; // Toggle the clock every 5ns
    end

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1; // Assert reset
        #10 rst = 0; // Deassert reset after 10ns
        #1000 $finish; // End simulation after 1000ns

    end
endmodule
