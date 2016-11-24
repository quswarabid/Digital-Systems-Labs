module Top(CLK, D, Q, CO, ENABLE, LOAD, UP, CLR);
input CLR, ENABLE, LOAD, UP, CLK;
input [3:0] D;
output CO;
output [3:0] Q;

wire slowCLK; 

Divider clock2s(CLK, slowCLK); 
bcdCounter count(slowCLK, D, Q, CO, ENABLE, LOAD, UP, CLR);

endmodule
