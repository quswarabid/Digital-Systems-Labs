module Excess3Behavioral(X, CLK, S, V);
input X, CLK;
output S, V;
wire X, CLK, S, V;
reg [2:0] State;
initial
begin
  State = 0;
end

always @(posedge CLK)
begin
  case(State)
    0: if (X == 1'b0) State <= 1;
        else State <= 2;
    1: if (X == 1'b0) State <= 3;
        else State <= 4;
    2: if (X == 1'b0) State <= 4;
        else State <= 4;
    3: if (X == 1'b0) State <= 5;
        else State <= 5;
    4: if (X == 1'b0) State <= 5;
        else State <= 6;
    5: if (X == 1'b0) State <= 0;
        else State <= 0;
    6: if (X == 1'b0) State <= 0;
        else State <= 0;
  endcase
end

assign S = (State == 0 && X == 0) || (State == 1 && X == 0) || (State == 2 && X == 1) ||
            (State == 3 && X == 1) || (State == 4 && X == 0) || (State == 5 && X == 1) ||
            (State == 6 && X == 0);
assign V = (State == 6 && X == 1);

endmodule

module Excess3DataFlow(X, CLK, S, V);
input X, CLK;
output S, V;

reg Q1;
reg Q2;
reg Q3;

always @(posedge CLK)
begin
Q1 <= (Q2 & ~Q1) | (~Q3 & X) | (~Q3 & ~Q2 & Q1);
Q2 <= (~Q3 & ~Q2 & ~X) | (Q2 & ~Q1 & X) | (~Q3 & Q1 & X);
Q3 <= (Q2 & ~Q1 & ~X) | (~Q3 & Q2 & Q1) | (Q3 & ~Q2 & Q1);
end

assign S = (Q2 & ~X) | (~Q3 & ~Q1 & ~X) | (Q3 & ~Q2 & X) | (~Q2 & Q1 & X);
assign V = Q3 & Q2 & X;
endmodule


module Excess3Structural(X, CLK, S, V);
input X, CLK;
output S, V;
wire A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13;
wire D1, D2, D3, XN, VN;
wire Q1, Q2, Q3, Q1N, Q2N, Q3N;

Inverter I1(X, XN);
Nand3 G1(Q2, Q1N, XN, A1);
Nand3 G2(Q3N, Q2, Q1, A2);
Nand3 G3(Q3, Q2N, Q1, A3);
Nand3 G4(A1, A2, A3, D3);
DFF FF3(D3, CLK, Q3, Q3N);

Nand3 G5(Q3N, Q2N, XN, A4);
Nand3 G6(Q2, Q1N, X, A5);
Nand3 G7(Q3N, Q1, X, A6);
Nand3 G8(A4, A5, A6, D2);
DFF FF2(D2, CLK, Q2, Q2N);

Nand2 G9(Q2, Q1N, A7);
Nand2 G10(Q3N, X, A8);
Nand3 G11(Q3N, Q2N, Q1, A9);
Nand3 G12(A7, A8, A9, D1);
DFF FF1(D1, CLK, Q1, Q1N);

Nand2 G13(Q2, XN, A10);
Nand3 G14(Q3N, Q1N, XN, A11);
Nand3 G15(Q3, Q2N, X, A12);
Nand3 G16(Q2N, Q1, X, D13);
Nand4 G17(A10, A11, A12, A13, S);

Nand3 G18(Q3, Q2, X, VN);
Inverter I2(VN, V);

endmodule


module Nand2 (A1, A2, Z);
input A1, A2;
output Z;
assign Z = ~(A1 & A2);
endmodule


module Nand3 (A1, A2, A3, Z);
input A1, A2, A3;
output Z;
assign Z = ~(A1 & A2 & A3);
endmodule


module Nand4 (A1, A2, A3, A4, Z);
input A1, A2, A3, A4;
output Z;
assign Z = ~(A1 & A2 & A3 & A4);
endmodule


module DFF(D, CLK, Q, QN);
input D, CLK;
output Q, QN;

reg Q;
reg QN;

initial
begin
Q = 1'b0;
QN = 1'b1;
end
always @(posedge CLK)
begin
Q <= D;
QN <= ~D;
end endmodule


module Inverter (A, Z);
input A;
output Z;
assign Z = ~A;
endmodule;


module bcdCounter(CLK, D, Q, CO, ENABLE, LOAD, UP, CLR);
input CLK, ENABLE, LOAD, UP, CLR;
input [3:0] D;
output CO;
output [3:0] Q;

reg [3:0] Qin;
assign Q = Qin;
assign CO = ENABLE & ( (UP & Q[3] & !Q[2] & !Q[1] & Q[0]) ||
	(!UP & !Q[3] & !Q[2] & !Q[1] & !Q[0]) );

always @(CLR)
begin
if (CLR)
  Qin <= 4'b0000;
end

always @(posedge CLK )
begin
if (LOAD & ENABLE)
  Qin <= D;
else if (UP & ENABLE)
  begin
    if (Qin == 4'b1001)
      Qin <= 4'b0000;
    else
      Qin <= Qin + 1;
  end
else if (!UP & ENABLE)
  begin
    if (Qin == 4'b0000)
      Qin <= 4'b1001;
    else
      Qin <= Qin - 1;
  end
end
endmodule
