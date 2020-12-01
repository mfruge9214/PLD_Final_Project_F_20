/***************************************************

	PrimeCounterBlock.v
	
	This module instantiates the block of Prime Counters used to construct a Sieve of Erasthonese and
	the required control logic
	
	This block also instantiates an RTC to determine the time taken to determine the primes
	
	This block also instantiates a Down Counter to feed the compare values to the prime counters
	
	This module contains a LUT which lists the primes up to sqrt(1000000), or 1000. This corresponds to the 
	first 168 prime numbers.
	
	
	
***************************************************/


module PrimeCounterBlock(clk, PrimeSearchLimit, Reset_n, CounterBlockEnable, LargestPrime);

	parameter NUM_COUNTERS = 10;
	parameter COUNTER_WIDTH = 20;
	parameter COUNTER_MAX = 1000000;
	
	parameter PRIMES = { 10'd2, 10'd3, 10'd5, 10'd7, 10'd11, 10'd13, 10'd17, 10'd19,  10'd19, 10'd23 };
	
	input clk;
	input [19:0] PrimeSearchLimit;
	input Reset_n;
	input CounterBlockEnable;
	
	output [19:0] LargestPrime;
	
	wire [NUM_COUNTERS - 1 : 0] CounterDone;
	wire [NUM_COUNTERS - 1 : 0] CounterEnable;
	
	genvar i;
	
	generate
		for (	i = 0; i < NUM_COUNTERS; i = i + 1) begin : PrimeCounters
			PrimeCounter CountByPrime ( .Clock(clk),
												 .Reset_n(Reset_n),
												 .En(CounterEnable[i]),
												 .TC(CounterDone[i]),
												 
												 
	
	
	
	
	
endmodule
