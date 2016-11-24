module Subtractor4(A, B, Bin, Diff, Bout);
input [3:0] A, B;
input Bin;
output [3:0] Diff;
output Bout; 

wire [3:1] C; 
wire Bin, Bout; 
bitSub s1(A[0], B[0], Bin, Diff[0], C[1]); 
bitSub s2(A[1], B[1], C[1], Diff[1], C[2]); 
bitSub s3(A[2], B[2], C[2], Diff[2], C[3]); 
bitSub s4(A[3], B[3], C[3], Diff[3], Bout); 

endmodule

