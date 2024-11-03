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


module Top_Student (
    input clk, btnC, btnL, btnR, btnD, btnU, [4:0]sw,  
    output [7:0]JC, [2:0]led, [6:0]seg, [3:0]an
    );
    
parameter NUM_PLATFORMS = 4;    
parameter MAX_ENEMIES = 14;

// 3.A3: oled_data initialisation
//reg [15:0] oled_data;
wire [15:0] oled_data;
reg [15:0] oled_data_reg;
// for x and y coordinates of OLED
wire [6:0] x;
wire [6:0] y;
wire [6:0] x_var;
wire [6:0] y_var;
wire [6:0] x_var2;
wire [6:0] y_var2;
wire [6:0] x_muff;
wire [6:0] y_muff;
wire [6:0] x_proj1;
wire [6:0] y_proj1;
wire [6:0] x_proj2;
wire [6:0] y_proj2;
wire [6:0] x_platform [0:NUM_PLATFORMS];
assign x_platform[0] = 0; assign x_platform[1] = 32; assign x_platform[2] = 74; assign x_platform[3] = 35;  
wire [6:0] y_platform [0:NUM_PLATFORMS];
assign y_platform[0] = 36; assign y_platform[1] = 18; assign y_platform[2] = 36; assign y_platform[3] = 58;
wire [6:0] width_platform [0:NUM_PLATFORMS];
assign width_platform[0] = 28; assign width_platform[1] = 32; assign width_platform[2] = 21; assign width_platform[3] = 32;
wire [6:0] height_platform [0:NUM_PLATFORMS];
assign height_platform[0] = 3; assign height_platform[1] = 3; assign height_platform[2] = 3; assign height_platform[3] = 3;



wire [6:0]enemy_xref [0:MAX_ENEMIES];
assign enemy_xref[0] = x_var2;
assign enemy_xref[1] = x_var2;
assign enemy_xref[2] = x_var2;
assign enemy_xref[3] = x_var2;
assign enemy_xref[4] = x_var2;
assign enemy_xref[5] = x_var2;
assign enemy_xref[6] = x_var2;
assign enemy_xref[7] = x_var2;
assign enemy_xref[8] = x_var2;
assign enemy_xref[9] = x_var2;
assign enemy_xref[10] = x_var2;
assign enemy_xref[11] = x_var2;
assign enemy_xref[12] = x_var2;
assign enemy_xref[13] = x_var2;
assign enemy_xref[14] = x_var2;
wire [6:0]enemy_yref [0:MAX_ENEMIES];
assign enemy_yref[0] = y_var2;
assign enemy_yref[1] = y_var2;
assign enemy_yref[2] = y_var2;
assign enemy_yref[3] = y_var2;
assign enemy_yref[4] = y_var2;
assign enemy_yref[5] = y_var2;
assign enemy_yref[6] = y_var2;
assign enemy_yref[7] = y_var2;
assign enemy_yref[8] = y_var2;
assign enemy_yref[9] = y_var2;
assign enemy_yref[10] = y_var2;
assign enemy_yref[11] = y_var2;
assign enemy_yref[12] = y_var2;
assign enemy_yref[13] = y_var2;
assign enemy_yref[14] = y_var2;


wire reset;

assign reset = btnC;


wire frame_begin, sending_pixels, sample_pixels;
wire [12:0] pixel_index;
//reg [15:0] oled_colour;

initial begin
    oled_data_reg = 0;
//    oled_colour = 16'b00000_111111_00000;
end

//assign oled_data = oled_data_reg;

// convert pixel_index to coordinates
assign x = pixel_index % 96;
assign y = pixel_index / 96;

/*            
3.A2: instantiate clock divider module
    inputs: basys clock, m_value (the count limit of the clock)
    output: 6.25 MHz wire
*/
wire clk6p25m;
flexy_clock clk_6p25MHz (.clk(clk), .m_value(7), .slow_clk(clk6p25m));
//wire clk25m;
//flexy_clock clk_25MHz (.clk(clk), .m_value(7), .slow_clk(clk25m));

// use pushbuttons to choose direction
wire [6:0]x_vect;
wire [6:0]y_vect;
wire is_y_stat;
wire facing;
direction_mux choose_direction (.clk(clk), .btnC(btnC), .btnL(btnL), .btnR(btnR), .btnD(btnD), .btnU(btnU), .is_y_stat(is_y_stat), .x_vect(x_vect), .y_vect(y_vect), .facing(facing));

// animate the movement of the square
wire [15:0]center_sq_colour;
wire [6:0] x_spawn = 48;
wire [6:0] y_spawn = 0;
wire [3:0] hitbox_size = 8; 
wire [3:0] sprite_no;

// track damage of player (3 lives)
wire hero_hit;
wire hit_muff;
wire [31:0] muff_count;
wire [2:0]char_no;
hero_damage(.clk(clk), .hit(hero_hit), .reset(reset), .LED(led));
touch_muff(.clk(clk), .hit_muff(hit_muff), .start_muff(0), .reset(reset), .char_no(char_no), .muff_count(muff_count));

animate animate_hero (.clk(clk), 
        .x_start(84), .y_start(0), .x_vect(x_vect), .y_vect(y_vect), .sq_width(hitbox_size), .sq_height(hitbox_size),
        .enemy_xref(enemy_xref), .enemy_yref(enemy_yref),
        .x_platform(x_platform), .y_platform(y_platform), .width_platform(width_platform), .height_platform(height_platform), 
        .reset(reset),
        .x_var(x_var), .y_var(y_var), .center_sq_colour(center_sq_colour), .is_y_stat(is_y_stat), .sprite_no(sprite_no), .hero_hit(hero_hit));



wire proj_move;
wire proj_hit_enemy;
wire [6:0]proj_width;
wire [6:0]proj_height;
//wire [6:0]new_proj_width;
// animate movement of projectile
projectile_animate animate_projectile (.clk(clk), .btnD(btnD), 
        .x_ref(x_var), .y_ref(y_var), .x_vect(x_vect), .y_vect(y_vect), .sq_width(hitbox_size), .sq_height(hitbox_size),
        .char_no(char_no),
        .x_platform(x_platform), .y_platform(y_platform), .width_platform(width_platform), .height_platform(height_platform), 
        .reset(reset),
        .x_varA(x_proj1), .y_varA(y_proj1), .x_varB(x_proj2), .y_varB(y_proj2), .proj_width(proj_width), .proj_height(proj_height), .proj_move(proj_move), .proj_hit_enemy(proj_hit_enemy)
);

// animate the enemy (for test)
enimate animate_enemy (.clk(clk), 
        .x_start(40), .y_start(0), .x_vect(127), .y_vect(1), .sq_width(hitbox_size), .sq_height(hitbox_size),
//        .x_start(80), .y_start(0), .x_vect(0), .y_vect(1), .sq_width(hitbox_size), .sq_height(hitbox_size),
        .x_hero(x_var), .y_hero(y_var), .width_hero(8), .height_hero(8),
//        .fps(20), .stat_colour(16'b11111_000000_00000), .move_colour(16'b11100_001111_00000), .jump_colour(16'b11111_000000_11000), 
        .x_platform1(x_platform[0]), .y_platform1(y_platform[0]), .width_platform1(width_platform[0]), .height_platform1(height_platform[0]),
        .x_platform2(x_platform[1]), .y_platform2(y_platform[1]), .width_platform2(width_platform[1]), .height_platform2(height_platform[1]), 
        .x_platform3(x_platform[2]), .y_platform3(y_platform[2]), .width_platform3(width_platform[2]), .height_platform3(height_platform[2]),
        .x_platform4(x_platform[3]), .y_platform4(y_platform[3]), .width_platform4(width_platform[3]), .height_platform4(height_platform[3]), 
        .reset(reset),
        .x_var(x_var2), .y_var(y_var2), .center_sq_colour(center_sq_colour));


// animate the muffin (for test)
muffinimate2 animate_muffin (.clk(clk),
        .x_start(40), .y_start(0), .x_vect(0), .y_vect(1), .sq_width(hitbox_size), .sq_height(hitbox_size), 
//        .x_vect(0), .y_vect(1), .sq_width(hitbox_size), .sq_height(hitbox_size),
        .x_hero(x_var), .y_hero(y_var), .width_hero(8), .height_hero(8),
//        .x_hero(90), .y_hero(90), .width_hero(8), .height_hero(8),
//        .x_platform(x_platform), .y_platform(y_platform), .width_platform(width_platform), .height_platform(height_platform),
//        .x_platform1(x_platform[0]), .y_platform1(y_platform[0]), .width_platform1(width_platform[0]), .height_platform1(height_platform[0]),
//        .x_platform2(x_platform[1]), .y_platform2(y_platform[1]), .width_platform2(width_platform[1]), .height_platform2(height_platform[1]), 
//        .x_platform3(x_platform[2]), .y_platform3(y_platform[2]), .width_platform3(width_platform[2]), .height_platform3(height_platform[2]),
//        .x_platform4(x_platform[3]), .y_platform4(y_platform[3]), .width_platform4(width_platform[3]), .height_platform4(height_platform[3]),
        .x_platform(x_platform), .y_platform(y_platform), .width_platform(width_platform), .height_platform(height_platform), 
        .reset(reset),
        .x_var(x_muff), .y_var(y_muff), .center_sq_colour(center_sq_colour), .hit_muff(hit_muff));


// draw the squares
make_square draw_sq (.clk(clk), .x(x), .y(y), .x_vect(x_vect), .y_vect(y_vect), .facing(facing), .sprite_no(sprite_no), .char_no(char_no), .proj_move(proj_move),
        .x_val(x_var), .y_val(y_var), .sq_width(8),.sq_height(8), .sq_colour(center_sq_colour),
        .enemy_xref(enemy_xref), .enemy_yref(enemy_yref), .sq_width2(8), .sq_height2(8), .sq_colour2(center_sq_colour),
        .x_muff(x_muff), .y_muff(y_muff), .sq_width3(8), .sq_height3(8), .sq_colour3(center_sq_colour),
//        .x_muff(0), .y_muff(0), .sq_width3(8), .sq_height3(8), .sq_colour3(center_sq_colour),
        .x_proj1(x_proj1), .y_proj1(y_proj1), .x_proj2(x_proj2), .y_proj2(y_proj2), .proj_width(proj_width), .proj_height(proj_height), .proj_colour(center_sq_colour),
//        .x_platform1(30), .y_platform1(40), .width_platform1(25), .height_platform1(5),
//        .x_platform2(55), .y_platform2(20), .width_platform2(25), .height_platform2(5), 
//        .x_platform3(0), .y_platform3(58), .width_platform3(39), .height_platform3(5),
//        .x_platform4(55), .y_platform4(58), .width_platform4(39), .height_platform4(5),
        .x_platform(x_platform), .y_platform(y_platform), .width_platform(width_platform), .height_platform(height_platform),
        .platform_colour(16'b00000_111111_00000), .bg_colour(0), .oled_data(oled_data));
        
seven_seg_display2 display (.n(muff_count), .CLOCK(clk), .an(an), .seg(seg));        

// 3.A1: instantiate Oled_Display
Oled_Display Q3A1 (.clk(clk6p25m), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
  .sample_pixel(sample_pixels) , .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), 
  .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));

//wire left;
//wire right;
//wire middle;
//wire new_event;
//wire [11:0]xpos, ypos;
//wire [3:0]zpos;
//wire ps2_clk;
//wire ps2_data;

//assign led[15] = left;
//assign led[14] = middle;
//assign led[13] = right;

//// Mouse code
//MouseCtl meowse (.clk(clk), .rst(0), .xpos(xpos), .ypos(ypos), .zpos(zpos), 
//.left(left), .middle(middle), .right(right), .new_event(new_event), .value(0), 
//.setx(0), .sety(0), .setmax_x(0), .setmax_y(0), .ps2_clk(), .ps2_data());



endmodule