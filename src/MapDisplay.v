`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:06:37 05/19/2015 
// Design Name: 
// Module Name:    MapDisplay 
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
module MapDisplay(
	 input clk,
	 input reset,
    input [79:0] logicMap,
    input [3:0] cursor,
    input [9:0] selected,
    output reg [11:0] colorMap [11:0][2:0]
    );

reg [4:0] i;
reg [7:0] x,y;

always @ (posedge clk or posedge reset) begin
	if(reset) begin
	end
	else begin
		for(i = 0; i < 16; i = i + 1) begin
			x <= i % 4;
			y <= i / 4;
		
			colorMap[3 * y][3 * x][2:0] <= logicMap[(i * 5) + 2 : i * 5];
			colorMap[3 * y][3 * x + 1][2:0] <= logicMap[(i * 5) + 2 : i * 5];
			colorMap[3 * y][3 * x + 2][2:0] <= logicMap[(i * 5) + 2 : i * 5];
			
			colorMap[3 * y + 1][3 * x][2:0] <= logicMap[(i * 5) + 2 : i * 5];
			//cursorColor should have the id of the cursor's color
			colorMap[3 * y + 1][3 * x + 1][2:0] <= (cursor == i) ? 3'b111 : logicMap[(i * 5) + 2 : i * 5];
			colorMap[3 * y + 1][3 * x + 2][2:0] <= logicMap[(i * 5) + 2 : i * 5];
			
			colorMap[3 * y + 2][3 * x][2:0] <= logicMap[(i * 5) + 2 : i * 5];
			colorMap[3 * y + 2][3 * x + 1][2:0] <= logicMap[(i * 5) + 2 : i * 5];
			colorMap[3 * y + 2][3 * x + 2][2:0] <= logicMap[(i * 5) + 2 : i * 5];
			
		end
	end
end


endmodule
