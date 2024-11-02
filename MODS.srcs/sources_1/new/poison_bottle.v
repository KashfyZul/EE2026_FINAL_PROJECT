`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2024 02:56:54 PM
// Design Name: 
// Module Name: poison_bottle
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


module poison_bottle(
    input CLOCK, btnD,
    [6:0]x_ref, [6:0]y_ref, [6:0]x_vect, [6:0]y_vect, [6:0]sq_width, [6:0]sq_height, 
        
    [6:0]x_platform1, [6:0]y_platform1, [6:0]width_platform1, [6:0]height_platform1,
    [6:0]x_platform2, [6:0]y_platform2, [6:0]width_platform2, [6:0]height_platform2,
    reset,
    output reg [6:0]x_var, reg [6:0]y_var, reg [6:0]proj_width, reg [6:0]proj_height, reg proj_move, reg proj_hit_enemy
);
    
    // x_ref and y_ref: coordinates of player
    // x_vect and y_vect: direction player moving in 
    // sq_width and sq_height: height of player
    // char_no: current player selected
    // x_var and y_var: coordinates of projectile
    
    wire [6:0] launchpt_x_left;
    wire [6:0] launchpt_x_right;
    wire [6:0] launchpt_y;
    reg [6:0] launch_x; // starting pts for projectile launch
    reg [6:0] launch_y;
    reg [6:0] y_increment;
    reg is_active;
    
    initial 
    begin
        y_increment = 0;
        proj_move = 0;
        proj_width = 5;
        proj_height = 5;
        is_active = 0;
    end
    
    assign launchpt_x_left = x_ref - proj_width;
    assign launchpt_x_right = x_ref + sq_width;
    assign launchpt_y = y_ref + ((sq_height - proj_height) / 2);
    
    wire fps_clock;
    flexible_clock get_fps_clock ((CLOCK), (624_999), (fps_clock));
    wire fps_clock2;
    flexible_clock get_fps_clock2 ((CLOCK), (1_249_999), (fps_clock2));
    
    reg start = 0;
    reg [31:0] falling;
    reg stop_falling; // A flag indicating whether the muffin has landed on a surface
    
    always @ (posedge fps_clock2)
    begin
    
        if (is_active == 0) begin
            x_var = x_ref;
            y_var = y_ref;
            stop_falling = 1;            
        end
    
        if (start) 
        begin
            if (x_vect == 1) begin // facing right, launch from right
                x_var = launchpt_x_right; // starting point for projectile
            end else if (x_vect == 127) begin // facing left, launch from left
                x_var = launchpt_x_left; // starting point for projectile
            end
            
            y_var = launchpt_y;
            
            y_increment = 0;
            stop_falling = 0;
            falling = 0;
            
            start = 0;            
        end
        
        if (!stop_falling) begin 
            if (falling < 64) y_increment = 1 + falling / 3; 
            
            falling = falling + 1; // falling counter will count continuously, will reset when y is stationary             
           
            // check lower bound of screen
            if (y_var + proj_height - 1 == 63 && (falling >= 0 && falling < 64)) begin
                y_increment = 0;
            // check upper bound of platform1
            end else if ((y_var + proj_height == y_platform1) && (x_var + proj_width > x_platform1 && x_var - 1 < x_platform1 + width_platform1) && (falling >= 0 && falling < 64)) begin 
                y_increment = 0;
            // check upper bound of platform2
            end else if ((y_var + proj_height == y_platform2) && (x_var + proj_width > x_platform2 && x_var - 1 < x_platform2 + width_platform2) && (falling >= 0 && falling < 64)) begin 
                y_increment = 0;           
            end           
    
            y_var = y_var + y_increment;
            
            if (y_increment == 0) begin
                stop_falling = 1;
            end
        end       
    end
    
    always @ (posedge fps_clock) 
    begin
        if (btnD) 
        begin
            is_active = 1;
            start = 1;
        end
        
        if (reset) 
        begin
            is_active = 0;
            start = 0;
        end

        proj_move = is_active ? 1 : 0;
    end   
endmodule
