module keyReader (CLK, ps2clk, serialIn, scanCode, detected);
  input CLK, ps2clk, serialIn;
  output reg [7:0] scanCode;
  output wire detected;
  wire [21:0] Q;
  `define keyUp Q[8:1]

  shifter sh22bit(ps2clk, serialIn, Q);

  assign detected = (`keyUp == 8'hF0) ? 1 : 0;
  //assign scanCode = (detected) ? Q[19:12] : 8'd0; //scanCode2;

  always @(posedge CLK) begin
    if (detected) scanCode <= Q[19:12];
  end

endmodule

  // `define start_keyUp Q[21]
  // `define parity_keyUp Q[12]
  // `define stop_keyUp Q[11]
  // `define start_scanCode Q[10]
  // `define parity_scanCode Q[1]
  // `define stop_scanCode Q[0]
  // always @* begin
  //   if (!`start_keyUp && detected && (`parity_keyUp == ^`keyUp) && `stop_keyUp &&
  //       !`start_scanCode && (`parity_scanCode == ^`scanCode) && `stop_scanCode) CLR = 0;
  //   else CLR = 1;
  // end

module shifter (CLK, Shift_In, Q);
  input CLK, Shift_In;
  output reg [21:0] Q;

  initial Q <= 0;

  always @(negedge CLK) begin
    Q <= {Shift_In, Q[21:1]};
  end

endmodule
