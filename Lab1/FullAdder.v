module FullAdder (X, Y, Cin, Cout, Sum); 
output Cout, Sum;
input X, Y, Cin;
assign #10 Sum = X ^ Y ^ Cin;
assign #10 Cout = (X && Y) || (X && Cin) || (Y && Cin);
endmodule
