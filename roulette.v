// THIS IS THE FIRST VERSION OF THE ROULETTE GAME. (1/2)
// THE VERSION OF THE ROULETTE GAME TO BE PLAYED IS DETERMINED BY THE MUX.
// This roulette game plays like the following:
// 1. Even or odd number
// 2. a particular number (between 1 and 31) - TODO: Currently the random # generator generates from 1 - 10
// 		Might need to create another module for the random # generator to generate from 1 - 31.
// 3. player gets starting balance of $10 displayed on a hex
// 		Each lose = -$1 balance
//		Each win = + $4 balance
// 4. if the player balance gets to >$20 then the game is over
// 5. if the player balance gets to $0 then the game is over
module roulette(Clock, reset_n, playerGuess, fsm_out, randnum, startGame, playerBalance);
	input Clock, reset_n;
	input [4:0] playerGuess;
	input [4:0] randnum;
	input startGame;
	wire [4:0] randnumwire;
	assign randnumwire = randnum;
	// output for LEDs to signal win/lose
	output reg [4:0] fsm_out;

	// declare register for money value.
	output reg [4:0] playerBalance = 5'b01010; // initialize with $10

	// declare and initialize state for FSM
	reg state = 2'b00;

	always @ (posedge reset_n or posedge startGame)
		case (state)
			// initial state
			2'b00:
				begin
					// reset all values
					playerBalance <= 5'b01010;
					if (startGame == 1'b0)
						begin
							state <= 2'b01;
						end
				end
			// compare against correct answer state
			2'b01:
				begin
					// If player wings
					if (playerGuess == randnumwire)
						begin
							// add $4 to player's balance
							playerBalance <= (playerBalance + 3'b100);
							// check if game is over
							if (playerBalance > 5'b10100)
								begin
									// take player to winning state
									state <= 2'b11;
								end
						end
					else
						begin
							// player loses $1
							playerBalance <= (playerBalance - 1'b1);
							// check if game is over
							if (playerBalance == 1'b0)
								begin
									// take player to losing state
									state <= 2'b01;
								end
						end
					// if player wants to reset game
					if (startGame == 1'b0) 
						begin
							state <= 2'b01;
						end
					// restart the game
					else if (reset_n == 1'b0)
						begin
							state <= 2'b00;
						end
				end
			// winning state
			2'b11:
				begin
					// TODO: Flash LEDs
					// restart game
					if (reset_n == 1'b0)
						state <= 2'b00;
				end
			// losing state
			2'b01:
				begin
					//flash RED LEDs
					fsm_out <= 5'b11111;
					// restart game
					if (reset_n == 1'b0)
						state <= 2'b00;
				end

		endcase


endmodule