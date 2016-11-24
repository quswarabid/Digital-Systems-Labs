module Excess3DataFlow(X, CLK, S, V);
input X, CLK;
output S, V;

reg Q1;
reg Q2;
reg Q3;

initial
begin
Q1 = 0; 
Q2 = 0;
Q3 = 0; 
end

always @(negedge CLK)
begin
Q1 <= (Q2 & ~Q1) | (~Q3 & X) | (~Q3 & ~Q2 & Q1);
Q2 <= (~Q3 & ~Q2 & ~X) | (Q2 & ~Q1 & X) | (~Q3 & Q1 & X);
Q3 <= (Q2 & ~Q1 & ~X) | (~Q3 & Q2 & Q1) | (Q3 & ~Q2 & Q1);
end

assign S = (Q2 & ~X) | (~Q3 & ~Q1 & ~X) | (Q3 & ~Q2 & X) | (~Q2 & Q1 & X);
assign V = Q3 & Q2 & X;
endmodule

