`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:42 05/18/2015 
// Design Name: 
// Module Name:    RNG 
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
module RNG(
    input clk,
    input changeNum,
	 input reset,
    output reg [31:0] randNum
    );

reg [31:0] seed;
reg isSeeded;
reg [4:0] counter = 0;

initial begin
	isSeeded = 0;
	seed = 1;
	randNum = 1;
end

always @ (posedge clk/* or posedge reset*/) begin
    /*if (reset) begin
        seed <= 1;
    end
    else*/
        seed <= seed + 1;
end


always @ (posedge changeNum or posedge reset) begin
	if(reset) begin
			isSeeded <= 0;
			randNum <= 1;
	end
	else begin
		if(isSeeded == 0) begin
			randNum <= seed;
			isSeeded <= 1;
		end
		else begin
			randNum <= (16_807 * randNum) % 2_147_483_647;
		end
	end
end


endmodule
