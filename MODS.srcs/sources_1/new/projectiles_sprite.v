`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2024 02:38:30
// Design Name: 
// Module Name: projectiles_sprite
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


module projectiles_sprite #(parameter MAX_NUM_PROJECTILES = 5)(
    input clk,
    input [6:0] x, input [6:0] y,
    input [2:0] char_no,
    input faceleft,
    input [MAX_NUM_PROJECTILES:0] is_active,
    input [6:0] x_ref [0:MAX_NUM_PROJECTILES], input [6:0] y_ref [0:MAX_NUM_PROJECTILES],
    output reg [15:0] oled_data
    );
    
    localparam RED = 16'hF800;
    localparam GREEN = 16'h07E0;
    localparam BLACK = 16'h0000;
    localparam BROWN = 16'hB363;
    localparam TEAL = 16'h55DE;
    localparam LIGHT_RED = 16'hEE9A;


    
    wire status;
    flexy_clock clock2 (clk, 25_000_000, status);
    
    integer i;
    always @ (x, y) begin
        oled_data = 1;
        
        for (i = 0; i <= MAX_NUM_PROJECTILES; i = i + 1) begin
            if (is_active[i] == 1) begin
                case (char_no)
                // s1: medicine, s2: math, s3: business, s4: EE, s5: chem
                    0: begin
                        if (faceleft == 1) // facing left
                        begin
                            if ((x == x_ref[i] && y <= y_ref[i] + 1 && y >= y_ref[i] - 1) || ((y == y_ref[i] - 1 || y == y_ref[i] + 1) && x <= x_ref[i] - 2 && x >= x_ref[i] - 5) || (y == y_ref[i] && (x == x_ref[i] - 1 || x == x_ref[i] - 2 || (x <= x_ref[i] - 5 && x >= x_ref[i] - 7))))
                            begin
                                oled_data = BLACK;
                            end else if (y == y_ref[i] && (x == x_ref[i] - 3 || x == x_ref[i] - 4))
                            begin 
                                oled_data = TEAL;
                            end
                        end else if (faceleft == 0) // facing right
                        begin
                            if ((x == x_ref[i] && y <= y_ref[i] + 1 && y >= y_ref[i] - 1) || ((y == y_ref[i] - 1 || y == y_ref[i] + 1) && x >= x_ref[i] + 2 && x <= x_ref[i] + 5) || (y == y_ref[i] && (x == x_ref[i] + 1 || x == x_ref[i] + 2 || (x >= x_ref[i] + 5 && x <= x_ref[i] + 7))))
                            begin
                                oled_data = BLACK;
                            end else if (y == y_ref[i] && (x == x_ref[i] + 3 || x == x_ref[i] + 4))
                            begin 
                                oled_data = TEAL;
                            end
                        end
                    end
                    
                    1: begin
                        if (status == 0) // draw '+'
                        begin
                            if ((y == y_ref[i] && (x >= x_ref[i] && x <= x_ref[i] + 2)) || (x == x_ref[i] + 1 && (y == y_ref[i] + 1 || y == y_ref[i] - 1)))
                            begin
                                oled_data = RED;
                            end
                        end else if (status == 1) // draw 'x'
                        begin
                            if (((x == x_ref[i] || x == x_ref[i] + 2) && (y == y_ref[i] + 1 || y == y_ref[i] - 1)) || (x == x_ref[i] + 1 && y == y_ref[i]))
                            begin
                                oled_data = RED;
                            end
                        end     
                    end
                    
                    2:
                    begin
                        if ((y <= y_ref[i] + 1 && y >= y_ref[i] - 1) && (x == x_ref[i] || x == x_ref[i] + 1 || x == x_ref[i] + 3 || x == x_ref[i] + 4))
                        begin
                            oled_data = GREEN;
                        end else if (x == x_ref[i] + 2 && (y >= y_ref[i] - 1 && y <= y_ref[i] + 1))
                        begin
                            oled_data = BROWN;
                        end
                    end           
                             
                    3:
                    begin
                        if (faceleft == 1) // facing left
                        begin
                            if (y == y_ref[i] && x <= x_ref[i])
                            begin
                                oled_data = LIGHT_RED;
                            end else if ((y == y_ref[i] - 1 || y == y_ref[i] + 1) && x <= x_ref[i]) 
                            begin 
                                oled_data = RED;
                            end
                        end else if (faceleft == 0) // facing right
                        begin
                            if (y == y_ref[i] && x >= x_ref[i])
                            begin
                                oled_data = LIGHT_RED;
                            end else if ((y == y_ref[i] - 1 || y == y_ref[i] + 1) && x >= x_ref[i]) 
                            begin 
                                oled_data = RED;
                            end
                        end
                    end          
                               
                    4:
                    begin
                        if (((x == x_ref[i] || x == x_ref[i] + 4) && (y == y_ref[i] || y == y_ref[i] + 1)) || ((x == x_ref[i] + 1 || x == x_ref[i] + 3) && (y == y_ref[i] - 1 || y == y_ref[i] - 2 || y == y_ref[i] + 2) || (x == x_ref[i] + 2 && y == y_ref[i] + 2)))
                        begin
                            oled_data = BLACK;
                        end else if (((y == y_ref[i] || y == y_ref[i] + 1) && (x >= x_ref[i] + 1 && x <= x_ref[i] + 3)) || (x == x_ref[i] + 2 && y == y_ref[i] - 1))
                        begin
                            oled_data = GREEN;
                        end else if (x == x_ref[i] + 2 && y == y_ref[i] - 2)
                        begin
                            oled_data = BROWN;
                        end
                    end
                endcase
                
            end
        end   
    end
endmodule
