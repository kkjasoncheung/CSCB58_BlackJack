// TODO: MUX MODULE
module mux(SW, OUTPUT);
		
	// 3 Options for the game.
	// 1. Roulette: guessing a particular number
	// 2. Roulette: guessing even or odd number
	// 3. BlackJack: 21
	
	input [1:0] SW;
	output [2:0] OUTPUT;

	// create modules needed for casino
//	assign OUTPUT[2] = BlackJack(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, CLOCK_50, KEY, LEDR);
//	assign OUTPUT[1] = roulette(Clock, reset_n, playerGuess, fsm_out, randnum, startGame, playerBalanceWire);
//	assign OUTPUT[0] = roulette_EvenOdd(Clock, reset_n, playerGuess, fsm_out, randnum, startGame, playerBalanceWire);

//	always @(*)
//	begin
//		case (SW[9:0])
//			3'b000: OUTPUT[0] = SW[0];
//			3'b001: OUTPUT[1] = SW[1];
//			3'b010: OUTPUT[2] = SW[2];
//		endcase
//	end

endmodule

// TODO: Incomplete Module
