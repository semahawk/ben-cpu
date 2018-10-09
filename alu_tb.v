`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:43:46 09/30/2018
// Design Name:   alu
// Module Name:   /home/poliel/Code/fpga/ben_cpu/alu_tb.v
// Project Name:  ben_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_tb;

    // Inputs
    reg i_clk;
    reg i_rst;
    reg i_enable;
    reg i_subtract;
    reg [7:0] i_reg_a;
    reg [7:0] i_reg_b;

    // Outputs
    wire [7:0] o_result;

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .i_clk(i_clk), 
        .i_rst(i_rst), 
        .i_enable(i_enable), 
        .i_subtract(i_subtract), 
        .i_reg_a(i_reg_a), 
        .i_reg_b(i_reg_b), 
        .o_result(o_result)
    );

    initial begin
        // Initialize Inputs
        i_clk = 0;
        i_rst = 1;
        i_enable = 0;
        i_subtract = 0;
        i_reg_a = 0;
        i_reg_b = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        i_reg_a = 4'b1010;
        i_reg_b = 4'b10;
        i_enable = 1;
        i_enable = #20 0;

        #20;
        i_reg_a = 4'b1010;
        i_reg_b = 4'b10;
        i_subtract = 1;
        i_enable = 1;
        i_enable = #20 0;
    end

    always #5 i_clk = ~i_clk;
      
endmodule

