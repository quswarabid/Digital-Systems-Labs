module fourBCDdec(CLK, enable, load, D, Q);
    input [15:0] D;
    input CLK, enable, load;
    output [15:0] Q; //???? inout due to zero saturation assignment?

    wire carry1, enable2, carry2, enable3, carry3, enable4, carry4;

    //zero saturation- if zero stop decrementing
    assign enable1 = (Q == 16'd0) ? 1'b0 : enable;
    assign enable2 = carry1;
    assign enable3 = carry2;
    assign enable4 = carry3;

    BCDdec count1(CLK, D[3:0], Q[3:0], carry1, enable1, load);
    BCDdec count2(CLK, D[7:4], Q[7:4], carry2, enable2, load);
    BCDdec count3(CLK, D[11:8], Q[11:8], carry3, enable3, load);
    BCDdec count4(CLK, D[15:12], Q[15:12], carry4, enable4, load);

endmodule

module BCDdec(CLK, D, Q, CO, ENABLE, LOAD);
	  input CLK, ENABLE, LOAD;
	  input [3:0] D;
	  output CO;
	  output [3:0] Q;

	  reg [3:0] Qin;
	  assign Q = Qin;
	  assign CO = ENABLE & !Q[3] & !Q[2] & !Q[1] & !Q[0];

	  initial begin
		Qin = 0;
	  end

    reg [26:0] counter;
    reg clk1Hz;

    initial begin
        counter = 0;
        clk1Hz = 0;
    end

    always @(posedge CLK) begin
      if (LOAD) Qin <= D;
      else begin
        if(counter == 27'd100000000) begin
          counter <= 1;
          if(ENABLE) begin
            if(Qin == 4'b0000) Qin <= 4'b1001;
            else Qin <= Qin - 1;
          end
        end
        else counter <= counter + 1;
      end
    end
endmodule
