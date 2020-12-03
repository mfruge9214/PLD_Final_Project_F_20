

/***************************************
   PrimeCounter.v
	this module creates a counter with parameters width (num bits), count_limit (The highest value of interest)
	and increment (the counter value)

***************************************/


module PrimeCounter(Clock, Reset_n, En, Increment, TC, Count);
	// Initial parameters, can be altered by higher level module
	parameter width = 32;
	parameter count_limit = 1000000;
	parameter rollover = 0;
	
	input Clock, En, Reset_n;
	input [9:0] Increment;
	
	output TC;
	
	output reg [width - 1 : 0 ] Count = 0;
	
	reg tc_reg;
	
	assign TC = tc_reg;		// TC high when Count Breaches Count Limit
	
	always @(posedge Clock or negedge Reset_n)
	
	begin
		if (!Reset_n) begin
			Count <= 0;
			tc_reg <= 0;
		end
		
		else begin
			if(Count >= (count_limit - 1) ) begin		// Counter either will stop counting or rollover
				tc_reg <= 1;
				
				if (rollover) begin
					Count <= 0;
				end
				else begin
					Count <= Count;
				end
			end
			else if(En && (Count < (count_limit - 1) ) ) begin
				Count <= Count + Increment;
				tc_reg <= 0;
			end
			
			else begin
				Count <= Count;
			end
		end
	end
endmodule
