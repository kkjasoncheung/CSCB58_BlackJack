module BlackJack(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, CLOCK_50, KEY, LEDR);
   input [14:0] SW;
   input [3:0] KEY;
   input CLOCK_50; 
   output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
   output [9:0] LEDR;
	
	wire [4:0] regularRouletteOut;
	wire [4:0] EvenOddRouletteOut;
	wire [4:0] wire01; // use MUX to determine which roulette game to output
	wire [4:0] wire23;
	wire [4:0] wire45;
	wire [4:0] wire67;
   wire [4:0] drandnum, prandnum, player, dealer, winner;
   assign LEDR[9:5] = winner;


   // Generate random numbers
   randomNumberModule c0(.enable(1'b1), 
		  .clock(CLOCK_50), 
		  .reset_n(KEY[1]),
		  .q(prandnum),
		  .load(KEY[2])  //Get random card for deler when they press KEY[2]
		);

   randomNumberModule c1(.enable(1'b1), 
		  .clock(CLOCK_50), 
		  .reset_n(KEY[1]),
		  .q(drandnum),
		  .load(KEY[3])  //Get random card for player when they press KEY[3]
		);
		
	// WITHOUT using Generate instances
	// create instances of each game
	roulette r0(.Clock(CLOCK_50),
							.reset_n(SW[7]),
							.playerGuess(SW[4:0]),
							.fsm_out(winner),
							.randnum(prandnum),
							.startGame(KEY[2]),
							.playerBalance(regularRouletteOut)
							);
	
	roulette_guessEvenOdd r1(.Clock(CLOCK_50),
							.reset_n(SW[7]),
							.playerGuess(SW[4:0]),
							.fsm_out(winner),
							.randnum(prandnum),
							.startGame(KEY[2]),
							.playerBalance(EvenOddRouletteOut)
							);
							
	statemachine s0(.Clock(CLOCK_50), //Make rand num generator output 5 bit and remember to do the reset part
					.reset_n(KEY[1]), 
					.enter(KEY[3]), 
					.pass(KEY[2]), 
					.phand(player), 
					.dhand(dealer),
					.fsm_out(winner),
					.prandnumwire(prandnum),
					.drandnumwire(drandnum)
					); 
			
	// create HEX modules to display output of games. We need a max. of 4 HEXs.
	
	// only use 2 HEXs for roulette games
	hex_display h0(.IN(wire01), //wire01 player's balance in Roulette, Dealer's Random # in BlackJack
						.OUT0(HEX1[6:0]), 
						.OUT1(HEX0[6:0])
						);
	hex_display h1(.IN(prandnum), //wire23 display randomly generate number in Roulette, Player's Random # in BlackJack 
						.OUT0(HEX3[6:0]),
						.OUT1(HEX2[6:0])
						);

	// remaining HEXs for BlackJack
	hex_display h2(.IN(wire45), //display dealers' score on right
					  .OUT0(HEX5[6:0]),
					  .OUT1(HEX4[6:0]));
					  
	hex_display h3(.IN(wire67), //display player's score on left
					  .OUT0(HEX7[6:0]),
					  .OUT1(HEX6[6:0]));
					  
	// create instances of muxs for h0, h2 and h3.
	
	
	// use 2 more HEXS for BlackJack game
						
	// conditionally generate instances 
	// Solution found on Stack Overflow
	// https://stackoverflow.com/questions/15240591/conditional-instantiation-of-verilog-module
   // Use SW[14:12] To select game
	
		// SW[14] ON for roulette 
			
				
				
		// SW[13] ON for roulette_guessEvenOdd
			
		// SW[12] ON for BlackJack
			
				

	
//   hex_display h2(.IN(rouletteOut), //display dealer's random number
//		  .OUT0(HEX1[6:0]), 
//		  .OUT1(HEX0[6:0]));
//		       
//   hex_display h3(.IN(prandnum), //display player's random number
//		  .OUT0(HEX3[6:0]),
//		  .OUT1(HEX2[6:0]));
//   wire [4:0] rouletteOut;
//	roulette_guessEvenOdd r0(.Clock(CLOCK_50), .reset_n(SW[7]), .playerGuess(SW[0]), .fsm_out(winner), .randnum(prandnum), .startGame(KEY[2]), .playerBalance(rouletteOut));  
//   hex_display h2(.IN(dealer), 
//		  .OUT0(HEX5[6:0]), 
//		  .OUT1(HEX4[6:0]));
//		       
//   hex_display h3(.IN(player), 
//		  .OUT0(HEX7[6:0]), 
//		  .OUT1(HEX6[6:0]));
//				 
endmodule

// random number generator
module randomNumberModule(enable, clock, reset_n, q, load);    //Count from 1 - 10
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
	   else if(enable == 1'b1)
	      begin
	         if(count == 5'b01010)
	            count <= 5'b00001;
	         else
	            count <= count + 1'b1;
	      end
	end
endmodule