`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:00:49 09/20/2018
// Design Name:   register
// Module Name:   /home/surbas/fpga/ben_cpu/cpu_tb.v
// Project Name:  ben_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: register
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cpu_tb;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [7:0] out;

    // Instantiate the Unit Under Test (UUT)
    cpu uut (
        .i_clk(clk), 
        .i_rst(rst),
        .o_out(out)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        #500;
        rst = 0;
        rst = #100 1;
        #300;

        $finish;
    end
    
    always begin
        #10 clk = ~clk;
    end
      
endmodule

