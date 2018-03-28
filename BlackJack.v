module BlackJack(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, CLOCK_50, KEY, LEDR);
   input [14:0] SW ;
   input [3:0] KEY;
   input CLOCK_50; 
   output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
   output [9:0] LEDR;
	
   wire [4:0] drandnum, prandnum, player, dealer, winner;
   assign LEDR[9:5] = winner;
   hex_display h0(.IN(drandnum), //display dealer's random number
		  .OUT0(HEX1[6:0]), 
		  .OUT1(HEX0[6:0]));
		       
   hex_display h1(.IN(prandnum), //display player's random number
		  .OUT0(HEX3[6:0]),
		  .OUT1(HEX2[6:0]));
		
   hex_display h2(.IN(dealer), 
		  .OUT0(HEX5[6:0]), 
		  .OUT1(HEX4[6:0]));
		       
   hex_display h3(.IN(player), 
		  .OUT0(HEX7[6:0]), 
		  .OUT1(HEX6[6:0]));
				 
   counter c0(.enable(1'b1), 
		  .clock(CLOCK_50), 
		  .reset_n(KEY[1]),
		  .q(prandnum),
		  .load(KEY[2])  //Get random card for deler when they press KEY[2]
		);

   counter c1(.enable(1'b1), 
		  .clock(CLOCK_50), 
		  .reset_n(KEY[1]),
		  .q(drandnum),
		  .load(KEY[3])  //Get random card for player when they press KEY[3]
		);
		       
   statemachine s0(.Clock(CLOCK_50),    //Make rand num generator output 5 bit and remember to do the reset part
		  .reset_n(KEY[1]), 
		  .enter(KEY[3]), 
		  .pass(KEY[2]), 
		  .phand(player), 
		  .dhand(dealer),
		  .fsm_out(winner),
		  .prandnumwire(prandnum),
		  .drandnumwire(drandnum)
		  ); 
			
endmodule


module counter(enable, clock, reset_n, q, load);    //Count from 1 - 10
	input enable, clock, reset_n, load;
	output reg [4:0] q;

	reg [4:0] count;
	
	always @(posedge clock or negedge reset_n or negedge load)
	begin
	   if(load == 1'b0)
	      q <= count;
	   else if(reset_n == 1'b0)
	      begin
	         count <= 5'b00001;
	         q <= 5'b00000;  
	      end
	   else if(enable == 1'b0)
	      begin
	         if(count == 5'b01010)
	            count <= 5'b00001;
	         else
	            count <= count + 1'b1;
	      end
	end
endmodule