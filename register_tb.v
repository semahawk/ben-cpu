`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:35:03 09/19/2018
// Design Name:   register
// Module Name:   /home/surbas/fpga/ben_cpu/reg_tb.v
// Project Name:  register
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

module reg_tb;

    // Inputs
    reg clk;
    reg rst;
    reg load;
    reg enable;
    reg [7:0] D;
    
    // Outputs
    wire [7:0] Q;

    // Instantiate the Unit Under Test (UUT)
    register uut (
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
        load = 0;
        enable = 1;
        D = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        D = 2'b11;
        D = #10 0;
        
        #5;
        if (Q != 0) begin
            $display("ERROR: Q changed even though the clock was not driven HIGH!");
            $finish;
        end

        load = 0;
        D = #10 2'b11;
        clk = #10 1;
        clk = #5 0;
        
        #5;
        if (Q == 2'b11) begin
            $display("ERROR: Q was changed even though 'load' is 0!");
            $finish;
        end

        rst = #50 0;
        rst = #1 1;
        
        #5;
        if (Q != 0) begin
            $display("ERROR: Q didn't reset back to 0 on rst going LOW!");
            $finish;
        end
        
        load = #10 1;
        D = #10 4'b1010;
        clk = #10 1;
        clk = #5 0;
        
        #5;
        if (Q != 4'b1010) begin
            $display("ERROR: couldn't set Q!");
            $finish;
        end
        
        #10;
        enable = 0;
        if (Q != 8'hZZ) begin
            $display("ERROR: Q didn't go to HiZ, even though 'enable' was pulled down!");
            $finish;
        end
        
        #10;
        enable = 1;
        if (Q != 4'b1010) begin
            $display("ERROR: Q didn't go back to it's previous value on pulling 'enable' HIGH!");
            $finish;
        end

        #50;
        $display("Test finished successfully!");
        $finish;
    end
      
endmodule
