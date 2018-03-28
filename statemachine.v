module statemachine(Clock, reset_n, enter, pass, phand, dhand, fsm_out, prandnumwire, drandnumwire);  //Dealer deals to himself with pass

    reg [2:0] state = 3'b000;
    output reg [4:0] phand = 5'b00000; //added the size of the register
    output reg [4:0] dhand = 5'b00000; 
    input Clock, reset_n, enter, pass;
    output reg [4:0] fsm_out; //initialized the starting value of the output
    input [4:0] drandnumwire, prandnumwire;
    
    wire [4:0] flash;

    counter c0(.enable(1'b1),  //it keeps counting from 1 to 10 in binary so it looks like its flashing on the LEDR's
		  .clock(Clock),
		  .reset_n(reset_n),
		  .q(flash),
		  .load(Clock) 
		);


    always@(posedge Clock, negedge reset_n, negedge enter, negedge pass) //try always@(*) or always@(posedge Clock)
        case (state)
            3'b000:begin
	            if(enter == 1'b0)
		       // add 2 cards to player the player's hand and 1 card to the dealer
		        begin
			   phand <= (phand + prandnumwire + drandnumwire);
		           dhand <= (dhand + drandnumwire);
		           state <= 3'b001;
		        end
		    else
		       state <= 3'b000;
		    end
            3'b001:begin
                        if(enter == 1'b0)  //player draws card until they pass or bust
                            begin
				phand <= phand + prandnumwire;
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
				dhand <= dhand + drandnumwire;
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
            3'b011:begin  // player lose
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
		   end    
            3'b101:begin // player wins
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
		    end
            default:
	        state <= 3'b000;
        endcase
endmodule
                    