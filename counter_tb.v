`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:15:14 09/28/2018
// Design Name:   counter
// Module Name:   /home/poliel/Code/fpga/ben_cpu/counter_tb.v
// Project Name:  ben_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module counter_tb;

    // Inputs
    reg i_clk;
    reg i_rst;
    reg i_load;
    reg i_enable;
    reg i_count;
    reg [3:0] i_bus;

    // Outputs
    wire [3:0] o_bus;

    // Instantiate the Unit Under Test (UUT)
    counter uut (
        .i_clk(i_clk), 
        .i_rst(i_rst), 
        .i_load(i_load), 
        .i_enable(i_enable), 
        .i_count(i_count), 
        .i_bus(i_bus), 
        .o_bus(o_bus)
    );

    initial begin
        // Initialize Inputs
        i_clk = 0;
        i_rst = 1;
        i_load = 0;
        i_enable = 0;
        i_count = 0;
        i_bus = 0;

        // Wait 100 ns for global reset to finish
        #100;

        i_enable = 1;

        #50; i_count = 1;
        #20; i_count = 0;

        #200;
        
        // Add stimulus here
        $finish;
    end

    always #5 i_clk = ~i_clk;
      
endmodule

