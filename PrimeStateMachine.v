

module PrimeStateMachine( clk, SW, KEYS, CountBlockDone, DispSelect, LoadVal, NextState);

	input clk;
	input [9:0] SW;
	input [3:0] KEYS;
	input CountBlockDone;
	
	//output [9:0] LEDR;
	output reg [1:0] DispSelect;
	output reg [19:0] LoadVal;
	output [1:0] NextState;
	
	reg [1:0] state;
	//reg [1:0] next_state;
	
	
	
	//reg [9:0] led_out;
	
	wire Reset;
	wire LSB_Entry;
	wire MSB_Entry;
	
	reg sync_LSB;
	reg sync_MSB;
	reg sync_Reset;
	
	assign Reset = KEYS[3];
	
	assign LSB_Entry = KEYS[0];
	assign MSB_Entry = KEYS[1];
	
	assign NextState = state;
	//assign LEDR = led_out;
	
	always@(posedge clk) begin : StateMachine
	
		parameter LSB_Load = 0, MSB_Load = 1, Calculate = 3, Display = 2;		// Gray Code States
		
		// Synchronize Inputs
		sync_LSB <= LSB_Entry;
		sync_MSB <= MSB_Entry;
		sync_Reset <= Reset;
		
		if(!sync_Reset) begin
			state <= LSB_Load;
			LoadVal <= 0;
			DispSelect <= 0;
			//CountBlockEnable <= 0;
			
		end
		else begin
			case (state)
				LSB_Load : begin
					//led_out <= 1;
					LoadVal[9:0] <= SW;
					DispSelect <= 0;
					
					if( !sync_LSB ) begin		// User presses the LSB_entry Button
						state <= MSB_Load;
					end
				end
				
				MSB_Load : begin
					//led_out <= 2;
					LoadVal[19:10] <= SW;
					DispSelect <= 0;
					
					if( !sync_MSB) begin		// User presses MSB_entry Button
						state <= Calculate;
					end
				end
				
				Calculate : begin
					//led_out <= 4;
					//CountBlockEnable <= 1;
					DispSelect <= 1;
					
					if(CountBlockDone) begin
						state <= Display;
					end
					else begin
						state <= Calculate;
					end
					
				end
				
				Display : begin
					//led_out <= 8;
					//CountBlockEnable <= 0;
					DispSelect <= 2;
				end
			endcase
		end
	end
					
					
endmodule
	