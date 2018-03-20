module statemachine(Clock, reset_n, enter, pass)

    reg [2:0] state, y;
    reg phand = 5'b00000;
    reg dhand = 5'b00000; 
    input Clock, reset_n, enter, pass

    always@(posedge Clock or negedge resetn)
        case (state)
            3'b000: if(enter)
                        // add 2 cards to player and dealer's hand
                        state = 3'b001
                    else
                        state = 3'b000
            3'b001: begin
                        if(enter)
                            begin
                                // add card to players hand
                                if(phand < 5'b10101)
                                    state = 3'b001
                                else
                                    state = 3'b011
                            end
                        else if(pass)
                            begin
                                while(dHand < 5'b10101)
                                    begin 
                                        // add card to dealer's hand
                                    end
                                if(dhand > 5'b10010)
                                    state = 3'b101
                                else if(phand > dhand)
                                    state = 3'b101
                                else
                                    state = 3'b011
                        else
                            state = 3'b001
                    end
            3'b011:  // player lose
                        if(reset_n)
                            phand = 5'b00000
                            dhand = 5'b00000
                            state = 3'b000
                        else
                            state = 3'b011
            3'b101: // player wins
                        if(reset_n)
                            phand = 5'b00000
                            dhand = 5'b00000
                            state = 3'b000
                        else
                            state = 3'b101
            default:
                        state = 3'b000
        end case
    end
end module
                    