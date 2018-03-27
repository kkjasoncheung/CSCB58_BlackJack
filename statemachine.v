module statemachine(Clock, reset_n, enter, pass, phand, dhand, fsm_out, dcard, pcard, randnumwire);  //Dealer deals to himself with pass

    reg [2:0] state = 3'b000;
    output reg [4:0] phand = 5'b00000; //added the size of the register
    output reg [4:0] dhand = 5'b00000; 
    input Clock, reset_n, enter, pass;
    output reg [4:0] fsm_out; //initialized the starting value of the output
    output dcard, pcard;
	 input [4:0] randnumwire;
    
    wire [4:0] prand_num, drand_num, flash; //maybe change wire to a register
    assign dcard = drand_num;  //so it shows the card being dealt
    assign pcard = prand_num;
	 
	 wire [4:0] testwire;
	 assign testwire = randnumwire;
    
    counter c0(.enable(1'b1), 
		  .clock(Clock), //used CLOCK instead of Clock. that's why the random number didn't change
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

    counter c3(.enable(1'b1),  //it keeps counting from 1 to 10 in binary so it looks like its flashing on the LEDR's
		  .clock(Clock),
		  .reset_n(reset_n),
		  .q(flash),
		  .load(Clock) 
		);


    always@(posedge reset_n or negedge enter or negedge pass) //Not sure if I need the clock. "posedge clock" removed. Add back if it doesn't work.
        case (state)
//		        3'b001:begin
//				         fsm_out = 5'b11111; 
//				         if(enter == 1'b0)
//				             state <= 3'b000;
//							end
//								 
//				  3'b000: begin
//							fsm_out <= 5'b00000;
//				          if(enter == 1'b0)
//							    state <= 3'b001;
//							 end
            3'b000: if(enter == 1'b0)
		       // add 2 cards to player and dealer's hand
		                 begin
		                     phand =  testwire; //Might need <= instead of just =

		                     dhand = (dhand + 5'b00100);
		                     state <= 3'b001;
		                 end
                           else
                             state <= 3'b000;
            3'b001: begin
                        if(enter == 1'b0)  //player draws card until they pass or bust
                            begin
								        phand = phand + testwire;
                                // add card to players hand
                                if(phand < 5'b10101)
                                    state <= 3'b001;
			                       else if(phand == 5'b10101)  //win automatically if player hits 21
				                        state <= 3'b101;    
                                else
                                    state <= 3'b011;
                            end
                        else if(pass == 1'b0)  //dealer draws a card everytime pass is pressed, until they bust
                            begin
			                       dhand <= dhand + testwire;
                                if(dhand > 5'b10101)
                                    state <= 3'b101;   //player wins  
                                else if(dhand > phand)
                                    state <= 3'b011;   //player loses
				                    else if(dhand == 5'b10101) //dealer hits 21
				                         state = 3'b011;  //player loses
				                    else if(dhand < phand)
				                         state <= 3'b001;
				                    else
				                         state <= 3'b101; //dealer and player have the same score so just let the player win
				                end                  //it's different in real blackjack though
                    end
            3'b011:  // player lose
                        if(reset_n == 1'b0)
                            begin
                               phand <= 5'b00000;
                               dhand <= 5'b00000;
                               state <= 3'b000;
			                      fsm_out <= 5'b00000;
                            end
                        else
			    begin
			       fsm_out <= 5'b11111;
                               state <= 3'b011;
			    end
			    //dealer_score = dealer_score + 1;
			    
            3'b101: // player wins
                        if(reset_n == 1'b0)
                            begin
                               phand <= 5'b00000;
                               dhand <= 5'b00000;
                               state <= 3'b000;
			       fsm_out <= 5'b00000;
                            end
                        else
			    begin
			       fsm_out <= flash;
                               state <= 3'b101;
			    end
			    //player_score = player_score + 1;
            default:
                        state <= 3'b000;
        endcase
endmodule
                    