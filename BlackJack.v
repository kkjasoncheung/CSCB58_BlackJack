module BlackJack(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, CLOCK_50, KEY, LEDR);
   input [14:0] SW;
   input [3:0] KEY;
   input CLOCK_50; 
   output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
   output [9:0] LEDR;
	wire [4:0] hout1, hout2, hout3, hout4, led; //Wires for the hexes and led
	assign LEDR[9:5] = led;
	mux_2 m0(.SW(SW[14:0]), 
	         .outh1(hout1), 
		 .outh2(hout2), 
		 .outh3(hout3), 
		 .outh4(hout4), 
		 .CLOCK_50(CLOCK_50), 
		 .KEY(KEY[3:0]), 
		 .outLed(led));
	      
	hex_display h0(.IN(hout4), //Rightmost hex
		       .OUT0(HEX1[6:0]), 
		       .OUT1(HEX0[6:0])
		       );
	hex_display h1(.IN(hout3), 
		       .OUT0(HEX3[6:0]), 
		       .OUT1(HEX2[6:0])
		       );

	hex_display h2(.IN(hout2), 
		       .OUT0(HEX5[6:0]), //Second left most hext
		       .OUT1(HEX4[6:0]));
					  
	hex_display h3(.IN(hout1),  //Left most hex
		       .OUT0(HEX7[6:0]),
                       .OUT1(HEX6[6:0]));      
endmodule

// random number generator
module randomNumberModule(enable, clock, reset_n, q, load);    //Count from 1 - 10
	input enable, clock, reset_n, load;
	output reg [4:0] q;

	reg [4:0] count;
	
	always @(posedge clock or negedge reset_n or negedge load)
	begin
		// gets the current number being generated
	   if(load == 1'b0)
	      q <= count;
		// if reset is clicked reset the counter
	   else if(reset_n == 1'b0)
	      begin
	         count <= 5'b00001;
	         q <= 5'b00000;  
	      end
		// continously looping through numbers from 1 to 10
	   else if(enable == 1'b1)
	      begin
	         if(count == 5'b01010)
	            count <= 5'b00001;
	         else
	            count <= count + 1'b1;
	      end
	end
endmodule

