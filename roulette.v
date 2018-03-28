// roulette game with the following better options.
// 1. Even or odd number
// 2. a particular number (between 1 and 31)
// 3. player gets starting balance of $10 displayed on a hex
// 		Each lose = -$1 balance
//		Each win = + $2 balance
module roulette(Clock, reset_n, playerGuess, fsm_out, randnum, startGame, playerBalanceWire);
	input Clock, reset_n;
	input [4:0] playerGuess;
	input [4:0] randnum;
	wire [4:0] randnumwire;
	assign randnumwire = randnum;
	// output for LEDs to signal win/lose
	output reg [4:0] fsm_out;

	// declare register for money value.
	output reg [4:0] playerBalance = 5'b01010; // initialize with $10
	// create wire to wire out the playerBalance to top level module
	wire [4:0] playerBalanceWire;
	assign playerBalance = playerBalanceWire;

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
							// add $2 to player's balance
							playerBalance <= (playerBalance + 2'b10);
							// TODO: flash GREEN LEDs
						end
					else
						begin
							// player loses $1
							playerBalance <= (playerBalance - 1'b1);
							//flash RED LEDs
							fsm_out <= 5'b11111;
						end
					// if player wants to play again
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

		endcase


endmodule