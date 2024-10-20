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
output reg [7:0] xref [0: MAX_NUM_ENEMIES - 1]  , output reg [7:0] yref [0: MAX_NUM_ENEMIES - 1]);
    wire normalhz; wire fasthz;
    reg [0:MAX_NUM_ENEMIES - 1] direction = 0; //0: left 1: right
    flexy_clk drop_clk (clk, 499_999, normalhz); //249_999
    flexy_clk fast_clk (clk, 49, fasthz); //249_999
    integer i;
    
    initial begin 
        for (i = 0; i < MAX_NUM_ENEMIES; i = i + 1) begin
           xref[i] = 15;  // spawn location
           yref[i] = 0;
           direction[i] = {$random} % 2;
        end 
    end
    always @(posedge normalhz) begin //need to implement gravity
        for (i = 0; i < MAX_NUM_ENEMIES; i = i + 1) begin
            if (activated_enemy[i] != 0) begin // need to put in the not dropping through platform 
                if (yref[i] < 63 - size) begin
                    yref[i] <= yref[i] + 1;
                end
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
