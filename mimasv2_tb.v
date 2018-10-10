`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:20:09 09/26/2018
// Design Name:   mimasv2
// Module Name:   /home/surbas/fpga/ben_cpu/mimasv2_tb.v
// Project Name:  ben_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mimasv2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mimasv2_tb;

    // Inputs
    reg i_clk;
    reg i_rst;
    reg [7:0] DPSwitch;

    // Outputs
    wire [7:0] LED;

    // Instantiate the Unit Under Test (UUT)
    mimasv2 uut (
        .i_clk(i_clk), 
        .i_rst(1'b1), 
        .DPSwitch(DPSwitch),
        .LED(LED)
    );

    initial begin
        // Initialize Inputs
        i_clk = 0;
        i_rst = 1;
        DPSwitch = 8'b11111111;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        #50000;
        DPSwitch = 8'b11111110;
        #50000;
        DPSwitch = 8'b11111100;
        #50000;
        DPSwitch = 8'b11111011;
        #50000;
        DPSwitch = 8'b00000001;
        #50000;
        DPSwitch = 8'b10000001;
        #50000;
        DPSwitch = 8'b11111101;
    end
    
    always begin
        #10 i_clk = ~i_clk;
    end
      
endmodule

