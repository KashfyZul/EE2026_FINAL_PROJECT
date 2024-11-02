`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 02:55:11 AM
// Design Name: 
// Module Name: test_seven_segment_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_seven_segment_display(
    input btnC, 
    input CLOCK,
    output [3:0] an,
    output [6:0] seg
    );
    
    wire clk1;
    flexible_clock clock1 (CLOCK, 49_999_999, clk1);
    reg [31:0] counter = 0;
    
    always @ (posedge clk1) 
    begin
        counter <= counter + 1;
    end
    
    seven_seg_display dis (counter, CLOCK, an, seg);
    
endmodule
