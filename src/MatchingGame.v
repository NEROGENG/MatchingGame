`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:03:18 05/24/2015 
// Design Name: 
// Module Name:    MatchingGame 
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
module MatchingGame(
    input clk,
    input rst,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    input btnS,
	output [7:0] rgb,
	output hsync,
	output vsync,
	output [7:0] C,  //cathode
    output [3:0] AN  //anode
    );
	
//Asynchronous reset
wire arst_i;
reg [1:0] arst_ff;

assign arst_i = rst;
assign reset = arst_ff[0];

initial begin
	arst_ff <= 2'b11;
end

always @ (posedge clk or posedge arst_i)
	if (arst_i)
		arst_ff <= 2'b11;
	else
		arst_ff <= {1'b0, arst_ff[1]}; 


//assign reset = rst;
wire mapReset;
wire resetSum;
assign resetSum = mapReset | rst;

wire [`BLOCKS_WIDE * `BLOCKS_HIGH * `BITS_PER_BLOCK - 1:0] inputMap;
wire [`BLOCKS_WIDE * `BLOCKS_HIGH * `BITS_PER_BLOCK - 1:0] logicMap;
wire finishedGen;

wire [3:0] cursor;
wire [7:0] selected;
wire [1:0] selectedCount;
wire [4:0] removedCards;

FSM fsm(.clk(clk), .reset(reset), .mapReset(mapReset), .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .btnS(btnS), .inputMap(inputMap), 
	.finishedGen(finishedGen), .logicMap(logicMap), .cursor(cursor), .selected(selected), .selectedCount(selectedCount), .removedCards(removedCards));
	
MapGen mapgen(.clk(clk), .reset(resetSum), .finishedGen(finishedGen), .logicMap(inputMap));

vga VGA(.clk(clk), .cursor(cursor), .vid_mem(logicMap), .rgb(rgb), .hsync(hsync), .vsync(vsync), 
	.selected(selected), .selectedCount(selectedCount));
	
SevenSeg sevenseg(.clk(clk), .removedCards(removedCards), .C(C), .AN(AN));

endmodule
