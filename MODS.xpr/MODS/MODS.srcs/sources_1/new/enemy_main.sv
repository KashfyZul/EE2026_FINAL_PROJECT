`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2024 00:14:51
// Design Name: 
// Module Name: enemy_main
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



module enemy_main(input BASYS_CLOCK, output [7:0] JB);
//    input btnC, btnL, btnR, btnU, btnD,
    parameter MAX_NUM_ENEMIES = 15; parameter enemy_size = 8;
    reg [7:0]enemy_spawn1 = 15; // x coordinate
    reg [7:0]enemy_spawn2 = 80; // x coordinate
    wire [2:0]num_small; wire [2:0]num_big; wire [15:0]oled_data_enemy;  
    wire [3:0] enemy_health [MAX_NUM_ENEMIES - 1:0]; wire [7:0]enemy_xref [MAX_NUM_ENEMIES - 1:0]; wire [7:0]enemy_yref [MAX_NUM_ENEMIES - 1:0];
    wire clk625; wire trigger_spawn;
    
    wire sending_pixels; wire sample_pixel; wire frame_begin; wire [12:0] pixel_index; 
    reg [15:0] oled_data = 16'b1111111111111111;
    
    
    //Oled 
    flexy_clk clk6p25m (BASYS_CLOCK, 7, clk625);
    Oled_Display display (.clk(clk625), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
.sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JB[0]), .sdin(JB[1]), 
.sclk(JB[3]), .d_cn(JB[4]), .resn(JB[5]), .vccen(JB[6]), .pmoden(JB[7])); 
    
    // Enemy stuff 
    enemy_level level (.clk(BASYS_CLOCK), .num_small(num_small), .num_big(num_big), .trig_spawn(trigger_spawn));
    
    spawn_enemy #(.MAX_ENEMIES(MAX_NUM_ENEMIES)) spwn(.trig_spawn(trigger_spawn), .clk(BASYS_CLOCK), 
        .num_small(num_small), .num_big(num_big), .activated_enemy(enemy_health));
    
    enemy_movement #(.MAX_NUM_ENEMIES(MAX_NUM_ENEMIES), .size(enemy_size)) move ( .clk(BASYS_CLOCK), .spawn1(enemy_spawn1),  .spawn2(enemy_spawn2), 
        .activated_enemy(enemy_health), .xref(enemy_xref), .yref(enemy_yref));
    
    draw_enemy #(.MAX_NUM_ENEMIES(MAX_NUM_ENEMIES), .size(enemy_size)) draw (.p_index(pixel_index), .activated_enemy(enemy_health), 
        .xref(enemy_xref), .yref(enemy_yref), .oled_data(oled_data_enemy));
    
    always @(posedge BASYS_CLOCK) begin 
        oled_data <= oled_data_enemy;
//        oled_data <= 16'b0000000000011111;   
    end
    
endmodule

