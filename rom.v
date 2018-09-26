//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:55 09/22/2018 
// Design Name: 
// Module Name:    rom 
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

module rom (
    input wire i_clk,
    input wire i_enable,
    input wire [3:0] i_addr,
    output wire [7:0] o_instr
);

    reg [7:0] code [0:15];

    initial begin
        $readmemb("rom_code.bin", code);
    end

    assign o_instr = i_enable ? code[i_addr] : 8'hZZ;

endmodule
