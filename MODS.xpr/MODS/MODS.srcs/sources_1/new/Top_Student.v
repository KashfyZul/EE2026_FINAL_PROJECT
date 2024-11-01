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
    
    // update with e3-e5 assuming 5 enemies
    // update with xref_muffin and yref_muffin
    wire [6:0]xref_std;
    wire [5:0]yref_std;
    wire [6:0]xref_e1;
    wire [5:0]yref_e1;
    wire [6:0] xref_e2;
    wire [5:0] yref_e2;
    wire [2:0] stnum; // decide which sprite to show. eg case(0): medicine, case(1): ... etc
    pixel_control pixycont (
        .x(x), .y(y), .clock(clk), .btnU(btnU), .btnL(btnL), .btnR(btnR),
        .xref_std(xref_std), .yref_std(yref_std), .stnum(stnum), 
        .xref_e1(xref_e1), .yref_e1(yref_e1), 
        .xref_e2(xref_e2), .yref_e2(yref_e2),
        .pixel_data(pixel_data)
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
