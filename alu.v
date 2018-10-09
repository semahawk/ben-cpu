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
    output [7:0] o_result
);

    reg [7:0] out = 0;

    assign o_result = i_enable ? out : 8'bZZZZZZZZ;

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
