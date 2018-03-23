module statemachine(Clock, reset_n, enter, pass, phand, dhand, fsm_out);  //Dealer deals to himself with pass

    reg [2:0] state = 3'b000;
    output reg phand = 5'b00000;
    output reg dhand = 5'b00000; 
    input Clock, reset_n, enter, pass;
    output reg [1:0] fsm_out;
    
    wire [4:0] prand_num, drand_num;
    
    counter c0(.enable(1'b1), 
		  .clock(Clock), //used CLOCK instead of clock. that's why the random number didn't change
		  .reset_n(reset_n),
		  .q(drand_num),
		  .load(enter)  //Get random card for player when they press enter
		);
    counter c1(.enable(1'b1), 
		  .clock(Clock),
		  .reset_n(reset_n),
		  .q(prand_num),
		  .load(pass)  //Get random card for dealer
		);

    always@(negedge reset_n or negedge enter or negedge pass) //Not sure if I need the clock, it doesn't do anything. "posedge clock" removed
        case (state)
            3'b000: if(enter == 1'b0)
		       // add 2 cards to player and dealer's hand
		       begin
		       phand = phand + prand_num; //Might need <= instead of just =
		       //enter = 0;
		       //enter = 1;
		       //pass = 0;
		       //pass = 1;
		       phand = phand + prand_num;
		       dhand = dhand + drand_num;
		       state <= 3'b001;
		       end
                    else
                        state <= 3'b000;
            3'b001: begin
                        if(enter == 1'b0)
                            begin
				phand = phand + prand_num;
                                // add card to players hand
                                if(phand < 5'b10101)
                                    state <= 3'b001;
                                else
                                    state <= 3'b011;
                            end
                        else if(pass == 1'b0)
                            begin
				if(dhand < phand)
				begin
				dhand = dhand + drand_num;
				tate <= 3'b001;
				end
                                if(dhand > 5'b10101)
                                    state <= 3'b101;
                                else if(phand > dhand)
                                    state <= 3'b101;
				else
				    state <= 3'b011; //LOSE STATE INSTEAD
				end
                    end
            3'b011:  // player lose
                        if(reset_n == 1'b0)
                            begin
                            phand <= 5'b00000;
                            dhand <= 5'b00000;
                            state <= 3'b000;
			    fsm_out <= 2'b00;
                            end
                        els
			    begin
			    fsm_out <= 2'b01;
                            state <= 3'b011;
			    end
			    //dealer_score = dealer_score + 1;
			    
            3'b101: // player wins
                        if(reset_n == 1'b0)
                            begin
                            phand <= 5'b00000;
                            dhand <= 5'b00000;
                            state <= 3'b000;
			    fsm_out <= 2'b00;
                            end
                        else
			    begin
			    fsm_out <= 2'b11;
                            state <= 3'b101;
			    end
			    //player_score = player_score + 1;
            default:
                        state <= 3'b000;
        endcase
endmodule
                    