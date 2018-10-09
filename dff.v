//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:41:34 09/19/2018 
// Design Name: 
// Module Name:    dff 
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

module dff (
    input i_clk,
    input i_rst, // active LOW
    input i_load,
    input i_enable,
    input i_zeroize, // makes the DFF output a 0, instead of i_D
    input i_D,
    output o_Q,
    output o_direct
);

    reg out = 0;

    always @ (posedge i_clk or negedge i_rst) begin
        if (~i_rst)
            out <= 0;
        else
            if (i_load)
                out <= i_D;
    end

    assign o_Q = (i_enable ? (i_zeroize ? 1'b0 : out) : (1'bZ));
    assign o_direct = out;

endmodule
