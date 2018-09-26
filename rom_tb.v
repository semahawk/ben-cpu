`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:45:03 09/22/2018
// Design Name:   rom
// Module Name:   /home/surbas/fpga/ben_cpu/rom_tb.v
// Project Name:  ben_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rom
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module rom_tb;

    // Inputs
    reg i_clk;
    reg i_enable;
    reg [3:0] i_addr;

    reg [3:0] expected_code[0:15];

    // Outputs
    wire [7:0] o_instr;

    // Instantiate the Unit Under Test (UUT)
    rom uut (
        .i_clk(i_clk), 
        .i_enable(i_enable), 
        .i_addr(i_addr), 
        .o_instr(o_instr)
    );

    initial begin
        // Initialize Inputs
        i_clk = 0;
        i_addr = 0;
        i_enable = 0;

        $readmemb("rom_code.bin", expected_code);

        // Wait 100 ns for global reset to finish
        #100;

        for (i_addr = 0; i_addr < 16; i_addr = i_addr + 1) begin
                i_enable = 1;
                i_clk = 1;

                if (o_instr != expected_code[i_addr]) begin
                        $display("ROM returned wrong instruction (addr: %x)!", i_addr);
                        $finish;
                end else begin
                        $display("i_addr: %x matches %x!", o_instr, expected_code[i_addr]);
                end

                #10;

                i_enable = 0;
                i_clk = 0;

                #10;
        end

        // Add stimulus here
        $finish;
    end
        
endmodule

