`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:23:11 05/27/2015
// Design Name:   MatchingGame
// Module Name:   C:/Users/152/Documents/MatchingGame/TestMatchingGame.v
// Project Name:  MatchingGame
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MatchingGame
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestMatchingGame;

	// Inputs
	reg clk;
	reg rst;
	reg btnU;
	reg btnD;
	reg btnL;
	reg btnR;
	reg btnS;

	// Outputs
	wire [7:0] rgb;
	wire hsync;
	wire vsync;

	// Instantiate the Unit Under Test (UUT)
	MatchingGame uut (
		.clk(clk), 
		.rst(rst), 
		.btnU(btnU), 
		.btnD(btnD), 
		.btnL(btnL), 
		.btnR(btnR), 
		.btnS(btnS), 
		.rgb(rgb), 
		.hsync(hsync), 
		.vsync(vsync)
	);

always #5 clk = !clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		btnU = 0;
		btnD = 0;
		btnL = 0;
		btnR = 0;
		btnS = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	
		#50000;
		btnS = 1;
		#2600000;
		btnS = 0;
		#1000;
		btnL = 1;
		#2600000;
		btnL = 0;
		#1000;
		btnS = 1;
		#2600000;
		btnS = 0;
		
		#2600000;
		rst = 1;
		#26000000;
		rst = 0;
		
		#26000000;
		
		$finish;
	end
      
endmodule

