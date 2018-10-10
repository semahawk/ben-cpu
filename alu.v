`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:57 09/30/2018 
// Design Name: 
// Module Name:    alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu (
    input i_clk,
    input i_rst,
    input i_enable,
    input i_subtract, // 0 - add, 1 - subtract
    input [7:0] i_reg_a,
    input [7:0] i_reg_b,
    output o_carry,
    output o_zero,
    output [7:0] o_result
);

    // additional bit for the carry
    reg [7+1:0] out = 0;

    assign o_result = i_enable ? out[7:0] : 8'bZZ;
    assign o_carry = out[8];
    assign o_zero = out[7:0] == 8'h00;

    always @* begin
        if (~i_rst) begin
            out <= 0;
        end else begin
            if (i_subtract)
                out <= i_reg_a - i_reg_b;
            else
                out <= i_reg_a + i_reg_b;
        end
    end

endmodule
