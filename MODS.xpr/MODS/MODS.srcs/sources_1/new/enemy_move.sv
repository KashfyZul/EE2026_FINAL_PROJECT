`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2024 16:59:30
// Design Name: 
// Module Name: enemy_move
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



module enemy_movement #(parameter MAX_NUM_ENEMIES = 15, parameter size = 8)
(input clk, input [7:0]spawn1,  input [7:0]spawn2, input[3:0]activated_enemy [0: MAX_NUM_ENEMIES - 1], 
input [7:0] platform_width, input [7:0] x_obs, input [7:0] y_obs,
output reg [7:0] xref [0: MAX_NUM_ENEMIES - 1]  , output reg [7:0] yref [0: MAX_NUM_ENEMIES - 1]);
    wire normalhz; wire fasthz; wire fps_clock;
    reg [0:MAX_NUM_ENEMIES - 1] direction; //0: left 1: right
    reg [6:0] y_increment [0:MAX_NUM_ENEMIES - 1];
    reg [31:0]falling [0:MAX_NUM_ENEMIES - 1];
    reg [0:MAX_NUM_ENEMIES - 1] is_falling = 0; //0 is true
    flexy_clk walk_clk (clk, 6_999_999, normalhz); //249_999
    flexy_clk fast_clk (clk, 49, fasthz); //249_999
    flexy_clk get_fps_clock (clk, 1_249_999, fps_clock);
    integer i;

    initial begin 
        for (i = 0; i < MAX_NUM_ENEMIES; i = i + 1) begin
           xref[i] <= 15;  // spawn location
           yref[i] <= 0;
           y_increment[i] <= 0;
           direction = (direction << 1) + ($random % 2); //random is not randoming....
        end 
    end
    
    always @(posedge fps_clock) begin //need to implement gravity       
        for (i = 0; i < MAX_NUM_ENEMIES; i = i + 1) begin
            falling[i] <= (is_falling[i]) ? falling[i] + 1 : 0; // falling counter will count continuously, will reset when y is stationary   
            if (activated_enemy[i] != 0) begin // need to put in the not dropping through platform 
                if ((yref[i] >= 63 - size)|| // the ground
                ((xref[i] <= x_obs + platform_width) &&  (xref[i] + size <= x_obs) && (yref[i] + size == y_obs))) begin //obstacle
                    y_increment[i] = 0;
                    is_falling[i] <= 0;
                end else begin 
                    is_falling[i] <= 1;
                    y_increment[i] = 1 + falling[i] / 3; 
                end 
                yref[i] <= (yref[i] + y_increment[i] <= 63 - size) ? yref[i] + y_increment[i] : 63 - size;
            end 
        end     
    end   
    
    always @(posedge normalhz) begin 
        for (i = 0; i < MAX_NUM_ENEMIES; i = i + 1) begin
            if (activated_enemy[i] != 0) begin // need to put in the not dropping through platform 
                if (xref[i] == 96 - size) begin
                    direction[i] = 0;
                end else if (xref[i] == 0) begin
                    direction[i] = 1;
                end
                
                if (direction[i] == 1) begin
                    xref[i] <= xref[i] + 1;
                end else begin 
                    xref[i] <= xref[i] - 1;
                end
            end 
        end
    end 
    

endmodule
