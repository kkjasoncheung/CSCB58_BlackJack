module mux_2(SW, outh1, outh2, outh3, outh4, CLOCK_50, KEY, outLed);
        input [14:0] SW ;
        input [3:0] KEY;
        input CLOCK_50; 
        output [4:0] outh1, outh2, outh3, outh4, outLed;
	
	
	wire [4:0] rouletteOut, rouletteEDOut, blackjackOut;
        wire [4:0] drandnum, prandnum, player, dealer, winner;
        wire [4:0] regularRouletteOut, EvenOddRouletteOut;

        //Add this module to the Blackjack file
	//-------------------------------FROM HERE---------------------------
	//wire [4:0] h1, h2, h3, h4, led; //Wires for the hexes and led
	//mux_2 m0(.SW(SW[14:0]), 
	         //.outh1(h1), 
		 //.outh2(h2), 
		 //.outh3(h3), 
		 //.outh4(h4), 
		 //.CLOCK_50(CLOCK_50), 
		 //.KEY(KEY[3:0]), 
		 //.LEDR(led));
	      
	//hex_display h0(.IN(h4), //Rightmost hex
		       //.OUT0(HEX1[6:0]), 
		       //.OUT1(HEX0[6:0])
		       //);
	//hex_display h1(.IN(h3), 
		       //.OUT0(HEX3[6:0]), 
		       //.OUT1(HEX2[6:0])
		       //);

	//hex_display h2(.IN(h2), 
		       //.OUT0(HEX5[6:0]), //Second left most hext
		       //.OUT1(HEX4[6:0]));
					  
	//hex_display h3(.IN(h1),  //Left most hex
		       //.OUT0(HEX7[6:0]),
                       //.OUT1(HEX6[6:0]));      
        //------------------------------TO HERE------------------------------
	

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
   
        //CREATE AN INSTANCE OF ALL THE GAMES
	roulette r0(.Clock(CLOCK_50),
		    .reset_n(SW[7]),
		    .playerGuess(SW[4:0]),
		    .fsm_out(rouletteOut),
		    .randnum(prandnum),
		    .startGame(KEY[2]),
		    .playerBalance(regularRouletteOut)
		    );
	
	roulette_guessEvenOdd r1(.Clock(CLOCK_50),
			         .reset_n(SW[7]),
				 .playerGuess(SW[4:0]),
				 .fsm_out(rouletteEDOut),
				 .randnum(prandnum),
				 .startGame(KEY[2]),
				 .playerBalance(EvenOddRouletteOut)
				 );
							
	statemachine s0(.Clock(CLOCK_50), 
					.reset_n(KEY[1]), 
					.enter(KEY[3]), 
					.pass(KEY[2]), 
					.phand(player), 
					.dhand(dealer),
					.fsm_out(blackjackOut),
					.prandnumwire(prandnum),
					.drandnumwire(drandnum)
					); 

	always @(*)
	begin
		case (SW[9:8])
			2'b00: //Output for roulette
			       outh1 <= 5'b00000;
			       outh2 <= 5'b00000;
			       outh3 <= regularRouletteOut;  //Third 2 hexes is the player's score
			       outh4 <= prandnum;     //Last 2 hexes to the right show the random number
			       outLed <= rouletteOut;
			2'b01: //Ouput for even or odd roulette
			       outh1 <= 5'b00000;
			       outh2 <= 5'b00000;
			       outh3 <= EvenOddRouletteOut; //Player's score
			       outh4 <= prandnum; //Random number
			       outLed <= rouletteEDOut;
			2'b11: //Output for blackjack
			       outh1 <= player;
			       outh2 <= dealer;
			       outh3 <= prandnum;
			       outh4 <= drandnum;
			       outLed <= blackjackOut;
			default:
			       outh1 <= 5'b00000;
			       outh2 <= 5'b00000;
			       outh3 <= 5'b00000;
			       outh4 <= 5'b00000;
			       outLed <= 5'b00000;
		endcase
	end

endmodule