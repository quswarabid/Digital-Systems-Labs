module bitSub(A, B, Bin, Diff, Bout);
input A, B, Bin; 
output Diff, Bout;
wire A, B, Bin, Diff, Bout; 
assign Diff = (~A&&~B&&Bin)||(~A&&B&&~Bin)||(A&&B&&Bin)||(A&&~B&&~Bin);
assign Bout = (~A&&Bin)||(~A&&B)||(B&&Bin);
endmodule
