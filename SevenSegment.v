


module SevenSegment(value, disp0, disp1, disp2, disp3, disp4, disp5);
	input [19:0] value;
	output [6:0] disp0;
	output [6:0] disp1;
	output [6:0] disp2;
	output [6:0] disp3;
	output [6:0] disp4;
	output [6:0] disp5;
	
	wire [ 3:0 ] DispValues [  5 : 0 ];		// Values passed to BCD decoder
	
	assign DispValues[0] = value % 10;					
	assign DispValues[1] = (value/10) % 10;
	assign DispValues[2] = (value/100) % 10;
	assign DispValues[3] = (value/1000) % 10;
	assign DispValues[4] = (value/10000) % 10;
	assign DispValues[5] = (value/100000) % 10;

	BCD Disp_0( .value(DispValues[0]) , .disp(disp0) );
	BCD Disp_1( .value(DispValues[1]) , .disp(disp1) );
	BCD Disp_2( .value(DispValues[2]) , .disp(disp2) );
	BCD Disp_3( .value(DispValues[3]) , .disp(disp3) );
	BCD Disp_4( .value(DispValues[4]) , .disp(disp4) );
	BCD Disp_5( .value(DispValues[5]) , .disp(disp5) );	

endmodule

module BCD(value, disp);
	input [3:0] value;
	output reg [6:0] disp;

	always @(*)
	begin
		case(value)
			4'b0000 : disp [6:0] <= 7'b1000000;// 0 <= 7'h7E;
			4'b0001 : disp [6:0] <= 7'b1111001;// 1 <= 7'h60;
			4'b0010 : disp [6:0] <= 7'b0100100;// 2 <= 7'h6D;
			4'b0011 : disp [6:0] <= 7'b0110000;// 3 <= 7'h79;
			4'b0100 : disp [6:0] <= 7'b0011001;// 4 <= 7'h33;
			4'b0101 : disp [6:0] <= 7'b0010010;// 5 <= 7'h5B;
			4'b0110 : disp [6:0] <= 7'b0000010;// 6 <= 7'h5F;
			4'b0111 : disp [6:0] <= 7'b1111000;// 7 <= 7'h70;
			4'b1000 : disp [6:0] <= 7'b0000000;// 8 <= 7'h7F;
			4'b1001 : disp [6:0] <= 7'b0011000;// 9 <= 7'h7B;
			default:	disp [6:0] <= 7'b0000001;// 9 <= 7'h7B;
		endcase
	end	

endmodule