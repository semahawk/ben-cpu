`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:49:05 09/20/2018
// Design Name:   dff
// Module Name:   /home/surbas/fpga/ben_cpu/dff_tb.v
// Project Name:  ben_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dff
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dff_tb;

	// Inputs
	reg clk;
	reg rst;
	reg load;
	reg enable;
	reg D;

	// Outputs
	wire Q;

	// Instantiate the Unit Under Test (UUT)
	dff uut (
		.i_clk(clk),
		.i_rst(rst),
		.i_load(load),
		.i_enable(enable),
		.i_D(D),
		.o_Q(Q)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		load = 1;
		enable = 1;
		D = 0;

		// Wait 100 ns for global reset to finish
		#100;

		// Add stimulus here
		D = 1;
		D = #10 0;

		if (Q == 1) begin
			$display("Q changed even though the clock was not driven HIGH!");
			$finish;
		end
		
		D = #10 1;
		clk = 1;
		clk = #2 0;

		if (Q != 1) begin
			$display("Q didn't change to 1!");
			$finish;
		end

		rst = #10 0;
		rst = #2 1;

		if (Q != 0) begin
			$display("Q didn't reset to 0 even though the rst was driven LOW!");
			$finish;
		end
		
		#100;

		// Finish
		$display("Test finished!");
		$finish;
	end
      
endmodule

