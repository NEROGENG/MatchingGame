`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:49:39 05/18/2015
// Design Name:   RNG
// Module Name:   /home/jinsolj/CSM152A-Concentration/TestRNG.v
// Project Name:  CSM152A-Concentration
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RNG
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestRNG;

	// Inputs
	reg clk;
	reg changeNum;
	reg reset;

	// Outputs
	wire [31:0] randNum;

	// Instantiate the Unit Under Test (UUT)
	RNG uut (
		.clk(clk), 
		.changeNum(changeNum),
		.reset(reset),
		.randNum(randNum)
	);

	always #5 clk = !clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		changeNum = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;
#10;
changeNum = 1;
#10
changeNum = 0;

	end
      
endmodule

