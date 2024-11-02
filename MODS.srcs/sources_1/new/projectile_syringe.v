`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 05:18:54 AM
// Design Name: 
// Module Name: projectile_syringe
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


module projectile_syringe(
    input CLOCK,
//    output [7:0] JB,
    input [7:0] x_ref,
    input [7:0] y_ref,
    input [12:0] pixel_index,
    input direction, // 0: left, 1: right
    input is_active, // 0: unactive, 1: active
    output reg [15:0] oled_data
    );
    
    localparam BLACK = 16'h0000;
    localparam TEAL = 16'h55DE;
    
//    wire [7:0] x_ref = 50;
//    wire [7:0] y_ref = 20;
//    wire direction;
    
//    wire [12:0] pixel_index;
//    reg [15:0] oled_data = 0;
//    wire frame_begin, sending_pixels, sample_pixel;
    wire [7:0] x, y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
//    wire clk625, clk1, clk10;
    
//    flexible_clock clock6p25m (CLOCK, 7, clk625);
//    flexible_clock clock1 (CLOCK, 49999_999, direction);
//    flexible_clock clock10 (CLOCK, 4_999_999, clk10);
    
    
//    Oled_Display display (.clk(clk625), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
//     .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JB[0]), .sdin(JB[1]), 
//     .sclk(JB[3]), .d_cn(JB[4]), .resn(JB[5]), .vccen(JB[6]), .pmoden(JB[7]));

    always @ (posedge CLOCK)
    begin
          if (is_active)
          begin
             if (direction == 0) // facing left
             begin
                if ((x == x_ref && y <= y_ref + 1 && y >= y_ref - 1) || ((y == y_ref - 1 || y == y_ref + 1) && x <= x_ref - 2 && x >= x_ref - 5) || (y == y_ref && (x == x_ref - 1 || x == x_ref - 2 || (x <= x_ref - 5 && x >= x_ref - 7))))
                begin
                    oled_data = BLACK;
                end else if (y == y_ref && (x == x_ref - 3 || x == x_ref - 4))
                begin 
                    oled_data = TEAL;
                end
             end else if (direction == 1) // facing right
             begin
                if ((x == x_ref && y <= y_ref + 1 && y >= y_ref - 1) || ((y == y_ref - 1 || y == y_ref + 1) && x >= x_ref + 2 && x <= x_ref + 5) || (y == y_ref && (x == x_ref + 1 || x == x_ref + 2 || (x >= x_ref + 5 && x <= x_ref + 7))))
                begin
                    oled_data = BLACK;
                end else if (y == y_ref && (x == x_ref + 3 || x == x_ref + 4))
                begin 
                    oled_data = TEAL;
                end
             end
          end
      end
endmodule
