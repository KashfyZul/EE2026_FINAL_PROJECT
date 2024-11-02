`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2024 01:11:21 AM
// Design Name: 
// Module Name: credits_screen
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


module credits_screen (    
    input CLOCK,
    input btnD, btnR,
    input [12:0] pixel_index,
    input [3:0] screen_state,
    output reg [15:0] oled_data,
    output reg next_screen = 0
);

    reg [31:0] y_ref = 0;
    
    wire  clk1000;
    flexible_clock clock1k (CLOCK, 49_999, clk1000);
    
    reg [31:0] counter = 0; // counter for preventing debouncing
    reg btnR_pressed = 0;
    reg [31:0] scroll_counter = 0; // counter for scrolling down
       
    reg [15:0] credits_mem [0: 17279]; //memory for 96x180 image of credits screen
        
    initial begin
        $readmemh("credits.mem", credits_mem);
    end
    
    always @ (posedge clk1000) // for debouncing and function of buttons
        begin
            if (screen_state == 0)
            begin
                if (counter != 32'hFFFFFFFF) counter <= counter + 1; // prevents counter overflow
                        
                if (btnR && counter >= 200) 
                begin
                    next_screen <= 1;
                    counter <= 0;
                end            
                if (btnR) counter <= 0;       
                
                if (btnD) begin
                    if (y_ref < 113 && scroll_counter >= 100) y_ref <= y_ref + 1;
        
                    scroll_counter <= (scroll_counter >= 100) ? 0 : scroll_counter + 1;
                end
                     
            end else
            begin
                // this screen is not being displayed --> reset variables
                counter <= 0;
                y_ref <= 0;
                scroll_counter <= 0;
                next_screen <= 0;
            end                       
        end    
        
    always @ (posedge CLOCK)
    begin                
        oled_data <= credits_mem[pixel_index + (y_ref * 96)];                 
    end
    
endmodule
