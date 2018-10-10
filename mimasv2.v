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
    input wire [7:0] DPSwitch,
    output wire [7:0] LED
);

    // the clock input for the cpu itself
    // already after the divider
    wire cpu_clk;

    clk_divider clk_div (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_divider({ 14'b0, ~DPSwitch, 10'b100000 }),
        .o_clk(cpu_clk)
    );

    cpu cpu (
        .i_clk(cpu_clk),
        .i_rst(i_rst),
        .o_out(LED)
    );

endmodule
