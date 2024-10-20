`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2024 16:49:47
// Design Name: 
// Module Name: clock
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
module draw_map(input [12:0] p_index, input [7:0]platform_width, input [7:0]platform_x,  input[7:0]platform_y,
output reg [15:0] oled_data);
    wire [7:0] x; wire [7:0] y;
    assign x = p_index % 96;
    assign y = p_index / 96;
    always @(p_index) begin 
        oled_data <= 0;
        if ((y >= platform_y && y <= platform_y + 3) && (x >= platform_x && x <= platform_x + platform_width)) begin
            oled_data <= 16'b1111100000000000; 
        end
    end
endmodule


module flexy_clk(input in_clk, input [31:0] m,  output reg clk);
    reg [31:0] COUNT;
    initial begin 
        COUNT = 0;
        clk = 0;
    end 
    always @(posedge in_clk) begin
        COUNT <= (COUNT == m) ? 0 : COUNT + 1;
        clk <= COUNT ? clk : ~clk;
    end
endmodule
