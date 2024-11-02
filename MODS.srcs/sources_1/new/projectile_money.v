`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 07:35:50 AM
// Design Name: 
// Module Name: projectile_money
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


module projectile_money(
    input CLOCK,
//    output [7:0] JB
    input [7:0] x_ref,
    input [7:0] y_ref,
    input [12:0] pixel_index,
    input is_active, // 0: unactive, 1: active
    output reg [15:0] oled_data
    );
    
    localparam GREEN = 16'h2564;
    localparam BROWN = 16'hDDB1;
    
//    wire [7:0] x_ref = 50;
//    wire [7:0] y_ref = 20;
    
//    wire [12:0] pixel_index;
//    reg [15:0] oled_data = 0;
//    wire frame_begin, sending_pixels, sample_pixel;
    wire [7:0] x, y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
//    wire clk625, clk1, clk10;
    
//    flexible_clock clock6p25m (CLOCK, 7, clk625);    
    
//    Oled_Display display (.clk(clk625), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
//     .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JB[0]), .sdin(JB[1]), 
//     .sclk(JB[3]), .d_cn(JB[4]), .resn(JB[5]), .vccen(JB[6]), .pmoden(JB[7]));
    
    always @ (posedge CLOCK)
    begin
    //        if (is_active)
        begin
            if ((y <= y_ref + 1 && y >= y_ref - 1) && (x == x_ref || x == x_ref + 1 || x == x_ref + 3 || x == x_ref + 4))
            begin
                oled_data = GREEN;
            end else if (x == x_ref + 2 && (y >= y_ref - 1 && y <= y_ref + 1))
            begin
                oled_data = BROWN;
            end else oled_data = 16'hFFFF;
        end
    end
endmodule
