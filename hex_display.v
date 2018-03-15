module hex7seg(IN,OUT0,OUT1);
  input [7:0] IN;
  output reg [6:0]OUT0,OUT1;

  always@(IN) 
		case(IN)
			8'b00000000: begin OUT0 = 7'b1000000; OUT1 = 7'b1000000 ;  end //00
			8'b00000001: begin OUT0 = 7'b1000000; OUT1 = 7'b1111001; end //01
			8'b00000010: begin OUT0 = 7'b1000000; OUT1 = 7'b0100100; end //02
			8'b00000011: begin OUT0 = 7'b1000000; OUT1 = 7'b0110000; end //03
			8'b00000100: begin OUT0 = 7'b1000000; OUT1 = 7'b0011001 ; end //04
			8'b00000101: begin OUT0 = 7'b1000000; OUT1 = 7'b0010010; end //05
			8'b00000110: begin OUT0 = 7'b1000000; OUT1 = 7'b0000010; end //06
			8'b00000111: begin OUT0 = 7'b1000000; OUT1 = 7'b1111000; end //07
			8'b00001000: begin OUT0 = 7'b1000000; OUT1 = 7'b0000000; end //08
			8'b00001001: begin OUT0 = 7'b1000000; OUT1 = 7'b0011000; end //09
			8'b00001010: begin OUT0 = 7'b1111001; OUT1 = 7'b1000000 ; end //10
			8'b00001011: begin OUT0 = 7'b1111001; OUT1 = 7'b1111001; end //11
			8'b00001100: begin OUT0 = 7'b1111001; OUT1 = 7'b0100100; end //12
			8'b00001101: begin OUT0 = 7'b1111001; OUT1 = 7'b0110000; end //13
			8'b00001110: begin OUT0 = 7'b1111001; OUT1 = 7'b0011001; end //14
			8'b00001111: begin OUT0 = 7'b1111001; OUT1 = 7'b0010010; end //15
			8'b00010000: begin OUT0 = 7'b1111001; OUT1 = 7'b0000010; end //16
			8'b00010001: begin OUT0 = 7'b1111001; OUT1 = 7'b1111000; end //17
			8'b00010010: begin OUT0 = 7'b1111001; OUT1 = 7'b0000000; end //18
			8'b00010011: begin OUT0 = 7'b1111001; OUT1 = 7'b0011000; end //19
			8'b00010100: begin OUT0 = 7'b0100100; OUT1 = 7'b1000000; end //20
			8'b00010101: begin OUT0 = 7'b0100100; OUT1 = 7'b1111001; end //21
			
			default: begin OUT0 = 7'b1000000; OUT1 = 7'b1000000; end
		endcase

endmodule