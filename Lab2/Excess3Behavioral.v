module Excess3Behavioral(X, CLK, S, V);
input X, CLK;
output S, V;
wire X, CLK, S, V;
reg [2:0] State;

initial
begin
  State = 0;
end

always @(negedge CLK)
begin
  case(State)
    0: begin 
	if (X == 1'b0) State <= 1;
       	else State <= 2;
	end
    1: begin 
	if (X == 1'b0) State <= 3;
        else State <= 4;
	end
    2: begin 
	if (X == 1'b0) State <= 4;
        else State <= 4;
	end
    3: begin 
	if (X == 1'b0) State <= 5;
        else State <= 5;
	end	
    4: begin 
	if (X == 1'b0) State <= 5;
        else State <= 6;
	end
    5: begin 
	if (X == 1'b0) State <= 0;
        else State <= 0;
	end
    6: begin 
	if (X == 1'b0) State <= 0;
        else State <= 0;
	end
  endcase
end 

assign S = (State == 0 && X == 0) || (State == 1 && X == 0) || (State == 2 && X == 1) 
           || (State == 3 && X == 1) || (State == 4 && X == 0) || (State == 5 && X == 1) 
	   || (State == 6 && X == 0);
assign V = (State == 6 && X == 1);

endmodule
