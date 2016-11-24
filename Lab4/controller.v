module Controller(CLK, add30, add120, add180, add300, rst15, rst185, fourSeven);
    input CLK, add30, add120, add180, add300, rst15, rst185;
    output reg [15:0] fourSeven;
	  reg [2:0] State, NextState;
    wire [15:0] bcdCount;
    wire twoHzClk;
    Divider twoHz(CLK, twoHzClk);
    ParkingMeter meter(CLK, add30, add120, add180, add300, rst15, rst185, bcdCount);
    reg [1:0] counter;

    always @(posedge twoHzClk) begin
      if (bcdCount == 0) begin //flash one on off per second
        if (fourSeven == 0) fourSeven <= 16'b1111111111111111;
        else fourSeven <= 0;
      end
      else if (rst15 || rst185) fourSeven <= bcdCount;
      else if (bcdCount < 16'b0000000110000010) begin
        if (bcdCount[0] == 0) begin //if even blank out
          if (counter == 2) begin
            fourSeven <= 16'b1111111111111111;
            counter <= 1;
          end
          else counter <= counter + 1; //divide two hertz clock
        end
        else begin
          if(counter == 2) begin
            fourSeven <= bcdCount;
            counter <= 1;
          end
          else counter <= counter + 1;
        end
      end
      else fourSeven <= bcdCount;
    end
endmodule


    // always @* begin
    //     case (State)
    //         //flash half second on
    //         0: begin
    //         		fourSeven <= 16'b0000000000000000;
    //         		NextState <= 1;
    //         end
    //         //flash half second off
    //         1: begin
    //             fourSeven <= 16'b1111111111111111; //all off
    //             NextState <= 0;
    //         end
    //         //flash one second on
    //         2, 3: begin
    //             fourSeven <= bcdCount;
    //             NextState <= State + 1;
    //         end
    //         //flash one second off
    //         4: begin
    //             fourSeven <= 16'b1111111111111111; //all off
    //             NextState <= 5;
    //         end
		// 	      5: begin
		// 		        fourSeven <= 16'b1111111111111111; //all off
    //             NextState <= 2;
		// 	      end
    //         6: begin
    //       			fourSeven <= bcdCount;
    //       			NextState <= 6;
    //         end
		// 	      default: begin
		// 		        fourSeven <= bcdCount;
		// 		        NextState <= 6;
		// 	      end
		//     endcase
    // end
    //
    // //state machine clock at 2Hz
    // always @(posedge twoHzClk) begin
    //     if(bcdCount == 16'd0) begin
    //         if(NextState == 1) State <= NextState;
    //         else State <= 0;
		//     end
    // 		else if (rst15 || rst185) begin
    // 			State <= 6;
    // 		end
    //     else if (bcdCount < 16'b0000000110000001) begin
    //             if((NextState != 2) && (NextState != 3)
    //                 && (NextState != 4) && (NextState != 5)) begin
    //                 if (bcdCount[0] == 1) State <= 2;
    //                 else State <= 4;
    //       			end
    //             else State <= NextState;
    //     end
    //     else State <= 6;
    // end
