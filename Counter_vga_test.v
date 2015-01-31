`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:51:18 01/31/2015
// Design Name:   Counter_vga
// Module Name:   Z:/share/ISE/fury/Counter_vga_test.v
// Project Name:  fury
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Counter_vga
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Counter_vga_test;

	// Inputs
	reg clk;

	// Outputs
	wire clk_vga;

	// Instantiate the Unit Under Test (UUT)
	Counter_vga uut (
		.clk(clk), 
		.clk_vga(clk_vga)
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

