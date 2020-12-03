///***************************************************
//
//	PrimeCounterBlock.v
//	
//	This module instantiates the block of Prime Counters used to construct a Sieve of Erasthonese and
//	the required control logic
//	
//	This block also instantiates an RTC to determine the time taken to determine the primes
//	
//	This block also instantiates a Down Counter to feed the compare values to the prime counters
//	
//	This module contains a LUT which lists the primes up to sqrt(1000000), or 1000. This corresponds to the 
//	first 168 prime numbers.
//	
//	
//	
//***************************************************/
//
//
//module PrimeComparator( DataIn, CompVal, isEqual);
//	
//	parameter inputs = 10;
//	parameter width = 20;
//
//	input [ (width * inputs) - 1 : 0 ] DataIn;
//	
//	input [width - 1 : 0 ] CompVal;
//	
//	wire [ width - 1 : 0 ] DataBus [inputs - 1 : 0];
//	
//	wire [ inputs - 1 : 0] CountMatch;
//	
//	output isEqual;
//	
//	// Assign outputs to bus, compare bus value to CompVal
//	genvar i;
//	generate
//		for (i=0; i <inputs ; i = i + 1) begin : CompareGen
//			assign DataBus[i] = DataIn[ (width * (i + 1)) - 1 : (width * i) ];
//			
//			assign CountMatch[i] = (DataBus[i] == CompVal) ;
//		end
//	endgenerate
//	
//	assign IsEqual = | (CountMatch) ;
//	
//endmodule
//	
//	
//	
//module CounterSM( clk, Reset_n, BlockEn, NotPrime, ValLoaded, CountFinished, NextState, NewValue, LoadValue);
//
//	parameter Ready = 0, Start = 1, Counting = 2, Found = 3;
//
//	input clk, Reset_n, BlockEn, NotPrime, ValLoaded, CountFinished;
//	
//	output [1:0] NextState;
//	output reg NewValue, LoadValue;
//	
//	reg [1:0] state = Ready;
//	
//	assign NextState = state;
//	
//	always@(posedge clk) begin
//		if(!Reset_n) begin
//			state <= Ready;
//		end
//		else begin
//			case(state) begin
//				
//				Ready:
//						LoadValue <= 0;
//						NewValue <= 0;
//					if(BlockEn) begin
//						state <= Start;
//					end
//					else begin
//						state <= Ready;
//					end
//				
//				Start:
//					LoadValue <= 1;
//					NewValue <= 0;
//					if(ValLoaded) begin
//						state <= Counting;
//					end
//					else begin
//						state <= start;
//					end
//					
//				Counting:
//					LoadValue <= 0;
//					
//					if(!NotPrime && !CountFinished) begin
//						NewValue <= 0;
//						state <= Counting;
//					end
//					else if(!NotPrime && CountFinished) begin
//						state <= Found;
//						NewValue <= 0;
//						
//					else if (NotPrime) begin
//						state <= Ready;
//						NewValue <= 1;
//					end
//					else begin
//						state <= Counting;
//						NewValue <= 0;
//					end
//				Found:
//					LoadValue <= 0;
//					NewValue <= 0;
//			endcase
//		end
//		
//	end
//
//endmodule
//
//
//module PrimeCounterBlock(clk, PrimeSearchLimit, Reset_n, CounterBlockEnable, LargestPrime, Complete);
//
//	parameter NUM_COUNTERS = 10;
//	parameter COUNTER_WIDTH = 20;
//	parameter COUNTER_MAX = 1000000;
//	
//	parameter [ 0 : (NUM_COUNTERS * 10 ) - 1 ] PRIMES = { 10'd2, 10'd3, 10'd5, 10'd7, 10'd11, 10'd13, 10'd17, 10'd19,  10'd19, 10'd23 };
//	
//	input clk;
//	input [19:0] PrimeSearchLimit;
//	input Reset_n;
//	input CounterBlockEnable;
//	
//	reg [19:0] CounterValues_out [NUM_COUNTERS - 1 : 0] = 0;
//	wire [19:0] CounterValues [NUM_COUNTERS - 1 : 0];
//	
//	output [19:0] LargestPrime;
//	output Complete;
//	
//	wire [NUM_COUNTERS - 1 : 0] CounterDone;
//	wire [NUM_COUNTERS - 1 : 0] CounterEnable;
//	
//	wire NotPrime;
//	wire PrimeVal;
//		
//	
//	
//	////////////////////////////////////////
//	
//	// Generation of Counters
//	
//	reg [ COUNTER_WIDTH - 1 : 0 ] CompVal = 0;
//	
//	
//	always@ (posedge clk or negedge Reset_n ) begin
//		if( !Reset_n ) begin
//			CompVal <= 0;
//			CounterEnable <= 0;
//		end
//		else begin
//			if (CounterBlockEnable) begin
//				CompVal <= PrimeSearchLimit;
//				CounterEnable <= {NUM_COUNTERS{1'b1}};		// Replication operator
//				if (!CounterDone) begin
//					if (NotPrime) begin
//						Comp
//					
//			end
//			else begin
//				CompVal <= CompVal;
//		end
//		
//		if(NotPrime && !CountFinished) begin
//			CompVal <= CompVal - 1;
//		end
//			
//	
//	genvar i;
//	
//	generate
//		for (	i = 0; i < NUM_COUNTERS; i = i + 1) begin : PrimeCounters
//			PrimeCounter CountByPrime ( .Clock(clk),
//												 .Reset_n(Reset_n),
//												 .En(CounterEnable[i]),
//												 .Increment(PRIMES[ ((i + 1) * 10) - 1 : (i * 10)  ] ),
//												 .TC(CounterDone[i]),
//												 .Count(CounterValues[i])
//												 );
//												 
//												 
//												 
//												 
//		end
//	endgenerate
//	
//	assign CountFinished = &(CounterDone);
//	
//	// Block gets the values from each counter, to be passed to comparator
//	always@(posedge clk) begin
//		if(!Reset_n) begin
//			CounterValues_out <= 0;
//		end
//		else begin
//			if (CounterBlockEnable) begin
//				CounterValues_out <= CounterValues;
//			end
//		
//			else begin
//				CounterValues_out <= CounterValues_out;
//			end
//		end
//	end
//	
//
//	// If all counters reach the limit without a match generated, current CompVal is not prime
//	
//	PrimeComparator CountCompare( .DataIn( CounterValues_out ) ,
//											.CompVal( CompVal ),
//											.IsEqual( NotPrime )
//											);
//	
//	
//	
//	
//	
//
//	
//	
//	
//	
//endmodule
