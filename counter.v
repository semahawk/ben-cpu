`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:47 09/28/2018 
// Design Name: 
// Module Name:    counter 
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

module counter (
    input i_clk,
    input i_rst,
    input i_load,
    input i_enable,
    input i_count,
    input [3:0] i_bus,
    output [3:0] o_bus
);

    reg [3:0] out = 0;

    always @ (posedge i_clk or negedge i_rst) begin
        if (~i_rst) begin
            out <= 0;
        end else begin // ~i_rst
            if (i_load) begin
                out <= i_bus;
            end else begin
                if (i_count) begin
                    if (out == 4'b1111)
                        out <= 0;
                    else
                        out <= out + 1;
                end // i_count
            end // ~i_load
        end // i_rst
    end

    assign o_bus = i_enable ? out : 4'bZZZZ;

endmodule
