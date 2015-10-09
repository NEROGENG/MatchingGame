`timescale 1ns / 1ps
`include "definitions.v"
module vga(
	 input wire clk,
	 input wire [3:0] cursor,
	 input wire [7:0] selected,
	 input wire [1:0] selectedCount,
	 input wire [(`BITS_PER_BLOCK*`BLOCKS_WIDE*`BLOCKS_HIGH)-1:0] vid_mem,
    output reg [7:0] rgb,
    output wire hsync,
    output wire vsync
    );
	
	reg [1:0] pixel_clk = 0;
	wire pixel_clk_en = (pixel_clk == 0);
	
	always @ (posedge clk) begin
		pixel_clk <= pixel_clk + 1;
	end
	
	reg [9:0] counter_x = 0;
	reg [9:0] counter_y = 0;
	
	wire [9:0] cursor_x = (cursor % `BLOCKS_WIDE)*`BLOCK_SIZE + `BOARD_X + `CURSOR_SIZE;
	wire [9:0] cursor_y = (cursor / `BLOCKS_WIDE)*`BLOCK_SIZE + `BOARD_Y + `CURSOR_SIZE;
	
	wire [9:0] card1_x = (selected[3:0] % `BLOCKS_WIDE)*`BLOCK_SIZE + `BOARD_X;
	wire [9:0] card1_y = (selected[3:0] / `BLOCKS_WIDE)*`BLOCK_SIZE + `BOARD_Y;
	
	wire [9:0] card2_x = (selected[7:4] % `BLOCKS_WIDE)*`BLOCK_SIZE + `BOARD_X;
	wire [9:0] card2_y = (selected[7:4] / `BLOCKS_WIDE)*`BLOCK_SIZE + `BOARD_Y;
	
	assign hsync = ~(counter_x >= (`PIXEL_WIDTH + `HSYNC_FRONT_PORCH) &&
	                 counter_x < (`PIXEL_WIDTH + `HSYNC_FRONT_PORCH + `HSYNC_PULSE_WIDTH));
	assign vsync = ~(counter_y >= (`PIXEL_HEIGHT + `VSYNC_FRONT_PORCH) &&
	                 counter_y < (`PIXEL_HEIGHT + `VSYNC_FRONT_PORCH + `VSYNC_PULSE_WIDTH));
	
	// Combinational logic to select the current pixel
	reg [9:0] current_block_index = 0;
	reg [2:0] current_vid_mem = 0;
	always @ (posedge pixel_clk_en) begin
		// Check if we're within the drawing space
		if (counter_x >= `BOARD_X && counter_y >= `BOARD_Y &&
		    counter_x < `BOARD_X + `BOARD_WIDTH && counter_y < `BOARD_Y + `BOARD_HEIGHT) begin
			 
			 // Combinational logic to select the current pixel
			current_block_index <= ((counter_x-`BOARD_X+2) /`BLOCK_SIZE) + (((counter_y-`BOARD_Y)/`BLOCK_SIZE)*`BLOCKS_WIDE);
			current_vid_mem <= vid_mem[current_block_index * `BITS_PER_BLOCK +:`BITS_PER_BLOCK];
			
			if (counter_x == `BOARD_X || counter_x == `BOARD_X + `BOARD_WIDTH - 1 ||
				counter_y == `BOARD_Y || counter_y == `BOARD_Y + `BOARD_HEIGHT - 1 ||
				counter_x == `BOARD_X + 1 || counter_x == `BOARD_X + `BOARD_WIDTH - 2/* ||
				counter_y == `BOARD_Y || counter_y == `BOARD_Y + `BOARD_HEIGHT - 1*/) begin
				// We're at the edge of the board, paint it white
				rgb <= 8'b11111111;
			end
			else if (counter_x >= cursor_x && counter_y >= cursor_y &&
					 counter_x < cursor_x + `CURSOR_SIZE && counter_y < cursor_y + `CURSOR_SIZE) begin
				// Draw cursor
				rgb <= 8'b11111111;
			end
			else if (selectedCount == 2'b01 &&
						counter_x >= card1_x && counter_y >= card1_y &&
						counter_x < card1_x + `BLOCK_SIZE && counter_y < card1_y + `BLOCK_SIZE) begin
				// Draw one revealed card
				case (current_vid_mem[2:0])
					`EMPTY_BLOCK: rgb <= `BLACK;
					`CYAN_BLOCK: rgb <= `CYAN;
					`YELLOW_BLOCK: rgb <= `YELLOW;
					`PURPLE_BLOCK: rgb <= `PURPLE;
					`GREEN_BLOCK: rgb <= `GREEN;
					`RED_BLOCK: rgb <= `RED;
					`BLUE_BLOCK: rgb <= `BLUE;
					`ORANGE_BLOCK: rgb <= `ORANGE;
				endcase			
			end
			else if (selectedCount == 2'b10 &&
						((counter_x >= card1_x && counter_y >= card1_y &&
						counter_x < card1_x + `BLOCK_SIZE && counter_y < card1_y + `BLOCK_SIZE)
						||
						(counter_x >= card2_x && counter_y >= card2_y &&
						counter_x < card2_x + `BLOCK_SIZE && counter_y < card2_y + `BLOCK_SIZE))) begin
				// Draw two revealed cards
				case (current_vid_mem[2:0])
					`EMPTY_BLOCK: rgb <= `BLACK;
					`CYAN_BLOCK: rgb <= `CYAN;
					`YELLOW_BLOCK: rgb <= `YELLOW;
					`PURPLE_BLOCK: rgb <= `PURPLE;
					`GREEN_BLOCK: rgb <= `GREEN;
					`RED_BLOCK: rgb <= `RED;
					`BLUE_BLOCK: rgb <= `BLUE;
					`ORANGE_BLOCK: rgb <= `ORANGE;
				endcase			
			end
			else begin
				if (current_vid_mem[2:0] == `EMPTY_BLOCK)
					// Paint it black if the card is already removed
					rgb <= `BLACK;
				else
					// Paint it gray if the card is folded
					rgb <= `GRAY;
			end
			
		end else begin
			// Outside the board
			current_block_index <= 0;
			current_vid_mem <= 0;
			rgb <= `BLACK;
		end
	end
	
	always @ (posedge pixel_clk_en) begin
		if (counter_x >= `PIXEL_WIDTH + `HSYNC_FRONT_PORCH + `HSYNC_PULSE_WIDTH + `HSYNC_BACK_PORCH) begin
			counter_x <= 0;
			if (counter_y >= `PIXEL_HEIGHT + `VSYNC_FRONT_PORCH + `VSYNC_PULSE_WIDTH + `VSYNC_BACK_PORCH) begin
				counter_y <= 0;
			end else begin
				counter_y <= counter_y + 1;
			end
		end else begin
			counter_x <= counter_x + 1;
		end
	end

endmodule
