module debouncer(CLK, Da, Qb);
    input CLK, Da;
    output Qb;
    reg Qa, Qb;
    wire Db = Qa;

    always @(posedge CLK) begin
        Qa <= Da;
        Qb <= Db;
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
