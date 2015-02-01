`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:29:48 02/01/2015
// Design Name:   Clock_div
// Module Name:   Z:/share/ISE/fury/Clock_div_test.v
// Project Name:  fury
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Clock_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Clock_div_test;

	// Inputs
	reg clk;

	// Outputs
	wire clk_hero;
	wire clk_game;

	// Instantiate the Unit Under Test (UUT)
	Clock_div uut (
		.clk(clk), 
		.clk_hero(clk_hero), 
		.clk_game(clk_game)
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

