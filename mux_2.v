module mux_2(SW, outh1, outh2, outh3, outh4, CLOCK_50, KEY, outLed);
        input [14:0] SW ;
        input [3:0] KEY;
        input CLOCK_50; 
        output reg [4:0] outh1, outh2, outh3, outh4, outLed;
	
	
	wire [4:0] rouletteOut, rouletteEDOut, blackjackOut;
        wire [4:0] drandnum, prandnum, player, dealer, winner;
        wire [4:0] regularRouletteOut, EvenOddRouletteOut, slotsRand;
	
	wire [4:0] slotOut1, slotOut2, slotOut3;
	
       // Generate random numbers
       randomNumberModule c0(.enable(1'b1), 
		  .clock(CLOCK_50), 
		  .reset_n(KEY[0]),
		  .q(prandnum),
		  .load(KEY[2])  //Get random card for deler when they press KEY[2]
		);

       randomNumberModule c1(.enable(1'b1), 
		  .clock(CLOCK_50), 
		  .reset_n(KEY[0]),
		  .q(drandnum),
		  .load(KEY[3])  //Get random card for player when they press KEY[3]
		);
		
       randomNumberModule c2(.enable(1'b1), 
		  .clock(CLOCK_50), 
		  .reset_n(KEY[0]),
		  .q(slotsRand),
		  .load(KEY[1])  //Get random card for player when they press KEY[3]
		);
   
        //CREATE AN INSTANCE OF ALL THE GAMES
	roulette r0(.Clock(CLOCK_50),
		    .reset_n(KEY[0]),
		    .playerGuess(SW[4:0]),
		    .fsm_out(rouletteOut),
		    .randnum(prandnum),
		    .startGame(KEY[2]),
		    .playerBalance(regularRouletteOut)
		    );
	
	roulette_guessEvenOdd r1(.Clock(CLOCK_50),
			         .reset_n(KEY[0]),
				 .playerGuess(SW[4:0]),
				 .fsm_out(rouletteEDOut),
				 .randnum(prandnum),
				 .startGame(KEY[2]),
				 .playerBalance(EvenOddRouletteOut)
				 );
							
	statemachine s0(.Clock(CLOCK_50), 
					.reset_n(KEY[0]), 
					.enter(KEY[3]), 
					.pass(KEY[2]), 
					.phand(player), 
					.dhand(dealer),
					.fsm_out(blackjackOut),
					.prandnumwire(prandnum),
					.drandnumwire(drandnum)
					); 
	slots slotsGame(.clk(CLOCK_50),
					.randomNum1(drandnum),
					.randomNum2(prandnum),
					.randomNum3(slotsRand),
					.fsm_out(winner), 
					.key_1(KEY[3]), 
					.key_2(KEY[2]), 
					.key_3(KEY[1]),
					.t1(slotOut1),
					.t2(slotOut2),
					.t3(slotOut3));

	always @(*)
	begin
		case (SW[9:7])
			3'b000: //Output for roulette
					 begin
			       outh1 <= 5'b00000;
			       outh2 <= 5'b00000;
			       outh3 <= regularRouletteOut;  //Third 2 hexes is the player's score
			       outh4 <= prandnum;     //Last 2 hexes to the right show the random number
			       outLed <= rouletteOut;
					 end
			3'b001: //Ouput for even or odd roulette
			       begin
			       outh1 <= 5'b00000;
			       outh2 <= 5'b00000;
			       outh3 <= EvenOddRouletteOut; //Player's score
			       outh4 <= prandnum; //Random number
			       outLed <= rouletteEDOut;
					 end
			3'b011: //Output for blackjack
			       begin
			       outh1 <= player;
			       outh2 <= dealer;
			       outh3 <= prandnum;
			       outh4 <= drandnum;
			       outLed <= blackjackOut;
					 end
	      3'b111: //Output for random number game for two players
			       begin
			       outh1 <= 5'b00000;
			       outh2 <= 5'b00000;
			       outh3 <= prandnum;
			       outh4 <= drandnum;
			       outLed <= 5'b00000;
			       end
			3'b101://Output for slots
			       begin
			       outh1 <= slotOut1;
			       outh2 <= slotOut2;
			       outh3 <= slotOut3;
			       outh4 <= 5'b00000;
			       outLed <= winner;
			       end
			default://All hexes are 00
			       begin
			       outh1 <= 5'b00000;
			       outh2 <= 5'b00000;
			       outh3 <= 5'b00000;
			       outh4 <= 5'b00000;
			       outLed <= 5'b00000;
					 end
		endcase
	end

endmodule
