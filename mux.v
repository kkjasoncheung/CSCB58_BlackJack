// mux = mux3to1
module mux(in1, in2, in3, select, outWire);
	input [4:0] in1;
	input [4:0] in2;
	input [4:0] in3;
	input [1:0] select;
	reg [4:0] x;
	output [4:0] outWire;

	always @(select)
		begin
			// use select to choose output
			if (select == 2'b00)
				begin
					x = in1;
				end
			else if (select == 2'b01)
				begin
					x = in2;
				end
			else if (select == 2'b10) begin
					x = in3;
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
			else
				begin
					x = 4'b0000;
				end
		end
	assign outWire = x;
endmodule
