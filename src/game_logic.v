`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:19 05/18/2015 
// Design Name: 
// Module Name:    game_logic 
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
module game_logic(
	  input clk,
	  input rst,
	 output [7:0] rgb,
	 output hsync,
	 output vsync
    );

reg [(`BITS_PER_BLOCK*`BLOCKS_WIDE*`BLOCKS_HIGH)-1:0] vid_mem = 0;
reg [`BLOCKS_WIDE:0] cursor = 0;
reg [7:0] selected = 0;
reg [1:0] selectedCount = 0;

wire finishedGen;

vga display(
	.clk(clk),
	.cursor(cursor),
	.selected(selected),
	.selectedCount(selectedCount),
	.vid_mem(vid_mem),
   .rgb(rgb),
   .hsync(hsync),
   .vsync(vsync)
    );
	 
always @ (posedge clk) begin
	cursor <= 9;
	vid_mem[47:32] <= 16'hffff;
	vid_mem[31:16] <= 16'hffff;
	vid_mem[15:0] <= 16'hffff;
	selected <= 8'b00000010;
	selectedCount <= 2'b10;
end
endmodule
