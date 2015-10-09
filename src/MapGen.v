`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:47:47 05/18/2015 
// Design Name: 
// Module Name:    MapGen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MapGen(
    input clk,
	input reset,
	output reg finishedGen,
    output reg [`BLOCKS_WIDE * `BLOCKS_HIGH * `BITS_PER_BLOCK - 1:0] logicMap
    //output reg [3:0] cursor,
    //output reg [1:0] isSelected,
	//output reg [8:0] selectedIndex
    );

reg randSig;
wire [31:0] randNum;
reg [`BITS_PER_BLOCK - 1:0] colorVal;
RNG rng(.clk(clk), .changeNum(randSig), .reset(reset), .randNum(randNum));

reg [4:0] curIndex;
reg [3:0] indexCount [0:7];

initial begin
	finishedGen <= 0;
	randSig <= 0;
	curIndex <= 0;
	
	logicMap <= 0;
		
	//initially, all colors can be put on the board twice
	indexCount[0] <= 4'b0010;
	indexCount[1] <= 4'b0010;
	indexCount[2] <= 4'b0010;
	indexCount[3] <= 4'b0010;
	indexCount[4] <= 4'b0100;
	indexCount[5] <= 4'b0100;
end

always @ (posedge clk or posedge reset) begin
	if(reset) begin
		logicMap <= 0;
		finishedGen <= 0;
		randSig <= 0;
		curIndex <= 0;
		
		//initially, all colors can be put on the board twice
		indexCount[6] <= 4'b0010;
		indexCount[1] <= 4'b0010;
		indexCount[2] <= 4'b0010;
		indexCount[3] <= 4'b0010;
		indexCount[4] <= 4'b0100;
		indexCount[5] <= 4'b0100;
		indexCount[0] <= 4'b0000;
		indexCount[7] <= 4'b0000;
	end
	else begin
		//generate new random number
		randSig <= !randSig;
		
		if(randSig) begin
			//get random number from 0...5 for color value
			colorVal <= randNum % 6 + 1;
				
			//if the number of instances of that color remaining is not 0, put it on the board 
			if(indexCount[colorVal] != 0) begin
				indexCount[colorVal] <= indexCount[colorVal] - 1;
					
				//[2:0] = color id
				logicMap[(curIndex * `BITS_PER_BLOCK)+: `BITS_PER_BLOCK] <= colorVal;
				curIndex <= curIndex + 1;
			end
				
			//otherwise if the board has been filled up, start the game
			else if (curIndex > `BLOCKS_WIDE * `BLOCKS_HIGH - 1) begin
				finishedGen <= 1;
			end
		end
	end
end

endmodule
