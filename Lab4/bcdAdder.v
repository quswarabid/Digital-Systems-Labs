module BCD_Adder(X, Y, Zout);
  `define Xdig0 X[3:0]
  `define Xdig1 X[7:4]
  `define Xdig2 X[11:8]
  `define Xdig3 X[15:12]
  `define Ydig0 Y[3:0]
  `define Ydig1 Y[7:4]
  `define Ydig2 Y[11:8]
  `define Ydig3 Y[15:12]
  `define Zdig0 Z[3:0]
  `define Zdig1 Z[7:4]
  `define Zdig2 Z[11:8]
  `define Zdig3 Z[15:12]

  input [15:0] X, Y;
  output [15:0] Zout;
  wire [15:0] Z;
  wire [4:0] S0, S1, S2, S3;
  wire C0, C1, C2, C3;

  assign S0 = `Xdig0 + `Ydig0 ;
  assign `Zdig0 = (S0 > 9) ? S0[3:0] + 6 : S0[3:0];
  assign C0 = (S0 > 9) ? 1'b1 : 1'b0;

  assign S1 = `Xdig1 + `Ydig1 + C0;
  assign `Zdig1 = (S1 > 9) ? S1[3:0] + 6 : S1[3:0];
  assign C1 = (S1 > 9) ? 1'b1 : 1'b0;

  assign S2 = `Xdig2 + `Ydig2 + C1;
  assign `Zdig2 = (S2 > 9) ? S2[3:0] + 6 : S2[3:0];
  assign C2 = (S2> 9) ? 1'b1 : 1'b0;

  assign S3 = `Xdig3 + `Ydig3 + C2;
  assign `Zdig3 = (S3 > 9) ? S3[3:0] + 6 : S3[3:0];
  assign C3 = (S3 > 9) ? 1'b1 : 1'b0;

  //saturate to 9999
  assign Zout = (C3 == 1'b1) ? 16'b1001100110011001 : Z;

endmodule
