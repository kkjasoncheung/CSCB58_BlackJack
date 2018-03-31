module mux3to1(regularRouletteOut, evenOddRouletteOut, drandnum, select, outWire);
	input [4:0] regularRoulettOut;
	input [4:0] evenOddRouletteOut;
	input [4:0] drandnum;
	input [1:0] select;
	reg [4:0] x;
	output outWire;

	always @(select)
		begin
			// use select to choose output
			if (select == 2'b00)
				begin
					x = regularRoulettOut;
				end
			else if (select == 2'b01)
				begin
					x = evenOddRouletteOut;
				end
			else if (select == 2'b10) begin
					x = drandnum;
			end
		end
	assign outWire = x;
endmodule

module mux2to1(gameInput, select, outWire);
	input [4:0] gameInput;
	input [1:0] select;
	output [4:0] outWire;
	reg [4:0] x;
	
	always @(*)
		begin
			if (select == 2'b10)
				begin
					x = gameInput;
				end
			else if ()
				begin
					x = 4'b0000;
				end
		end
	assign outWire = x;
endmodule

