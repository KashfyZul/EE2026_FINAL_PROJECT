`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 07:45:34 AM
// Design Name: 
// Module Name: game_screen
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

module game_screen(
        input CLOCK, btnU, btnD, btnL, btnR, btnC,
        input [12:0] pixel_index,
        input [3:0] screen_state,
        output [15:0] oled_data,
        output reg [2:0] next_screen = 0, // 1: pause, 2: main_menu (died)
        output [6:0] seg, [3:0] an, [2:0] led, 
        input reset, 
        input pause
    );
    
    
    always @ (posedge CLOCK) // for debouncing of buttons
    begin     
        if (screen_state == 3) begin
            if (btnC) next_screen <= 1;
            if (led == 0) next_screen <= 2;
        end else next_screen <= 0;
    end
    
    main m (CLOCK, btnC, btnL, btnR, btnD, btnU, led, seg, an, pause, reset, pixel_index, oled_data);   
    
endmodule