`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:06:25 05/28/2015
// Design Name:   MapGen
// Module Name:   /home/jinsolj/MatchingGame/TestMapGen.v
// Project Name:  MatchingGame
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MapGen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestMapGen;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire finishedGen;
	wire [47:0] logicMap;

	// Instantiate the Unit Under Test (UUT)
	MapGen uut (
		.clk(clk), 
		.reset(reset), 
		.finishedGen(finishedGen), 
		.logicMap(logicMap)
	);

	always #5 clk = !clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#2000;
		reset = 1;
		#1000;
		reset = 0;
		#2000;
		
		reset = 1;
		#1000;
		reset = 0;
		#2000;
		
		reset = 1;
		#1000;
		reset = 0;
		#2000;
		
		reset = 1;
		#1000;
		reset = 0;
		#2000;
		
		$finish;

	end
      
endmodule

