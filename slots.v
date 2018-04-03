// HOW TO USE:
//1. create a slower clock with the rate divider module and pass it in as clk
//2. create 3 instances of random numbers and connect those wires to 
// 		randomNum1, randomNum2, randomNum3 (also connected to HEXs)
//2a) The player will press KEY3, KEY2, KEY1 to choose the respective #s
//3. create an instance of slots in the top level BlackJack.v module
//4. connect the fsm_out to the LEDRs
// 4a) LEDRs turn on when the player wins
module slots(clk, randomNum1, randomNum2, randomNum3, fsm_out, key_1, key_2, key_3);
	input clk;
	input [4:0] randomNum1, randomNum2, randomNum3;
	input key_1, key_2, key_3; // key_1 == KEY3, key_2 == KEY2, key_3 == KEY1
	output reg [4:0] fsm_out;
	reg state = 3'b000;

	// FSM
	always @(*)
	begin
		case (state)

			3'b000: // INITIAL STATE
				begin
					fsm_out <= 5'b00000; // LEDs initially off
					if (key_1 == 1'b0) // KEY3 Pressed
						begin
							if (randomNum1 == 3'b111) // if first # is 7
								begin
									state <= 3'b001;
								end
							else
								begin
									state <= 3'b100; // go to losing state
								end
						end
				end
			3'b001: // first # is 7
				begin
					if (key_2 == 1'b0) // KEY2 Pressed
						begin
							if (randomNum2 == 3'b111) // if second # is 7
								begin
									state <= 3'b010;
								end
							else
								begin
									state <= 3'b100; // go to losing state
								end
						end
				end
			3'b010: // second # is 7
				begin
					if (key_3 == 1'b0) // KEY1 Pressed
						begin
							if (randomNum3 == 3'b111) // if third # is 7
								begin
									state <= 3'b011;
								end
							else
								begin
									state <= 3'b100; // go to losing state
								end
						end
				end
			3'b011: // third # is 7 AKA winning state
				begin
					fsm_out = 5'b11111; // turn LEDRs on
					if (key_3 == 1'b0) // Pressed KEY1 to restart
						begin
							state <= 3'b000;
						end
				end
			3'b100: // losing state
				begin
					if (key_3 == 1'b0) // Pressed KEY1 to restart
						begin
							state <= 3'b000;
						end
				end
		endcase
	end


endmodule