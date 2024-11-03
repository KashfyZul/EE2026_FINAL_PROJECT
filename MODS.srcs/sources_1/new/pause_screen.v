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


module pause_screen (    
    input CLOCK,
    input btnU, btnD, btnR,
    input [12:0] pixel_index,
    input [3:0] screen_state,
    output reg [15:0] oled_data,
    output reg [3:0] pause_back_screen = 0 
    // 0: nothing; 1: back to game; 2: back to main menu
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
        $readmemh("pause_screen.mem", memory);
    end

    always @ (posedge clk1000) // for debouncing of buttons
    begin
        if (screen_state == 4) 
        begin
            if (counter != 32'hFFFFFFFF) counter <= counter + 1; // prevents counter overflow
                    
            if (counter >= 200)
            begin           
                case (state)
                    0: begin // back to game
                        if (btnD) state <= 1; // cursor move down
                        else if (btnR) pause_back_screen <= 1;
                    end
                    1: begin // backk to main menu
                        if (btnU) state <= 0; // cursor move up
                        else if (btnR) pause_back_screen <= 2; 
                    end
                endcase 
            end
            
            if (btnU || btnD) counter <= 0;
            
        end else 
        begin
            // this screen is not being displayed --> reset variables
            counter <= 0;
            state <= 0;
            pause_back_screen <= 0;
        end      
    end    
    
    always @ (posedge CLOCK)
    begin        
    
        oled_data = memory[pixel_index];
        
        if (state == 0 && clk1 == 1) begin
            if (((x >= 16 && x <= 78 ) && (y == 18 || y == 30)) || ((x == 16 || x == 78) && (y >= 18 && y <= 30)))
            begin
                oled_data = 116'hF800; // RED RECTANGLE
            end 
        end else if (state == 1 && clk1 == 1) begin
            if (((x >= 23 && x <= 72 ) && (y == 38 || y == 50)) || ((x == 23 || x == 72) && (y >= 38 && y <= 50)))
            begin
                oled_data =  16'hF800; // RED RECTANGLE
            end
        end
    end
endmodule
