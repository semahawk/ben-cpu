//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:56 09/19/2018 
// Design Name: 
// Module Name:    register 
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

module register (
    input i_clk,
    input i_rst,
    input i_load,
    input i_enable,
    input i_only_lower,
    input [7:0] i_D,
    output [7:0] o_Q
);

    dff upper[7:4](
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(i_load),
        .i_enable(i_enable),
        .i_zeroize(i_only_lower),
        .i_D(i_D[7:4]),
        .o_Q(o_Q[7:4])
    );

    dff lower[3:0](
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(i_load),
        .i_enable(i_enable),
        .i_zeroize(1'b0),
        .i_D(i_D[3:0]),
        .o_Q(o_Q[3:0])
    );

endmodule
