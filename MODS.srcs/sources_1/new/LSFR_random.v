`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2024 08:24:40 PM
// Design Name: 
// Module Name: LSFR_random
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


module LFSR_random (
    input CLOCK,
    input rst,             // Reset signal
    input [11:0] n,         // max values that can be produced
    output [11:0] random // 11-bit random number output
);

    reg [11:0] lfsr; // Register to hold the LFSR value

    always @(posedge CLOCK or posedge rst) begin
        if (rst) begin
            lfsr <= 12'h23; // Initialize LFSR to a non-zero value on reset
        end else begin
            // Polynomial: x^12 + x^11 + x^10 + x^9 + x^7 + 1
            lfsr[11:1] <= lfsr[10:0];
            lfsr[0] <= lfsr[11] ^ lfsr[10] ^ lfsr[9] ^ lfsr[7]; // Adjust feedback taps as needed
        end
    end

    // Assign LFSR output to random number
    assign random = lfsr % n;

endmodule

