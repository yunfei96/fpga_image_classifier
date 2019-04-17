module testclock(
	input					reset,
	input 		      clock,
	output		     [9:0]		LEDR
);

reg[31:0] counter, counternext;
reg[1:0] state,statenext;
assign LEDR[9] = (state==zero)? 1'b0:1'b1;


localparam one = 1, zero =0; 

always @(posedge clock or posedge reset)
begin
	if(reset)
	begin
		counter <= 32'b0;
		state <= zero;
	end 
	else
	begin
		counter <= counternext;
		state <= statenext;
	end
end


always @(*)
begin
	statenext = state;
	case(state)
		one: begin 
			if (counter != 32'd75000000)
				counternext = counter+1'b1;
			else
			begin
				statenext = zero;
				counternext = 32'b0;
			end
		end
		
		zero: begin
			if (counter != 32'd75000000)
				counternext = counter+1'b1;
			else
			begin
				statenext = one;
				counternext = 32'b0;
			end
		end
	endcase 
end

endmodule


// quartus_sh --flow compile tonegen
// quartus_pgm -m jtag -o "p;tonegen.sof@2"
