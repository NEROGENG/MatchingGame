`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:35:51 05/20/2015 
// Design Name: 
// Module Name:    FSM 
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

//Anywhere CONST appears, is a value that needs to be modified if 
//`BLOCKS_WIDE=4 or `BLOCKS_HIGH=4 is increased

module FSM(
    input clk,
	input reset,
	output reg mapReset,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    input btnS,
    input [`BLOCKS_WIDE * `BLOCKS_HIGH * `BITS_PER_BLOCK - 1:0] inputMap,
	input finishedGen,
    output reg [`BLOCKS_WIDE * `BLOCKS_HIGH * `BITS_PER_BLOCK - 1:0] logicMap,
	 
	 //CONST: 4 bits -> log(2, grid size)
    output reg [3:0] cursor,
	 
	 //CONST: 8 bits -> 2 * log(2, grid size)
    output reg [7:0] selected,
	output reg [1:0] selectedCount,
	 
	 //CONST: 5 bits to store log(2, grid size) plus extra
	output reg [4:0] removedCards
    );	
	 
	 
//clk_dv_inc is a wire, but clk_dv is a reg.
//The assign will immediately update the wire whenever the reg changes.
//Thus the MSB of clk_dv_inc is high only for one cycle,
//Until it gets updated by clk_dv which has overflowed to 0.
wire [17:0] clk_dv_inc;
reg [16:0] clk_dv;
assign clk_dv_inc = clk_dv + 1;

reg clk_en;
reg clk_en_d;

reg [2:0] step_L;
reg [2:0] step_R;
reg [2:0] step_U;
reg [2:0] step_D;
reg [2:0] step_S;

reg buttonL;
reg buttonR;
reg buttonU;
reg buttonD;
reg buttonS;

initial begin
	clk_dv   <= 0;
	clk_en   <= 1'b0;
    clk_en_d <= 1'b0;
	
	step_L <= 3'b000;
	step_R <= 3'b000;
	step_U <= 3'b000;
	step_D <= 3'b000;
	step_S <= 3'b000;
	
	buttonL <= 1'b0;
	buttonR <= 1'b0;
	buttonU <= 1'b0;
	buttonD <= 1'b0;
	buttonS <= 1'b0;
	
	cur_state <= 0;
	next_state <= 0;
	revealTimer <= 0;
	removedCards <= 0;
	selected <= 0;
	selectedCount <= 0;
	
	cursor <= 0;
end

//763Hz = 100Mhz / (2^17)   
always @ (posedge clk or posedge reset) begin
	if (reset) begin
		clk_dv   <= 0;
		clk_en   <= 1'b0;
      clk_en_d <= 1'b0;
	end
	else begin
		clk_dv   <= clk_dv_inc[16:0];
			 
		//clk_en is high for one clk cycle.
		clk_en   <= clk_dv_inc[17];
			 
		//clk_en_d is also high for one clk cycle.
		clk_en_d <= clk_en;
	end
end   

always @ (posedge clk or posedge reset) begin
	if(reset) begin
		step_L <= 3'b000;
		step_R <= 3'b000;
		step_U <= 3'b000;
		step_D <= 3'b000;
		step_S <= 3'b000;
	end
   else if (clk_en) begin
      step_L[2:0]  <= {btnL, step_L[2:1]};
		step_R[2:0]  <= {btnR, step_R[2:1]};
		step_U[2:0]  <= {btnU, step_U[2:1]};
		step_D[2:0]  <= {btnD, step_D[2:1]};
		step_S[2:0]  <= {btnS, step_S[2:1]};
   end
end

always @ (posedge clk or posedge reset) begin
	if (reset) begin
		buttonL <= 1'b0;
		buttonR <= 1'b0;
		buttonU <= 1'b0;
		buttonD <= 1'b0;
		buttonS <= 1'b0;
	end
	else begin
		//clk_en_d value is from the previous cycle (since its a reg) , not from the current updated one.
		//This is why clk_en_d is needed: since clk_dv_inc is a wire, putting clk_dv_inc[17]
		//here would result in the updated value being used
        buttonL <= ~step_L[0] & step_L[1] & clk_en_d;
		buttonR <= ~step_R[0] & step_R[1] & clk_en_d;
		buttonU <= ~step_U[0] & step_U[1] & clk_en_d;
		buttonD <= ~step_D[0] & step_D[1] & clk_en_d;
		buttonS <= ~step_S[0] & step_S[1] & clk_en_d;
	end
end

reg [3:0] cur_state;
reg [3:0] next_state;
reg [31:0] revealTimer;


//FSM stuff here
always @ (posedge clk or posedge reset) begin
	if(reset) begin
		revealTimer <= 0;
		removedCards <= 0;
		selected <= 0;
		selectedCount <= 0;
		mapReset <= 0;
	end
	else begin
		case(cur_state)
			0: begin //Map Gen
				//remain in this state until map is finished generating
				if(finishedGen) begin
					logicMap <= inputMap;
					removedCards <= 0;
			
				end
			
			end
			1: begin //Idle
				//If any 4-directional button is pressed, modify cursor position and stay in state
				if(buttonU) begin
					cursor <= ((cursor - `BLOCKS_WIDE) + (`BLOCKS_WIDE * `BLOCKS_HIGH)) 
						% (`BLOCKS_WIDE * `BLOCKS_HIGH);
				
				end
				else if(buttonD) begin
					cursor <= (cursor + `BLOCKS_WIDE) % (`BLOCKS_WIDE * `BLOCKS_HIGH);
					
				end
				else if(buttonL) begin
					cursor <= (cursor / `BLOCKS_WIDE) * `BLOCKS_WIDE + ((cursor - 1) % `BLOCKS_WIDE);
					
				end
				else if(buttonR) begin
					cursor <= (cursor / `BLOCKS_WIDE) * `BLOCKS_WIDE + ((cursor + 1) % `BLOCKS_WIDE);
					
				end
		
			end
			2: begin //Select
				//If we selected an empty block, or a card that is already selected,
				//do nothing and go back to idle state.
				
				//CONST: selected[3:0] -> 4 bits = log(2, grid size)
				if(logicMap[(cursor * `BITS_PER_BLOCK)+:`BITS_PER_BLOCK] == `EMPTY_BLOCK || 
						(cursor == selected[3:0] && selectedCount == 1))
					begin
					end
					
				//Otherwise save cursor position. If one card is selected, go back to idle state.
				//If two cards are selected, go to reveal state.
				else begin
					//CONST: see previous
					selected[(selectedCount * 4)+:4] <= cursor;
					selectedCount <= selectedCount + 1;
				end
			end
			3: begin //Reveal
			//This state displays the two faceup cards for 1/2 a second before evaluating them.
				if(revealTimer == 10_000_000) begin
					revealTimer <= 0;
		
				end
				else begin
					revealTimer <= revealTimer + 1;
	
				end
			end
			4: begin //Evaluate
				//If the two cards are the same color, make them empty and increment the removedCards counter.
			
				//CONST: entire if statement: 4 bits -> log(2, grid size)
				if(logicMap[(selected[3:0] * `BITS_PER_BLOCK)+:`BITS_PER_BLOCK] == 
						logicMap[(selected[7:4] * `BITS_PER_BLOCK)+:`BITS_PER_BLOCK]) begin
					logicMap[(selected[3:0] * `BITS_PER_BLOCK)+:`BITS_PER_BLOCK] <= `EMPTY_BLOCK; //removed
					logicMap[(selected[7:4] * `BITS_PER_BLOCK)+:`BITS_PER_BLOCK] <= `EMPTY_BLOCK; //removed
					
					selectedCount <= 0;
					removedCards <= removedCards + 2;
					
					//If we removed all the cards, go to finish state. Otherwise go back to idle state.

				end
				
				//If the two cards are not the same color, then deselect them and go back to idle state.
				else begin
					selectedCount <= 0;
				end
			end
			5: begin //Finish
				if(revealTimer == 100_000_000) begin
					revealTimer <= 0;
					mapReset <= 0;
		
				end
				else begin
					revealTimer <= revealTimer + 1;
					mapReset <= 1;
				end
			end
		endcase
		
		//cur_state <= next_state;
	end
end

always @ (*) begin
	next_state = cur_state;
	case(cur_state)
	0: begin
		if(finishedGen)
			next_state = 1;
	end
	1: begin
		if(buttonS)
			next_state = 2;
	end
	2: begin
		if(logicMap[(cursor * `BITS_PER_BLOCK)+:`BITS_PER_BLOCK] == `EMPTY_BLOCK || 
						(cursor == selected[3:0] && selectedCount == 1))
					next_state = 1;
		else if (selectedCount  == 0)
			next_state = 1;
		else if (selectedCount == 1)
			next_state = 3;
	end
	3: begin
		if(revealTimer == 10_000_000) 
			next_state = 4;
		else
			next_state = 3;
	end
	4: begin
		if(logicMap[(selected[3:0] * `BITS_PER_BLOCK)+:`BITS_PER_BLOCK] == 
						logicMap[(selected[7:4] * `BITS_PER_BLOCK)+:`BITS_PER_BLOCK]) begin
								next_state = (removedCards == `BLOCKS_WIDE * `BLOCKS_HIGH - 2) ? 5 : 1;
		end
		else
			next_state = 1;
	end
	5: begin
		if(revealTimer == 100_000_000) 
			next_state = 0;
		else
			next_state = 5;
	end
	endcase
end

always @(posedge clk or posedge reset) begin
	if(reset)
		cur_state <= 0;
	else
		cur_state <= next_state;
end

endmodule
