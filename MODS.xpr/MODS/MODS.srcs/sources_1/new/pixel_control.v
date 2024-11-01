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
    input [2:0] stnum,
    output [15:0] pixel_data
    );
    wire [15:0] s1_oled;
    student_control studcont(
        .x(x), .y(y), .clock(clock), .btnU(btnU), .btnL(btnL), .btnR(btnR),
        .xref_std(xref_std), .yref_std(yref_std), 
        .xref_e1(xref_e1), .yref_e1(yref_e1), 
        .xref_e2(xref_e2), .yref_e2(yref_e2),
        .stnum(stnum),
        .pixel_data(pixel_data)
        );
    // add module for drawing enemies taking in 5 pairs of xref,yref
        // within module for drawing enemies, include indiv draw_enemy modules
    // add module for drawing muffin
    
    // always block: if (x within xref_1 and xref_1+7, and y within yref_1 and yref_1 + 7)
    //                  then (pixel_data = 1_data)
    //               repeat as many times as necessary, each new statement higher priority than previous (ie overwriting if needed)
    
endmodule
