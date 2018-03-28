module mux(LEDR, SW);
	
	input [9:0] SW;
	output [1:0] OUTPUT;

	assign OUTPUT[1] = BlackJack(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, CLOCK_50, KEY, LEDR);
	assign OUTPUT[0] = roulette(Clock, reset_n, playerGuess, fsm_out, randnum, startGame, playerBalanceWire);

	always @(*)
	begin
		case (SW[9:0])
			3'b000: OUTPUT[0] = SW[0];
			3'b001: OUTPUT[0] = SW[1];
		endcase
	end

endmodule