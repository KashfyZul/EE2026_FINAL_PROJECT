`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2024 14:50:23
// Design Name: 
// Module Name: flexible_clock_signal
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


module flexible_clock_signal(input clk, input [31:0] number, output reg slw_clk = 0);

    reg [31:0] count = 0;
    always @ (posedge clk)begin
        count <= (count == number) ? 0 : count + 1;
        slw_clk <= (count == 0) ? ~slw_clk : slw_clk;
    end

endmodule

