`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2024 16:58:40
// Design Name: 
// Module Name: enemy_tracker
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


module draw_enemy #(parameter MAX_NUM_ENEMIES = 15, parameter size = 8)(input [12:0] p_index, 
input [3:0] activated_enemy [0:MAX_NUM_ENEMIES - 1], 
input [7:0] xref [0:MAX_NUM_ENEMIES - 1] , input [7:0] yref [0:MAX_NUM_ENEMIES - 1] ,
output reg [15:0] oled_data);
    integer i;
    wire [7:0]x = p_index % 96;
    wire [7:0]y = p_index / 96;
    initial begin 
        oled_data = 1;
    end
    always @(p_index) begin 
     oled_data <= 0;
     for (i = 0; i < MAX_NUM_ENEMIES; i = i + 1) begin
        if (activated_enemy[i] != 0) begin
            if (x >= (xref[i]) && x < (xref[i] + size) && y >= (yref[i]) && y < (yref[i] + size)) begin  // Set all elements to the same value
                oled_data <= (activated_enemy[i] <= 3) ? 16'h07E0: 16'h1F;
             end
        end 
     end
    end 
endmodule 

module spawn_enemy #(parameter MAX_ENEMIES = 15)(input trig_spawn, input clk, input [2:0]num_small, input [2:0]num_big,
output reg [3:0] activated_enemy [0:MAX_ENEMIES - 1]);
      // activated_enemy is the health 0: dead, 1-3: small 4-5 big; number + 5 = angry 
    wire spawnhz;
    flexy_clk half_clk (clk, 99_999_999, spawnhz); //249_999

    reg [3:0]spawned_small = 0;
    reg [3:0]spawned_big = 0;
    reg track_trig = 0;
    reg [3:0]total_enemies = 0;
    
    integer i; integer j;

    initial begin 
        for (i = 0; i < MAX_ENEMIES; i = i + 1) begin
           activated_enemy[i] = 0;
        end
        i = 0;
    end 
    
    always @(posedge spawnhz) begin 
        if (trig_spawn != track_trig) begin 
            spawned_small = 0;
            spawned_big = 0;
            track_trig <= trig_spawn;
        end     
        if (total_enemies < MAX_ENEMIES) begin
            if (spawned_small < num_small) begin 
                for (j = 0; j < MAX_ENEMIES && activated_enemy[i] != 0; j = j + 1) begin 
                    i = (i == MAX_ENEMIES - 1) ? 0 : i + 1;
                end
                activated_enemy[i] <= 3;
                spawned_small <= spawned_small + 1;
                total_enemies <= total_enemies + 1;

            end else if (spawned_big < num_big) begin  //spawns small before big
                for (j = 0; j < MAX_ENEMIES && activated_enemy[i] != 0; j = j + 1) begin 
                    i = (i == MAX_ENEMIES - 1) ? 0 : i + 1;
                end
                activated_enemy[i] <= 5;
                spawned_big <= spawned_big + 1;
                total_enemies <= total_enemies + 1;
            end 
            
        end
    end   
   
endmodule

module enemy_level(input clk, 
output reg [2:0]num_small, output reg [2:0]num_big, output reg trig_spawn);
    wire onehz;
    reg [4:0] level = 0;
    reg [3:0] count_s = 0;
    
    flexy_clk onehz_clk (clk, 49_999_999, onehz); //49_999_999
    initial begin
       num_small = 3;
       num_big = 1;
       trig_spawn = 0;
    end 
    
    always @(posedge onehz) begin 
        count_s <= count_s + 1;
        
        if (level == 0 && count_s == 1) begin 
            level <= level + 1;
            trig_spawn <= ~trig_spawn;
            count_s <= 0;
        end 
        else if (level == 1 && count_s == 10) begin 
            level <= level + 1;
            num_small <= num_small + 1;
            trig_spawn <= ~trig_spawn;
            count_s <= 0;
        end 
        
        else if (level == 2 && count_s == 9) begin
            level <= level + 1;
            num_big <= num_big + 1;
            trig_spawn <= ~trig_spawn;
            count_s <= 0;
        end 
        
        else if (level == 3 && count_s == 8) begin
            trig_spawn <= ~trig_spawn;
            level <= level + 1;
            count_s <= 0;
        end 
        
        else if (level == 4 && count_s == 6) begin
            trig_spawn <= ~trig_spawn;
            level <= level + 1;
            num_small <= num_small + 1;
            count_s <= 0;
        end 
        
        else if (level == 5 && count_s == 6) begin
            trig_spawn <= ~trig_spawn;
            level <= level + 1;
            num_small <= num_small + 1;
            count_s <= 0;
        end 
        
        else if (level == 6 && count_s == 5) begin
            trig_spawn <= ~trig_spawn;
            level <= level + 1;
            count_s <= 0;
        end 
        
        else if (level == 7 && count_s == 4) begin
            trig_spawn <= ~trig_spawn;
            level <= level + 1;
            num_small <= num_small + 1;
            count_s <= 0;
        end 
        
        else if (level == 8 && count_s == 3) begin
            trig_spawn <= ~trig_spawn;
            level <= level + 1;
            count_s <= 0;
        end 
        
        else if (level == 9 && count_s == 2) begin
            trig_spawn <= ~trig_spawn;
            level <= level + 1;
            num_big <= num_big + 1;
            count_s <= 0;
        end 
        
        else if (level == 10 && count_s == 2) begin
            trig_spawn <= ~trig_spawn;
            count_s <= 0;
        end
    end
endmodule