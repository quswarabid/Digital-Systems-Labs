module snake(clk, snakeclk, scanCode, detected, xval0, xval1, xval2, xval3, xval4,
              yval0, yval1, yval2, yval3, yval4,start);
  input snakeclk,clk, detected;
  reg [1:0] dir;
  output reg [9:0] xval0, xval1, xval2, xval3, xval4, yval0, yval1, yval2, yval3, yval4;
  reg [9:0] xn,yn;
  reg [1:0] state, nextState;
  input [7:0] scanCode;
  reg pause;//,stallz,init;
  output reg start;
  reg restart;
  wire restartSP,freeze;
  assign freeze = ((xval4 <10'd630)&&(xval4 >0)&&(yval4 >0)&&(yval4 < 10'd470));
  initial begin
    restart <= 0;
    // running <= 0;
    start <= 0;
    pause <= 0;
  end

  singlePulse rst(snakeclk, restart, restartSP);

  always @(posedge clk) begin
    if ((scanCode == 8'h1b) && detected) begin//if S pressed
      if (start) //if already running, restart
        restart <= 1;
      else begin
        restart <= 0;
        start <= 1;
      end
      dir <= 2'b01;
  	  //init <= 1;
  	  pause <= 0;
  	  //stallz <= 0;
    end
    else begin
      restart <= 0;
      if (scanCode == 8'h76) start <= 0;
      else if (scanCode == 8'h4d) pause <= 1;
      else if (scanCode == 8'h2d) pause <= 0;
      else if (start && !pause && scanCode == 8'h75) dir <= 2'b00;
      else if (start && !pause && scanCode == 8'h74) dir <= 2'b01;
      else if (start && !pause && scanCode == 8'h72) dir <= 2'b10;
      else if (start && !pause && scanCode == 8'h6b) dir <= 2'b11;
    end
  end

  always @* begin
    //if (!stallz) begin//if ((xn == xval4)&&(yn == yval4)||(xn == xval3)&&(yn == yval3)||(xn == xval2)&&(yn == yval2)||(xn == xval1)&&(yn == yval1))  use this to check for internal collision
      case (state)
        0: begin
          xn <= xval4;
          yn <= yval4 - 10'd10;
          if (dir % 2) nextState <= dir;
          else nextState <= state;
        end
        1: begin
          xn <= xval4 + 10'd10;
          yn <= yval4;
          if (!(dir % 2)) nextState <= dir;
          else nextState <= state;
        end
        2: begin
          xn <= xval4;
          yn <= yval4 + 10'd10;
          if (dir % 2) nextState <= dir;
          else nextState <= state;
        end
        3: begin
          xn <= xval4 - 10'd10;
          yn <= yval4;
          //if moving left then restart, then go right
          if (restartSP && (dir == 2'b01)) nextState <= 2'b01;
          else if (!(dir % 2)) nextState <= dir;
          else nextState <= state;
        end
      endcase
    //end
  end

  always @(posedge snakeclk) begin
    state <= nextState;
  end

  initial begin
    xval0 <= 10'd0;
    yval0 <= 10'd240;
    xval1 <= 10'd10;
    yval1 <= 10'd240;
    xval2 <= 10'd20;
    yval2 <= 10'd240;
    xval3 <= 10'd30;
    yval3 <= 10'd240;
    xval4 <= 10'd40;
    yval4 <= 10'd240;
  end

  always @(posedge snakeclk) begin
    if (!start || restartSP) begin //||init
      xval0 <= 10'd0;
      yval0 <= 10'd240;
      xval1 <= 10'd10;
      yval1 <= 10'd240;
      xval2 <= 10'd20;
      yval2 <= 10'd240;
      xval3 <= 10'd30;
      yval3 <= 10'd240;
      xval4 <= 10'd40;
      yval4 <= 10'd240;
	  //init <= 0;
    end
    else if ((!pause) &&freeze) begin //&& (!stallz)
  		if (!((((xn == xval4)&&(yn == yval4))||((xn == xval3)&&(yn == yval3))||((xn == xval2)&&(yn == yval2))||((xn == xval1)&&(yn == yval1)))||(xn > 10'd630)||(xn < 10'd0)||(yn > 10'd470) ||(yn < 10'd0)))
  			begin
  			xval4 <= xn;
  			yval4 <= yn;
  			xval3 <= xval4;
  			yval3 <= yval4;
  			xval2 <= xval3;
  			yval2 <= yval3;
  			xval1 <= xval2;
  			yval1 <= yval2;
  			xval0 <= xval1;
  			yval0 <= yval1;
  			end
  		else
  			begin
  			xval4 <= xval4;
  			yval4 <= yval4;
  			xval3 <= xval3;
  			yval3 <= yval3;
  			xval2 <= xval2;
  			yval2 <= yval2;
  			xval1 <= xval1;
  			yval1 <= yval1;
  			xval0 <= xval4;
  			yval0 <= yval4;
  			//stallz <= 1;
  			end
  	end
	end
endmodule
