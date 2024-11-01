`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    output [7:0] JB,
    input btnU, btnL, btnR, btnC, btnD
);
    wire frame_begin;
    wire [12:0] pixel_index;
    wire sending_pixels;
    wire sample_pixel;
    wire [15:0] pixel_data;
    
    wire clk_6p25M;
    flexible_clock_signal clk6p25M (.clk(clk), .number(7), .slw_clk(clk_6p25M));
    
    wire [6:0]x;
    wire [5:0]y;
    assign x = pixel_index%96;
    assign y = pixel_index/96;
    
    s1(.xref(48), .x(x), .yref(32), .y(y), .clock(clk), .btnU(btnU), .btnL(btnL), .btnR(btnR), .oled_data(pixel_data)
        );
    
Oled_Display oleddisp (
    .clk(clk_6p25M), 
    .reset(0), // ground
    .frame_begin(frame_begin), 
    .sending_pixels(sending_pixels),
    .sample_pixel(sample_pixel), 
    .pixel_index(pixel_index), 
    .pixel_data(pixel_data),
    .cs(JB[0]), 
    .sdin(JB[1]), 
    .sclk(JB[3]), 
    .d_cn(JB[4]), 
    .resn(JB[5]), 
    .vccen(JB[6]),
    .pmoden(JB[7]) 
    );


endmodule