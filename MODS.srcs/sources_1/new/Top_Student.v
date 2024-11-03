`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

// laser: F21A(light red) middle F10C(dark red)

module Top_Student (    
    input CLOCK,
    input btnU, btnD, btnC, btnR, btnL,
    output [3:0] an,
    output [6:0] seg,
    output [7:0] JC  
);

    localparam CREDITS_SCREEN  = 0;
    localparam MAIN_MENU_SCREEN = 1;
    localparam CHARACTER_SCREEN = 2;
    localparam GAME_SCREEN = 3;
    localparam PAUSE_SCREEN = 4;
     
    wire [12:0] pixel_index;
    reg [15:0] oled_data;
    wire [15:0] oled_data0, oled_data1, oled_data2, oled_data3, oled_data4;
    wire frame_begin, sending_pixels, sample_pixel;
    
    wire credits_next_screen, character_next_screen;
    wire [2:0] main_next_screen, pause_next_screen;
    reg [3:0] screen_state = 2; // which screen should i use (ie main or credits)
       
    wire clk625, clk1;
    flexible_clock clock6p25m (CLOCK, 7, clk625);
    flexible_clock clock1 (CLOCK, 49_999_999, clk1);
    reg [31:0] seg_counter = 0;
    
    Oled_Display display (.clk(clk625), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
     .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), 
     .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));    
    
    credits_screen screen0 (CLOCK, btnD, btnR, pixel_index, screen_state, oled_data0, credits_next_screen);
    main_menu_screen screen1 (CLOCK, btnU, btnD, btnR, pixel_index, screen_state, oled_data1, main_next_screen);
    character_screen screen2 (CLOCK, btnU, btnD, btnL, btnR, pixel_index, screen_state, oled_data2, character_next_screen);
// game_screen screen3 (CLOCK, btnU, btnD, btnL, btnR, pixel_index, screen_state, oled_data3, game_next_screen);
    pause_screen screen4 (CLOCK, btnU, btnD, btnR, pixel_index, screen_state, oled_data4, pause_next_screen);
    
    seven_seg_display dis (seg_counter, CLOCK, an, seg);

    always @ (posedge clk1) 
    begin
        seg_counter <= seg_counter + 1;
    end

    always @ (posedge CLOCK) 
    begin
            
        if (screen_state == CREDITS_SCREEN)
        begin
        
            oled_data <= oled_data0;
            if (credits_next_screen) screen_state <= MAIN_MENU_SCREEN;
            
        end else if (screen_state == MAIN_MENU_SCREEN) 
        begin
        
            oled_data <= oled_data1;
            if (main_next_screen == 1) screen_state <= GAME_SCREEN;
            else if (main_next_screen == 2) screen_state <= CHARACTER_SCREEN;
            else if (main_next_screen == 3) screen_state <= CREDITS_SCREEN;
        
        end else if (screen_state == CHARACTER_SCREEN) 
        begin
        
            oled_data <= oled_data2;
            if (character_next_screen) screen_state <= MAIN_MENU_SCREEN;
            
        end
//        else if (screen_state == GAME_SCREEN) oled_data <= oled_data3;
        else if (screen_state == PAUSE_SCREEN) oled_data <= oled_data4;
    end           
endmodule
