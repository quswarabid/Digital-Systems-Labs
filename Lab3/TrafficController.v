module trafficlight(clk, RST, Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw);
	input wire clk, RST;
	output wire Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw;
	reg [5:0] State;
	reg [5:0] NextState;
	reg Ga_int, Ya_int, Ra_int, Gb_int, Yb_int, Rb_int, Gw_int, Rw_int;
	
	assign Ga = Ga_int;
	assign Ya = Ya_int;
	assign Ra = Ra_int;
	assign Gb = Gb_int;
	assign Yb = Yb_int;
	assign Rb = Rb_int;
	assign Gw = Gw_int;
	assign Rw = Rw_int;
	
	initial begin
		State <= 0;
		NextState <= 0; 
	end

	always @(State) begin
		case(State)
			0, 1, 2, 3, 4, 5, 6, 7: begin //double states at twice frequency
				Ga_int <= 1;
				Ya_int <= 0;
				Ra_int <= 0;
				Gb_int <= 0;
				Yb_int <= 0;
				Rb_int <= 1;
				Gw_int <= 0;
				Rw_int <= 1;
				NextState <= State + 1;
			end
			8, 9, 10, 11: begin
				Ga_int <= 0;
				Ya_int <= 1;
				Ra_int <= 0;
				Gb_int <= 0;
				Yb_int <= 0;
				Rb_int <= 1;
				Gw_int <= 0;
				Rw_int <= 1;
				NextState <= State + 1;
			end
			12, 13, 14, 15, 16, 17: begin
				Ga_int <= 0;
				Ya_int <= 0;
				Ra_int <= 1;
				Gb_int <= 1;
				Yb_int <= 0;
				Rb_int <= 0;
				Gw_int <= 0;
				Rw_int <= 1;
				NextState <= State + 1;
			end
			18, 19: begin
				Ga_int <= 0;
				Ya_int <= 0;
				Ra_int <= 1;
				Gb_int <= 0;
				Yb_int <= 1;
				Rb_int <= 0;
				Gw_int <= 0;
				Rw_int <= 1;
				NextState <= State + 1;
			end
			20, 21, 22, 23: begin
				Ga_int <= 0;
				Ya_int <= 0;
				Ra_int <= 1;
				Gb_int <= 0;
				Yb_int <= 0;
				Rb_int <= 1;
				Gw_int <= 1;
				Rw_int <= 0;
				NextState <= State + 1;
			end
			24, 26, 28, 30: begin
				Ga_int <= 0;
				Ya_int <= 0;
				Ra_int <= 1;
				Gb_int <= 0;
				Yb_int <= 0;
				Rb_int <= 1;
				Gw_int <= 0;
				Rw_int <= 1;
				NextState <= State + 1;
			end
			25, 27, 29, 31: begin
				Ga_int <= 0;
				Ya_int <= 0;
				Ra_int <= 1;
				Gb_int <= 0;
				Yb_int <= 0;
				Rb_int <= 1;
				Gw_int <= 0;
				Rw_int <= 0;
				NextState <= State + 1;
			end
			//MAINTENANCE MODE
			32: begin //
				Ga_int <= 0;
				Ya_int <= 0;
				Ra_int <= 1;
				Gb_int <= 0;
				Yb_int <= 0;
				Rb_int <= 1;
				Gw_int <= 0;
				Rw_int <= 1;
				NextState <= 33; 
			end
			33: begin
				Ga_int <= 0;
				Ya_int <= 0;
				Ra_int <= 0;
				Gb_int <= 0;
				Yb_int <= 0;
				Rb_int <= 0;
				Gw_int <= 0;
				Rw_int <= 0;
				NextState <= 32; 
			end
			//should never occur
			default: begin 
				Ga_int <= 1'bx;
				Ya_int <= 1'bx;
				Ra_int <= 1'bx;
				Gb_int <= 1'bx;
				Yb_int <= 1'bx;
				Rb_int <= 1'bx;
				Gw_int <= 1'bx;
				Rw_int <= 1'bx;
				NextState <= 6'bxxxxxx; 
			end
		endcase
	end
	
	always @(posedge clk)
		if(RST)
			if (NextState == 6'd33)
				State <= NextState; 
			else 
				State <= 6'd32; 
		else 
			if (NextState == 6'd32 || NextState == 6'd33)
				State <= 0; 
			else
				State <= NextState;
		
endmodule

