`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2024 17:42:53
// Design Name: 
// Module Name: s1
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

// REPLACE ELSE COLOUR WITH BACKGROUND PLACEHOLDER 16'B1

module s1(
    input [6:0] xref, 
    input [6:0] x, 
    input [5:0] yref, 
    input [5:0] y,
    input clock, // always check, if xref, yref changes, change from frame1 to frame2 for eg
    input btnU, btnL, btnR,
    output reg [15:0] oled_data = 0
    );
    reg faceleft = 0;
    wire [15:0] r1_oled, r2_oled, r3_oled, j_oled;
    reg [2:0] casenum = 0;
    s1r1 st1r1(.xref(xref), .yref(yref), .clock(clock), .oled_data(r1_oled), .x(x), .y(y), .faceleft(faceleft));
    s1r2 st1r2(.xref(xref), .yref(yref), .clock(clock), .oled_data(r2_oled), .x(x), .y(y), .faceleft(faceleft));
    s1r3 st1r3(.xref(xref), .yref(yref), .clock(clock), .oled_data(r3_oled), .x(x), .y(y), .faceleft(faceleft));
    s1j st1j(.xref(xref), .yref(yref), .clock(clock), .oled_data(j_oled), .x(x), .y(y), .faceleft(faceleft));
    always @ (posedge clock) begin
        if (btnR) faceleft <= 0;
        else if (btnL) faceleft <= 1;
        // logic here to determine which oleddata to display
        // current logic is placeholder to test sprites on my own
        // will edit: eg if btnR held, cycle through 3 right-moving sprites
        if (btnU) casenum <= (casenum == 3) ? 0 : casenum + 1;
        case (casenum)
        0: oled_data <= r1_oled;
        1: oled_data <= r2_oled;
        2: oled_data <= r3_oled;
        3: oled_data <= j_oled;
        endcase
    end

endmodule

module s1r1(
    input [6:0] xref,
    input [5:0] yref,
    input [6:0] x,
    input [5:0] y,
    input clock,
    input faceleft,
    output reg [15:0] oled_data = 0
    );
    reg [31:0] pixel_index = 0;
    wire [15:0] white = 16'b1111111111111111;
    wire [15:0] darkred = 16'b1110100011000100;
    wire [15:0] skincol = 16'b1110010101101111;
    wire [15:0] grey = 16'b1001110011110011;
    wire [15:0] black = 0;
    wire [15:0] placeholder = 16'b1000010000011111;
    always @ (posedge clock) begin 
        pixel_index = (faceleft) ? xref + 7 - x + 8 * (y-yref) : x - xref + 8 * (y-yref) ;
        if (x <= xref + 7 && x >= xref && y <= yref + 7 && y >= yref) begin
            if (((pixel_index >= 3) && (pixel_index <= 5)) || pixel_index == 10 || pixel_index == 12 || ((pixel_index >= 18) && (pixel_index <= 19)) || ((pixel_index >= 34) && (pixel_index <= 35)) || ((pixel_index >= 42) && (pixel_index <= 45)) || (pixel_index >= 51) && (pixel_index <= 53)) oled_data = white;
            else if (pixel_index == 11) oled_data = darkred;
            else if (pixel_index == 13 || pixel_index == 20 || (pixel_index >= 27 && pixel_index <= 30) || pixel_index == 36 || pixel_index == 37 || pixel_index == 58 || pixel_index == 61) oled_data = skincol;
            else if (pixel_index == 41 || pixel_index == 54) oled_data = grey;
            else if (pixel_index == 21) oled_data = black;
            else oled_data = placeholder;
        end
    end        
endmodule

module s1r2(
    input [6:0] xref,
    input [5:0] yref,
    input [6:0] x,
    input [5:0] y,
    input clock,
    input faceleft,
    output reg [15:0] oled_data = 0
    );
    reg [31:0] pixel_index = 0;
    wire [15:0] white = 16'b1111111111111111;
    wire [15:0] darkred = 16'b1110100011000100;
    wire [15:0] skincol = 16'b1110010101101111;
    wire [15:0] grey = 16'b1001110011110011;
    wire [15:0] black = 0;
    wire [15:0] placeholder = 16'b1000010000011111;
    always @ (posedge clock) begin         
        pixel_index = (faceleft) ? xref + 7 - x + 8 * (y-yref) : x - xref + 8 * (y-yref) ;
        if (x <= xref + 7 && x >= xref && y <= yref + 7 && y >= yref) begin
            if (((pixel_index >= 3) && (pixel_index <= 5)) || pixel_index == 10 || pixel_index == 12 || ((pixel_index >= 18) && (pixel_index <= 19)) || ((pixel_index >= 34) && (pixel_index <= 35)) || ((pixel_index >= 42) && (pixel_index <= 45)) || (pixel_index >= 51) && (pixel_index <= 53)) oled_data = white;
            else if (pixel_index == 11) oled_data = darkred;
            else if (pixel_index == 13 || pixel_index == 20 || (pixel_index >= 27 && pixel_index <= 30) || pixel_index == 36 || pixel_index == 37 || pixel_index == 59 || pixel_index == 62) oled_data = skincol;
            else if (pixel_index == 46 || pixel_index == 50) oled_data = grey;
            else if (pixel_index == 21) oled_data = black;
            else oled_data = placeholder;
        end
    end
endmodule     
           
module s1r3(
    input [6:0] xref,
    input [5:0] yref,
    input [6:0] x,
    input [5:0] y,
    input clock,
    input faceleft,
    output reg [15:0] oled_data = 0
    );
    reg [31:0] pixel_index = 0;
    wire [15:0] white = 16'b1111111111111111;
    wire [15:0] darkred = 16'b1110100011000100;
    wire [15:0] skincol = 16'b1110010101101111;
    wire [15:0] grey = 16'b1001110011110011;
    wire [15:0] black = 0;
    wire [15:0] placeholder = 16'b1000010000011111;
    always @ (posedge clock) begin
        pixel_index = (faceleft) ? xref + 7 - x + 8 * (y-yref) : x - xref + 8 * (y-yref) ;
        if (x <= xref + 7 && x >= xref && y <= yref + 7 && y >= yref) begin
            if (((pixel_index >= 3) && (pixel_index <= 5)) || pixel_index == 10 || pixel_index == 12 || ((pixel_index >= 18) && (pixel_index <= 19)) || ((pixel_index >= 34) && (pixel_index <= 35)) || pixel_index == 42 || pixel_index == 44 || pixel_index == 46 || (pixel_index >= 51) && (pixel_index <= 53)) oled_data = white;
            else if (pixel_index == 11) oled_data = darkred;
            else if (pixel_index == 13 || pixel_index == 20 || (pixel_index >= 27 && pixel_index <= 30) || pixel_index == 36 || pixel_index == 37 || pixel_index == 59 || pixel_index == 61) oled_data = skincol;
            else if (pixel_index == 43 || pixel_index == 45) oled_data = grey;
            else if (pixel_index == 21) oled_data = black;
            else oled_data = placeholder;

        end  
    end
endmodule

module s1j(
    input [6:0] xref,
    input [5:0] yref,
    input [6:0] x,
    input [5:0] y,
    input clock,
    input faceleft,
    output reg [15:0] oled_data = 0
    );
    reg [31:0] pixel_index = 0;
    wire [15:0] white = 16'b1111111111111111;
    wire [15:0] darkred = 16'b1110100011000100;
    wire [15:0] skincol = 16'b1110010101101111;
    wire [15:0] grey = 16'b1001110011110011;
    wire [15:0] black = 0;
    wire [15:0] placeholder = 16'b1000010000011111;
    always @ (posedge clock) begin
    pixel_index = (faceleft) ? xref + 7 - x + 8 * (y-yref) : x - xref + 8 * (y-yref) ;
    if (x <= xref + 7 && x >= xref && y <= yref + 7 && y >= yref) begin
        if (((pixel_index >= 3) && (pixel_index <= 5)) || pixel_index == 10 || pixel_index == 12 || ((pixel_index >= 18) && (pixel_index <= 19)) || ((pixel_index >= 34) && (pixel_index <= 35)) || ((pixel_index >= 42) && (pixel_index <= 45)) || (pixel_index >= 50) && (pixel_index <= 53)) oled_data = white;
        else if (pixel_index == 11) oled_data = darkred;
        else if (pixel_index == 13 || pixel_index == 20 || ((pixel_index >= 27) && (pixel_index <= 30)) || pixel_index == 36 || pixel_index == 37 || pixel_index == 40 || pixel_index == 49 || pixel_index == 62) oled_data = skincol;
        else if (pixel_index == 17 || pixel_index == 25 || pixel_index == 46) oled_data = grey;
        else if (pixel_index == 21) oled_data = black;
        else oled_data = placeholder;
        end
    end
endmodule



