module TwoBCDCounter(CLR, CLK, ENABLE, LOAD, UP, D1, D2, Q1, Q2, CO);
input CLR, ENABLE, LOAD, UP, CLK;
input [3:0] D1, D2; 
output CO;
output [3:0] Q1, Q2;

wire Carry1, enable2; 

assign enable2 = (ENABLE & LOAD) | Carry1; 

bcdCounter count1(CLK, D1, Q1, Carry1, ENABLE, LOAD, UP, CLR);
bcdCounter count2(CLK, D2, Q2, CO, enable2, LOAD, UP, CLR);

endmodule
