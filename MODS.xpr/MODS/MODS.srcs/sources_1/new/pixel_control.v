`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2024 16:52:02
// Design Name: 
// Module Name: pixel_control
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

// "std" = student

module pixel_control(
    input [31:0] x, y,
    input clock, btnU, btnL, btnR,
    input [6:0] xref_std, [5:0] yref_std, 
    input [6:0] xref_e1, [5:0] yref_e1, 
    input [6:0] xref_e2, [5:0] yref_e2,
    output [15:0] pixel_data
    );
    
    s1 draw_s1(
        .xref(xref_std), .x(x), .yref(yref_std), .y(y), 
        .clock(clock), .btnU(btnU), .btnL(btnL), .btnR(btnR), .oled_data(pixel_data)
        );
    // module for drawing student
        // within module for drawing student, call s1/s2/s3/s4/s5 via multiplexer
    // module for drawing enemies taking in 5 pairs of xref,yref
        // within module for drawing enemies, include indiv draw_enemy modules
    
endmodule
