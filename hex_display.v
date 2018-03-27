module hex_display(IN,OUT0,OUT1);
  input [7:0] IN;
  output reg [6:0] OUT0,OUT1;

  always@(IN) 
		case(IN)
			5'b00000: begin OUT0 = 7'b1000000; OUT1 = 7'b1000000;  end //00
			5'b00001: begin OUT0 = 7'b1000000; OUT1 = 7'b1111001; end //01
			5'b00010: begin OUT0 = 7'b1000000; OUT1 = 7'b0100100; end //02
			5'b00011: begin OUT0 = 7'b1000000; OUT1 = 7'b0110000; end //03
			5'b00100: begin OUT0 = 7'b1000000; OUT1 = 7'b0011001; end //04
			5'b00101: begin OUT0 = 7'b1000000; OUT1 = 7'b0010010; end //05
			5'b00110: begin OUT0 = 7'b1000000; OUT1 = 7'b0000010; end //06
			5'b00111: begin OUT0 = 7'b1000000; OUT1 = 7'b1111000; end //07
			5'b01000: begin OUT0 = 7'b1000000; OUT1 = 7'b0000000; end //08
			5'b01001: begin OUT0 = 7'b1000000; OUT1 = 7'b0011000; end //09
			5'b01010: begin OUT0 = 7'b1111001; OUT1 = 7'b1000000; end //10
			5'b01011: begin OUT0 = 7'b1111001; OUT1 = 7'b1111001; end //11
			5'b01100: begin OUT0 = 7'b1111001; OUT1 = 7'b0100100; end //12
			5'b01101: begin OUT0 = 7'b1111001; OUT1 = 7'b0110000; end //13
			5'b01110: begin OUT0 = 7'b1111001; OUT1 = 7'b0011001; end //14
			5'b01111: begin OUT0 = 7'b1111001; OUT1 = 7'b0010010; end //15
			5'b10000: begin OUT0 = 7'b1111001; OUT1 = 7'b0000010; end //16
			5'b10001: begin OUT0 = 7'b1111001; OUT1 = 7'b1111000; end //17
			5'b10010: begin OUT0 = 7'b1111001; OUT1 = 7'b0000000; end //18
			5'b10011: begin OUT0 = 7'b1111001; OUT1 = 7'b0011000; end //19
			5'b10100: begin OUT0 = 7'b0100100; OUT1 = 7'b1000000; end //20
			5'b10101: begin OUT0 = 7'b0100100; OUT1 = 7'b1111001; end //21
			5'b10110: begin OUT0 = 7'b0100100; OUT1 = 7'b0100100; end //22	
			5'b10111: begin OUT0 = 7'b0100100; OUT1 = 7'b0110000; end //23
			5'b11000: begin OUT0 = 7'b0100100; OUT1 = 7'b0011001; end //24
			5'b11001: begin OUT0 = 7'b0100100; OUT1 = 7'b0010010; end //25
			5'b11010: begin OUT0 = 7'b0100100; OUT1 = 7'b0000010; end //26
			5'b11011: begin OUT0 = 7'b0100100; OUT1 = 7'b1111000; end //27
			5'b11100: begin OUT0 = 7'b0100100; OUT1 = 7'b0000000; end //28
			5'b11101: begin OUT0 = 7'b0100100; OUT1 = 7'b0011000; end //29
			5'b11110: begin OUT0 = 7'b0110000; OUT1 = 7'b1000000; end //30
			5'b11111: begin OUT0 = 7'b0110000; OUT1 = 7'b1000000; end //31
			default: begin OUT0 = 7'b1000000; OUT1 = 7'b1000000; end
		endcase

endmodule