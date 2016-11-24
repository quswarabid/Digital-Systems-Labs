module twoHertzClk(clk100Mhz, clk2Hz);
  input clk100Mhz; //fast clock
  output reg clk2Hz; //slow clock

  reg[24:0] counter;

  initial begin
    counter = 0;
    clk2Hz = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 25'd25000000) begin
      counter <= 1;
      clk2Hz <= ~clk2Hz;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module pixelClk(clk100Mhz, clk25MHz);
  input clk100Mhz; //fast clock
  output reg clk25MHz; //slow clock

  reg[1:0] counter;

  initial begin
    counter = 0;
    clk25MHz = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 2'd2) begin
      counter <= 1;
      clk25MHz <= ~clk25MHz;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module tenHertzClk(clk100Mhz, clk10hz);
  input clk100Mhz; //fast clock
  output reg clk10hz; //slow clock

  reg[22:0] counter;

  initial begin
    counter = 0;
    clk10hz = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 23'd5000000) begin
      counter <= 1;
      clk10hz <= ~clk10hz;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module sevenSegClock(clk100Mhz, clk1KHz);
  input clk100Mhz; //fast clock
  output reg clk1KHz; //slow clock

  reg[15:0] counter;

  initial begin
    counter = 0;
    clk1KHz = 0;
  end

  always @ (posedge clk100Mhz) begin
    if(counter == 16'd50000) begin
      counter <= 1;
      clk1KHz <= ~clk1KHz;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module debounce_divider(clk100Mhz, clk20Hz);
    input clk100Mhz; //fast clock
    output reg clk20Hz; //slow clock

    reg[21:0] counter;

    initial begin
      counter = 0;
      clk20Hz = 0;
    end

    always @ (posedge clk100Mhz)
    begin
      if(counter == 22'd2500000) begin
        counter <= 1;
        clk20Hz <= ~clk20Hz;
      end
      else begin
        counter <= counter + 1;
      end
    end
endmodule

module dynamic_clock(clk100Mhz, faster, slower, variableClk, i);
  input clk100Mhz, faster, slower;
  output reg variableClk;
  reg[24:0] counter;
  reg [25:0] reference [0:10];
  output reg [3:0] i;

  initial begin
    counter <= 0;
    variableClk <= 0;
    reference[0] = 25'd25000000;//2Hz
    reference[1] = 25'd12500000;//4Hz
    reference[2] = 25'd6250000;//8Hz
    reference[3] = 25'd3125000;//16Hz
    reference[4] = 25'd2000000;//25Hz
    reference[5] = 25'd1562500;//32Hz
    reference[6] = 25'd1250000;//40Hz
    reference[7] = 25'd1000000;//50Hz
    reference[8] = 25'd833333;//60Hz
    reference[9] = 25'd714285;//70Hz
    reference[10] = 25'd625000;//80Hz
    i = 4'b0010;
  end

  always @(posedge clk100Mhz) begin
    if(counter >= reference[i]) begin
      counter <= 1;
      variableClk <= ~variableClk;
    end
    else begin
      counter <= counter + 1;
    end
  end

  always @(posedge clk100Mhz) begin
    if (faster && (i < 4'd10)) i = i + 1;
    else if (slower && (i > 4'd0)) i = i - 1;
  end

endmodule
