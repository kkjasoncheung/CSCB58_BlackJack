module BlackJack(SW, HEX0, HEX1, HEX2, HEX3, CLOCK_50, KEY, LEDR);
   input [14:0] SW ;
	input [3:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0, HEX1, HEX2, HEX3;
	output [9:0] LEDR;
	
	//wire [3:0] rand_num;
	hex7seg h0(.IN(SW[7:0]),  //Add 4'b0000 b/c rand_num is 4 bit
		       .OUT0(HEX1[6:0]), 
		       .OUT1(HEX0[6:0]));
		       
	hex7seg h1(.IN(SW[14:8]), .OUT0(HEX3[6:0]), .OUT1(HEX2[6:0]));
	
	//counter c0(.enable(1'b1),  //Counter always counting from 1-10
	//	  .clock(CLOCK_50),
		//  .reset_n(KEY[3]),
		//  .q(rand_num),
		//  .load(KEY[1])
	//	);
		
	//statemachine bj(
	//	.Clock(CLOCK_50), .Reset(KEY[3]), .enter(KEY[2]), .pass(KEY[1]), .fsm_output(LEDR[0])
	//);

endmodule


module counter(enable, clock, reset_n, q, load);    //Count from 1 - 10
	input enable, clock, reset_n, load;
	reg [4:0] count;
	output reg [4:0] q; //Pick one = 4'b0001; 
	//q[3:0] = 4'b0001;
	//assign q = 4'b0001;    //To set the inital value(might have to delete)
	
	always @(posedge clock, negedge reset_n, negedge load)
	begin
	   if (load == 1'b0)
			  q <= count;
		else if (reset_n == 1'b0)
			begin
				count <= 4'b0001;
			end
		else if (enable == 1'b1)
			begin
				if (count == 4'b1010)
					count <= 4'b0001;
				else
					count <= count + 1'b1;
			end
	end
endmodule