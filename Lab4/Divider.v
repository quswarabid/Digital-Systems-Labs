module Divider(clk100Mhz, clk2Hz);
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

module oneHertzClk(clk100Mhz, clk1Hz);
  input clk100Mhz; //fast clock
  output reg clk1Hz; //slow clock

  reg[25:0] counter;

  initial begin
    counter = 0;
    clk1Hz = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 26'd50000000) begin
      counter <= 1;
      clk1Hz <= ~clk1Hz;
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

module SevenSegClock(clk100Mhz, clk1KHz);
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
