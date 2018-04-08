module BlackJack(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, CLOCK_50, KEY, LEDR);
   input [14:0] SW;
   input [3:0] KEY;
   input CLOCK_50; 
   output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
   output [9:0] LEDR;
	
	wire [4:0] regularRouletteOut; // wire for regular roulette game
	wire [4:0] EvenOddRouletteOut;// wire for roulette game more even/odd
	wire [4:0] wire01; // use MUX to determine which roulette game to output
	wire [4:0] wire23;
	wire [4:0] wire45;
	wire [4:0] wire67;
	wire [4:0] drandnum, prandnum, player, dealer, winner;
	wire [4:0] roulette_winner_wire, roulette_evenOdd_winner_wire, blackjack_winner_wire;
	wire [4:0] slot_num3; // wire for the third random number in slots
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

	
	// third random number for the slots game
	randomNumberModule c_1(.enable(1'b1), 
		  .clock(CLOCK_50), 
		  .reset_n(KEY[1]),
		  .q(slot_num3),
		  .load(KEY[1])  //Get random number for player when they press KEY[1]
		);
	// WITHOUT using Generate instances
	
	// CREATE MODULE FOR SLOTS.V GAME
	slots slotsGame(.clk(CLOCK_50),
					.randomNum1(drandnum),
					.randomNum2(prandnum),
					.randomNum3(slot_num3),
					.fsm_out(winner), 
					.key_1(KEY[3]), 
					.key_2(KEY[2]), 
					.key_3(KEY[1]));

	
	// only use 2 HEXs for roulette games
	hex_display h0(.IN(drandnum), //wire01 player's balance in Roulette, Dealer's Random # in BlackJack
						.OUT0(HEX1[6:0]), 
						.OUT1(HEX0[6:0])
						);
	hex_display h1(.IN(prandnum), //wire23 display randomly generate number in Roulette, Player's Random # in BlackJack 
						.OUT0(HEX3[6:0]),
						.OUT1(HEX2[6:0])
						);

	// remaining HEXs for BlackJack
	hex_display h2(.IN(slot_num3), //display dealers' score on right
						.OUT0(HEX5[6:0]),
						.OUT1(HEX4[6:0])
						);

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

// rate divider module
module rateDivider(clk, divider);
	input clk;
	output reg divider;
	reg [25:0] counter;
	always @ (posedge clk)
		begin
			counter <= counter + 1'b1;
			if (counter == 26'b1011111010111100001000000)
				begin
					counter <= 26'b00000000000000000000000000;
					divider <= divider + 1'b1;
				end
		end
endmodule

