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
    integer i;
    wire [6:0] x, y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    localparam [6:0] x_ref = 58;
    localparam [6:0] y_ref = 42;    
    
    wire clk1, clk1000;
    flexible_clock clock1 (CLOCK, 49_999_999, clk1);
    flexible_clock clock1k (CLOCK, 49_999, clk1000);
    
    reg [3:0] button_state = 0;
    reg [2:0] char_no = 0;
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
    
    wire enemyprojclk;
    flexible_clock interactionclk (CLOCK, 624_999, enemyprojclk); //624_999
    wire fps_clock;
    flexible_clock get_fps_clock (CLOCK, 1_249_999, fps_clock); //1_249_999
    
    wire [6:0] platform_x [0:0];
    assign platform_x[0] = 0;
    wire [6:0] platform_y [0:0];
    assign platform_y[0] = 50;
    wire [6:0] platform_width [0:0];
    assign platform_width[0] = 96;
    wire [6:0] platform_height [0:0];
    assign platform_height[0] = 0;
    
    wire [6:0]enemy_xref[0:0];  wire [6:0]enemy_yref [0:0];
    assign enemy_xref[0] = 127; assign enemy_yref[0] = 127;
    wire [2:0] proj_d; wire [15:0] enemy_hit;
    wire [6:0] proj_x [0:5]; wire [6:0] proj_y [0:5]; 
    wire [2:0] proj_h; wire [6:0] proj_w; wire [5:0]active_proj;

    projectile_main  #(.MAX_ENEMIES(0), .NUM_PLATFORMS(0)) projectiles
            (.clk(enemyprojclk), .btnD(1), .reset(btnR), .fps_clock(fps_clock),
            .char_x(x_ref), .char_y(y_ref), .char_xvect(1), .char_width(8), .char_height(8), .proj_type(char_no),
            .platform_x(platform_x), .platform_y(platform_y), .platform_h(platform_height), .platform_w(platform_width),
            .enemy_x(enemy_xref), .enemy_y(enemy_yref), .enemy_hit(enemy_hit), .proj_d(proj_d),
              .proj_x(proj_x), .proj_y(proj_y), .proj_h(proj_h), .proj_w(proj_w), 
              .active(active_proj));
              
    wire [15:0] s_oled;
    student_sprites asdf (x, y, CLOCK, btnU, btnL, btnR, 1, 0, x_ref, y_ref, char_no, s_oled);    
    wire [15:0] p_oled;
    projectiles_sprite spr (CLOCK, x, y, char_no, 0, active_proj, proj_x, proj_y, p_oled);
    
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
        
    always @ (button_state)
    begin
        // s1: medicine, s2: chemistry, s3: electrical engineering, s4: math, s5: business
        // 0-4: CE, EE, Math, Med, BZ
        case (button_state)
            0: char_no = 1;
            1: char_no = 2;
            2: char_no = 3;
            3: char_no = 0;
            4: char_no = 4;
        endcase
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
            
            if (x <= x_ref + 7 && x >= x_ref && y <= y_ref + 7 && y >= y_ref) begin
                if (s_oled != 1) oled_data <= s_oled;
            end     
            
            for (i = 0; i <= 5; i = i + 1) begin
                if (p_oled != 1) oled_data <= p_oled;
            end       
            
        end
    end
endmodule

