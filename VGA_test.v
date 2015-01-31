`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:08:05 01/31/2015
// Design Name:   VGA
// Module Name:   Z:/share/ISE/fury/VGA_test.v
// Project Name:  fury
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: VGA
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module VGA_test;

	// Inputs
	reg clk;

	// Outputs
	wire v_sync;
	wire h_sync;
	wire [2:0] vga_R;
	wire [2:0] vga_G;
	wire [1:0] vga_B;
    wire [9:0] x_cnt, y_cnt;

	// Instantiate the Unit Under Test (UUT)
	VGA uut (
		.clk(clk), 
		.v_sync(v_sync), 
		.h_sync(h_sync), 
		.vga_R(vga_R), 
		.vga_G(vga_G), 
		.vga_B(vga_B),
        .x_cnt(x_cnt),
        .y_cnt(y_cnt)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        forever #10 clk = ~clk;

	end
      
endmodule

