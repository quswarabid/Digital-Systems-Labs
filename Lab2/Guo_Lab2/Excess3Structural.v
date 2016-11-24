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
endmodule
