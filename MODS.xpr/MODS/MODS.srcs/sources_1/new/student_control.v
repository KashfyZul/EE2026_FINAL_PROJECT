`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 05:43:39
// Design Name: 
// Module Name: student_control
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


module student_control(
    input [31:0] x, y,
    input clock, btnU, btnL, btnR,
    input [6:0] xref_std, [5:0] yref_std, 
    input [6:0] xref_e1, [5:0] yref_e1, 
    input [6:0] xref_e2, [5:0] yref_e2,
    input [2:0] stnum,
    output reg [15:0] pixel_data
    );
    wire [15:0] s1_oled;
    wire [15:0] s2_oled;
    wire [15:0] s3_oled;
    wire [15:0] s4_oled;
    wire [15:0] s5_oled;
    s1 draw_s1(
        .xref(xref_std), .x(x), .yref(yref_std), .y(y), 
        .clock(clock), .btnU(btnU), .btnL(btnL), .btnR(btnR), .oled_data(s1_oled)
        );
    // repeat for s2-5
    
    always @ (posedge clock) begin
        case (stnum)
            0: pixel_data = s1_oled;
            // 1: pixel_data = s2_oled;
            // 2: pixel_data = s3_oled;
            // 3: pixel_data = s4_oled;
            // 4: pixel_data = s5_oled;
        endcase
    end
endmodule
