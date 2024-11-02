`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2024 01:00:05 AM
// Design Name: 
// Module Name: main_menu_screen
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


module main_menu_screen (    
    input CLOCK,
    input btnU, btnD, btnR,
    input [12:0] pixel_index,
    input [3:0] screen_state,
    output reg [15:0] oled_data,
    output reg [3:0] next_screen = 0
);

    wire [7:0] x, y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    reg [31:0] x_ref = 0;
    
    wire clk625, clk1000, clk1, clk5;
    reg [1:0] state = 0; // state of main screen (ie where the arrows are)
    reg [31:0] counter = 0; // counter for preventing debouncing
    
    flexible_clock clock1k (CLOCK, 49_999, clk1000);
    flexible_clock clock1 (CLOCK, 49_999_999, clk1);
    flexible_clock clock5 (CLOCK, 9_999_999, clk5);
    
    reg [15:0] memory [0:6143]; // memory for a 96x64 image of main screen
    reg [15:0] memory2 [0:3399]; // memory for a 200x17 image of main screen sky (to animate) 
    
    initial begin
        $readmemh("main_menu.mem", memory);
        $readmemh("main_menu_top.mem", memory2);
    end

    always @ (posedge clk1000) // for debouncing of buttons
    begin
        if (screen_state == 1) 
        begin
            if (counter != 32'hFFFFFFFF) counter <= counter + 1; // prevents counter overflow
                    
            if (counter >= 200)
            begin           
                case (state)
                    0: begin // PLAY
                        if (btnD) state <= 1; // cursor move down
//                        else if (btnR) next_screen <= 1; // change to play screen (or start game immediately)
                    end
                    1: begin // CHARACTERS
                        if (btnD) state <= 2; // cursor move down
                        else if (btnU) state <= 0; // cursor move up
                        else if (btnR) next_screen <= 2; // change to Character screen
                    end
                    2: begin // CREDITS
                        if (btnU) state <= 1; // cursor move up
                        else if (btnR) next_screen <= 3; // change to credits screen
                    end
                endcase 
            end
            
            if (btnU || btnD) counter <= 0;
            
        end else 
        begin
            // this screen is not being displayed --> reset variables
            counter <= 0;
            state <= 0;
            next_screen <= 0;
        end      
    end
    
    always @ (posedge clk5) 
    begin
        x_ref <= (x_ref == 199) ? 0 : x_ref + 1; // for animation of main screen sky
    end
    
    
    always @ (posedge CLOCK)
    begin        
    
        oled_data = memory[pixel_index];
        
        if (pixel_index < 1632) oled_data = memory2[y * 200 + ((x + x_ref) % 200)]; // for animation of main screen sky

        if (state == 0 && clk1 == 1) begin
            if ((x == 19 && y >= 26 && y <= 30) || 
                (x == 20 && y >= 27 && y <= 29) || 
                (x == 21 && y == 28))
            begin
                oled_data =  16'b1111111111111111;
            end
        end else if (state == 1 && clk1 == 1) begin
            if ((x == 19 && y >= 35 && y <= 39) || 
                (x == 20 && y >= 36 && y <= 38) || 
                (x == 21 && y == 37))
            begin
                oled_data =  16'b1111111111111111;
            end
        end else if (state == 2 && clk1 == 1) begin
            if ((x == 19 && y >= 44 && y <= 48) || 
                (x == 20 && y >= 45 && y <= 47) || 
                (x == 21 && y == 46))
            begin
                oled_data =  16'b1111111111111111;
            end        
        end
    end
endmodule
