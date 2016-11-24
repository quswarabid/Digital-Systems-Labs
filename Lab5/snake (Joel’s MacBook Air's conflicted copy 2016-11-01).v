module snake (clk,dir,xval,yval);
  input clk;
  input [1:0] dir;
  output [9:0] xval,yval [0:4];

  reg [9:0] xval,yval [0:4];
  reg [9:0] xn,yn;

  initial begin
    xval[0] <= 10'd320;
    yval[0] <= 10'd240;
    xval[1] <= 10'd320;
    yval[1] <= 10'd250;
    xval[2] <= 10'd320;
    yval[2] <= 10'd260;
    xval[3] <= 10'd320;
    yval[3] <= 10'd270;
    xval[4] <= 10'd320;
    yval[4] <= 10'd280;
    dir <= 0;
  end

  always @* begin
    case (state)
      0: begin
        xn <= xval [0];
        yn <= yval [0] - 10'd10;
        if (dir % 2) nextState <= dir;
        else nextState <= state;
      end
      1: begin
        xn <= xval [0] + 10'd10;
        yn <= yval [0];
        if (!(dir % 2)) nextState <= dir;
        else nextState <= state;
      end
      2: begin
        xn <= xval [0];
        yn <= yval [0] + 10'd10;
        if (dir % 2) nextState <= dir;
        else nextState <= state;
      end
      3: end
        xn <= xval [0] - 10'd10;
        yn <= yval [0];
        if (!(dir % 2)) nextState <= dir;
        else nextState <= state;
      end
    endcase
  end

  always @(posedge clk) begin
    state <= nextState; 
  end


  always @(posedge clk) begin
    if (dir == 2'b00) begin
      xn <= xval [0];
      yn <= yval [0] - 10'd10;
    end
    else if (dir == 2'b01) begin
      xn <= xval [0] + 10'd10;
      yn <= yval [0];
    end
    else if (dir == 2'b10) begin
      xn <= xval [0];
      yn <= yval [0] + 10'd10;
    end
    else begin
      xn <= xval [0] - 10'd10;
      yn <= yval [0];
    end
  end

  always @(posedge clk) begin
    xval <= {xn , xval[0:3]};
    yval <= {yn , yval[0:3]};
  end
endmodule
