module lfsr    (
out             ,  // Output of the counter
enable          ,  // Enable  for counter
clk             ,  // clock input
reset              // reset input
);

 //----------Output Ports--------------
 output [5:0] out;
 //------------Input Ports--------------

 input enable, clk, reset;
 //------------Internal Variables--------
 reg [5:0] out;
wire linear_feedback;
reg [15:0] counter;
 
 //-------------Code Starts Here-------
 assign linear_feedback =  ! (out[4] ^ out[2]) ^ counter [8] ;
 assign linear_feedbac =  (out[1] ^ out[0]) ^ (!counter [3]) ;
always @(posedge clk)
begin
    counter = counter + linear_feedback;
	 if (reset) begin // active high reset
		out <= counter % 7'b0100000 ;
	end else if (enable) begin
		out <= {linear_feedbac,
				out[3],
				 out[2],out[1],
				 out[0], linear_feedback};
	   counter = counter + out;

	 end 
 end
 
endmodule // End Of Module counter