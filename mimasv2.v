//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:01:05 09/24/2018 
// Design Name: 
// Module Name:    mimasv2 
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

module mimasv2 (
    input wire i_clk,
    input wire i_rst,
    output wire [7:0] LED
);

    cpu cpu (
        .i_clk(i_clk),
        .i_rst(1'b1),
        .o_out(LED)
    );

endmodule
