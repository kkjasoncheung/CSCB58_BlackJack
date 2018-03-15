module BlackJack(SW, HEX0, HEX1, HEX2, HEX3, CLOCK_50, KEY);
   input [14:0] SW ;
	input [3:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0, HEX1, HEX2, HEX3;
	
	wire [5:0] lsfr_out;
	
	lfsr l0 (.out(lsfr_out)             ,  // Output of the counter
				.enable(KEY[2])          ,  // Enable  for counter
				.clk(CLOCK_50)             ,  // clock input
				.reset(KEY[0])              // reset input
				);
	
	hex7seg h0(.IN({1'b0, lsfr_out}), .OUT0(HEX1[6:0]), .OUT1(HEX0[6:0]));
	hex7seg h1(.IN(SW[14:8]), .OUT0(HEX3[6:0]), .OUT1(HEX2[6:0]));
	
endmodule