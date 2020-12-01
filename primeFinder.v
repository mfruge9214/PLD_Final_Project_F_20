/********************************************************
	File: primeFinder.v

			PLESD Final Project
	
	Authors: Atharva Nandanwar
						 &
					Mike Fruge
					
	Desctiption:
		This file is the top level user defined module for the Prime Finder project.
		This project is meant to take user input via the UI components, and will display 
			the largest prime number below the input value. 
		This module interfaces with the DE1_Golden_top file, which passes in the highest level of input
		
		
		
*********************************************************/






module primeFinder(clk, SW, KEYS, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	parameter DIGITS_OUT = 6;
	parameter WIDTH = 20;		// How many bits it takes to count to the  bits in limit
	//parameter BITS_IN = 20;			// Can handle 20 bits of input if we need to Using KEY 0 and KEY 1 to change between upper and lower bits
	

	input clk;
	input [9:0] SW;
	input [3:0] KEYS;
	
	output [9:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	
	
	wire Reset;
	
	assign Reset = KEYS[3];
	
	// Initial/Input State Signals
	wire [ WIDTH - 1 : 0] InputValue;
	
	// Calculate State Signals
	reg [ WIDTH - 1 : 0] TimeTaken = 0;
	wire CounterBlockEnable;
	
	
	// Diaplay State Signals
	reg [ WIDTH - 1 : 0] LargestPrime = 999999;
	
	reg [ WIDTH - 1 : 0] PrimeLimit;
	
	
	// HEX Display Variables
	//wire [ 3:0 ] DispValues [ DIGITS_OUT - 1 : 0 ];		// Values passed to BCD decoder
	
	wire [1:0] state_out;
	wire [1:0] DisplaySelect;
	
	reg [WIDTH - 1 : 0 ] DisplayVal;
	
	wire CountFinished;
	
	////////////////////////////////////////////////////////////////
	///////////////////////////////////
	
	// Display Values block
	
	always@(posedge clk) begin
		if(~state_out[1]) begin
			DisplayVal <= InputValue;		// Input States
		end
		else if (state_out[0]) begin
			DisplayVal <= TimeTaken;			// Calculating state (display time taken)
		end
		else if (~state_out[0]) begin		// Display Output State
			DisplayVal <= LargestPrime;
		end
		else begin
			DisplayVal <= 0;
		end
	end
	
	
	assign LEDR[0] = (~state_out[0] & ~state_out[1] );
	assign LEDR[1] = ( state_out[0] & ~state_out[1] );
	assign LEDR[2] = ( state_out[0] & state_out[1] );
	assign LEDR[3] = ( ~state_out[0] & state_out[1] );

			
	SevenSegment Display_0 (.value(DisplayVal[19:0]),
									.disp0(HEX0),
									.disp1(HEX1),
									.disp2(HEX2),
									.disp3(HEX3),
									.disp4(HEX4),
									.disp5(HEX5)
									);
									
	
	///////////////////////////////////////////////////////////////////
	
	
	// State Machine Instantiation
	PrimeStateMachine SM_0(.clk(clk) ,
									.SW(SW[9:0]),
									.KEYS(KEYS[3:0]), 
									.CountBlockDone(CountFinished), 
									//.LEDR(LEDR[9:0]), 
									.DispSelect(DisplaySelect),
									.LoadVal(InputValue[19:0]),
									.NextState(state_out[1:0]) 
									);
	
		always@(posedge clk) begin
		if(~state_out[1]) begin
			PrimeLimit <= InputValue;		// Input States
		end
		else if (state_out[0]) begin
			PrimeLimit <= InputValue;			// Calculating state (display time taken)
		end
		else if (~state_out[0]) begin		// Display Output State
			PrimeLimit <= 0;
		end
		else begin
			PrimeLimit <= 0;
		end
	end
		
	
	

	// Counter that displays Time Taken in seconds
	
	wire RTC_Reset;
	wire RTC_Enable;
	wire RTC_TC;
	
	reg temp_Count_Finished;
	
	assign RTC_Enable = (state_out[1] & state_out[0] );
	assign RTC_Reset = KEYS[3];
	
	assign LEDR[9] = RTC_Enable;
	assign LEDR[8] = RTC_TC;
									
	PrimeCounter CalculationTime( .Clock(clk),
											.Reset_n(RTC_Reset),
											.En(RTC_Enable),
											.TC(RTC_TC),
											.Count( )
											);
	defparam CalculationTime.width = 26;
	defparam CalculationTime.count_limit = 500000;
	defparam CalculationTime.rollover = 1;
	
	// Always Block to Increment Real Time Counter
	
	assign CountFinished = (TimeTaken >= 1000);
	
	assign LEDR[7] = CountFinished;
	//assign RTC_Reset = ~CountFinished;
	
	always@(posedge RTC_TC or negedge RTC_Reset) begin
		if(!RTC_Reset) begin
			TimeTaken <= 0;
		end
		
		else if(RTC_TC) begin
			TimeTaken <= TimeTaken + 1;
		end
		
			
	end
	
	
	
endmodule
	
	