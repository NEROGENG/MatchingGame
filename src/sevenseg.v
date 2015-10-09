`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:20:12 05/31/2015 
// Design Name: 
// Module Name:    sevenseg 
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
module SevenSeg(
    input clk,
	 input [4:0] removedCards,

    output reg[7:0] C,  //cathode
    output reg[3:0] AN  //anode
    );

reg [1:0] digit = 0;
reg [5:0] value = 0;
//initial begin
	//digit = 2'b00;
//end

reg [15:0] clock;
wire clk_en = (clock == 0);
always @ (posedge clk)
	clock <= clock + 1;

always @ (posedge clk_en) begin
	
	//choose which digit to display
	digit <= digit + 1;
	if (removedCards == 5'b10000) begin
	// display GOAL
			case(digit)
			0: begin
				AN <= 4'b1011;
				C <= 8'b11000000;
			end
			
			1: begin
				AN <= 4'b1101;
				C <= 8'b10001000;
			end
			
			2: begin
				AN <= 4'b1110;
				C <= 8'b11000111;
			end
			
			3: begin
				AN <= 4'b0111;
				C <= 8'b11000010;
			end
		endcase
	end
	else begin
	//choose which anode to light up and which digit value to display
		case(digit)
			0: begin
				AN <= 4'b0111;
				value <= removedCards % 10;
				case(value)
					0: C <= 8'b11000000;
					1: C <= 8'b11111001;
					2: C <= 8'b10100100;
					3: C <= 8'b10110000;
					4: C <= 8'b10011001;
					5: C <= 8'b10010010;
					6: C <= 8'b10000010;
					7: C <= 8'b11111000;
					8: C <= 8'b10000000;
					9: C <= 8'b10010000;
				endcase
			end
			
			1: begin
				AN <= 4'b1011;
				value <= removedCards / 10;
				case(value)
					0: C <= 8'b11000000;
					1: C <= 8'b11111001;
					2: C <= 8'b10100100;
					3: C <= 8'b10110000;
					4: C <= 8'b10011001;
					5: C <= 8'b10010010;
					6: C <= 8'b10000010;
					7: C <= 8'b11111000;
					8: C <= 8'b10000000;
					9: C <= 8'b10010000;
				endcase
			end
			
			2: begin
				AN <= 4'b1101;
				C <= 8'b11111111;
			end
			
			3: begin
				AN <= 4'b1110;
				C <= 8'b11111111;
			end
		endcase
	end
end

endmodule
