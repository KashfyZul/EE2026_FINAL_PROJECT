`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2024 09:16:30 AM
// Design Name: 
// Module Name: character_screen 
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


module character_screen (    
    input CLOCK,
    input btnU, btnD, btnL, btnR,
    input [12:0] pixel_index,
    input [3:0] screen_state,
    output reg [15:0] oled_data,
    output reg next_screen = 0
);

    wire [7:0] x, y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    wire clk1, clk1000;
    flexible_clock clock1 (CLOCK, 49_999_999, clk1);
    flexible_clock clock1k (CLOCK, 49_999, clk1000);
    
    reg [3:0] button_state = 0;
    // 0-4: CE, EE, Math, Med, BZ
    reg [3:0] display_state = 0; 
    // chooses which screen to display
    // 0: character select
    // 1: character info
           
    reg [31:0] counter = 0; // counter for preventing debouncing
        
    reg [15:0] memory [0:6143]; //memory for 96x64 image of characater screen
    reg [15:0] memory1 [0:2783]; // memory for 96x29 image of character select text
    
    reg [15:0] mem_ce [0:2495]; // memories for 96x26 images of character text descriptions
    reg [15:0] mem_ee [0:2495];
    reg [15:0] mem_math [0:2495];
    reg [15:0] mem_med [0:2495];
    reg [15:0] mem_bz [0:2495];
    
    
    // CE student
    // EE student
    // Math student
    // Medicine student
    // Business student
            
    initial begin
        $readmemh("character.mem", memory);
        $readmemh("select_char_text.mem", memory1);
        
        $readmemh("chem_char_text.mem", mem_ce);
        $readmemh("ee_char_text.mem", mem_ee);
        $readmemh("math_char_text.mem", mem_math);
        $readmemh("medicine_char_text.mem", mem_med);
        $readmemh("bz_char_text.mem", mem_bz);        
    end
    
    always @ (posedge clk1000) // for debouncing and function of buttons
    begin
        if (screen_state == 2)
        begin
            if (counter != 32'hFFFFFFFF) counter <= counter + 1; // prevents counter overflow
                    
            if (counter >= 200)
            begin            
                if (display_state == 0) 
                begin
                    if (button_state >= 0 && button_state <= 3 && btnD) 
                        button_state <= button_state + 1;
                    else if (button_state >= 1 && button_state <= 4 && btnU) 
                        button_state <= button_state - 1;
                        
                    if (btnL) next_screen <= 1;
                    if (btnR) display_state <= 1;             
                    
                end else if (display_state == 1 && btnL) 
                    display_state <= 0;
            end
            
            if (btnU || btnD || btnR || btnL) counter <= 0;            
        end else
        begin
            // this screen is not being displayed --> reset variables
            display_state <= 0;
            button_state <= 0;
            counter <= 0;
            next_screen <= 0;
        end                       
    end    
        
    always @ (posedge CLOCK)
    begin                
            
        oled_data <= memory[pixel_index];
        
        if (display_state == 0) // character select
        begin
            if (pixel_index >= 1632 && pixel_index <= 4415) // display text
                oled_data <= memory1[pixel_index - 1632];
           
            if (clk1) // controls white arrows
            begin
                case (button_state)
                    0: begin
                        if ((x == 6 && y >= 18 && y <= 22) || 
                            (x == 7 && y >= 19 && y <= 21) || 
                            (x == 8 && y == 20))
                        begin
                            oled_data <= 16'b1111111111111111;
                        end
                    end
                    1: begin
                        if ((x == 6 && y >= 24 && y <= 28) || 
                            (x == 7 && y >= 25 && y <= 27) || 
                            (x == 8 && y == 26))
                        begin
                            oled_data <= 16'b1111111111111111;
                        end
                    end
                    2: begin
                        if ((x == 6 && y >= 30 && y <= 34) || 
                            (x == 7 && y >= 31 && y <= 33) || 
                            (x == 8 && y == 32))
                        begin
                            oled_data <= 16'b1111111111111111;
                        end                
                    end
                    3: begin
                        if ((x == 6 && y >= 36 && y <= 40) || 
                            (x == 7 && y >= 37 && y <= 39) || 
                            (x == 8 && y == 38))
                        begin
                            oled_data <= 16'b1111111111111111;
                        end                
                    end
                    4: begin
                        if ((x == 6 && y >= 42 && y <= 46) || 
                            (x == 7 && y >= 43 && y <= 45) || 
                            (x == 8 && y == 44))
                        begin
                            oled_data <= 16'b1111111111111111;
                        end                
                    end
                endcase
            end
            
        end else if (display_state == 1) // character info
        begin
            if (pixel_index >= 1344 && pixel_index <= 3839)
            begin
                case(button_state)
                    0: oled_data <= mem_ce[pixel_index - 1344];
                    1: oled_data <= mem_ee[pixel_index - 1344];
                    2: oled_data <= mem_math[pixel_index - 1344];
                    3: oled_data <= mem_med[pixel_index - 1344];
                    4: oled_data <= mem_bz[pixel_index - 1344];
                endcase                
            end           
        end
        
//        case (button_state)
//            0: // draw CE + POISON
//            1: // draw EE + LIGHTNING
//            2: // draw MATH + "+"
//            3: // draw MED + PILL
//            4: // draw BZ + MONEY
//        endcase
        
    end
endmodule

