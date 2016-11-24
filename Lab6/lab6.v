module top(clk, mode, btns, swtchs, leds, segs, an);
  input clk;
  input[1:0] mode;
  input[1:0] btns;
  input[7:0] swtchs;
  output[7:0] leds;
  output[6:0] segs;
  output[3:0] an;

  //might need to change some of these from wires to regs
  wire cs;
  wire we;
  wire[6:0] addr;
  wire[7:0] data_out_mem;
  wire[7:0] data_out_ctrl;
  wire[7:0] data_bus;

  //MODIFY THE RIGHT HAND SIDE OF THESE TWO STATEMENTS ONLY
  // 1st driver of the data bus -- tri state switches,
  // logical function of we and data_out_ctrl
  assign data_bus = we ? data_out_ctrl : 8'bzzzzzzzz;

   // 2nd driver of the data bus -- tri state switches,
   // logical function of we and data_out_mem
  assign data_bus = we ? 8'bzzzzzzzz : data_out_mem;


  controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl, mode,
    btns, swtchs, leds, segs, an);

  memory mem(clk, cs, we, addr, data_bus, data_out_mem);

  //add any other functions you need
  //(e.g. debouncing, multiplexing, clock-division, etc)

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module controller(clk, cs, we, address, data_in, data_out, mode, btns, swtchs, leds, segs, an);
  input clk;
  output cs;
  output reg we;
  output reg[6:0] address;
  input[7:0] data_in;
  output reg[7:0] data_out;
  input[1:0] mode;
  input[1:0] btns;
  input[7:0] swtchs;
  output[7:0] leds;
  output[6:0] segs;
  output[3:0] an;
  reg[4:0] state;//, nextState;
  reg[7:0] DVR;
  reg[6:0] DAR;
  reg[6:0] SPR;
  reg[7:0] r1, r2;

  assign empty = (SPR == 7'b1111111) ? 1 : 0;
  assign cs = we;
  assign leds[7] = empty;
  assign leds[6:0] = DAR;

  //assign address = (we) ? SPR : DAR;

  wire [6:0] Seven0, Seven1;
  wire clk100Hz;
  sevenSegClock sevenClk(clk, clk100Hz);
  twoHexSeven twoHexToSeven(DVR, Seven0, Seven1);
  sevenSeg2 display(clk100Hz, Seven0, Seven1, segs, an);

  synchSP buttonL(clk, btns[1], btnL);
  synchSP buttonR(clk, btns[0], btnR);
  //WRITE THE FUNCTION OF THE CONTROLLER

  initial begin
    state <= 0;
    //nextState <= 0;
  end

  always @(posedge clk) begin
    case (state)
      0: begin // mode 00
        we <= 0;
        DVR <= data_in;
        address <= DAR;
        if (btnL) begin // POP
          if (!empty) begin
            SPR <= SPR + 1;
            DAR <= SPR + 2;
          end
        end
        else if (btnR) begin // PUSH
          we <= 1;
          data_out <= swtchs;
          address <= SPR;
          SPR <= SPR - 1;
          DAR <= SPR;
        end
        state <= {3'b000, mode};
      end
      1: begin // mode 01
        we <= 0;
        DVR <= data_in;
        address <= DAR;
        if (btnL) begin // subtract
          DAR <= SPR + 1; //reset DAR to get value from top of stack
          address <= SPR + 1;
          state <= 4;
        end
        else if (btnR) begin // add
          DAR <= SPR + 1;
          address <= SPR + 1;
          state <= 10;
        end
        else begin
          state <= {3'b000, mode};
        end
      end
      2: begin // mode 10
        we <= 0;
        address <= DAR;
        DVR <= data_in;
        if (btnL) begin // clear/reset
          SPR <= 8'h7F;
          DAR <= 0;
          DVR <= 0;
        end
        else if (btnR) begin // top
          DAR <= SPR + 1;
        end
        else begin
          state <= {3'b000, mode};
        end
      end
      3: begin // mode 11
        we <= 0;
        DVR <= data_in;
        address <= DAR;
        if (btnL) begin // dec addr
          DAR <= DAR - 1;
        end
        else if (btnR) begin // inc address
          DAR <= DAR + 1;
        end
        else begin
          state <= {3'b000, mode};
        end
      end
      4: begin
        state <= 5;
      end
      5: begin
        r1 <= data_in;
        SPR <= SPR + 1;
        DAR <= DAR + 1;
        address <= DAR + 1;
        state <= 6;
      end
      6: begin
        state <= 7;
      end
      7: begin
        r2 <= data_in;
        SPR <= SPR + 1;
        state <= 8;
      end
      8: begin
        state <= 9;
      end
      9: begin
        we <= 1;
        address <= SPR;
        data_out <= r2 - r1;
        SPR <= SPR - 1;
        state <= 16;
      end
      10: begin
        state <= 11;
      end
      11: begin
        r1 <= data_in;
        SPR <= SPR + 1;
        DAR <= DAR + 1;
        address <= DAR + 1;
        state <= 12;
      end
      12: begin
        state <= 13;
      end
      13: begin
        r2 <= data_in;
        SPR <= SPR + 1;
        state <= 14;
      end
      14: begin
        state <= 15;
      end
      15: begin
        we <= 1;
        address <= SPR;
        data_out <= r1 + r2;
        SPR <= SPR - 1;
        state <= 16;
      end
      16: begin
        state <= 1;
      end
      default:
        state <= {3'b000, mode};
    endcase
  end

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module memory(clock, cs, we, address, data_in, data_out);
  //DO NOT MODIFY THIS MODULE
  input clock;
  input cs;
  input we;
  input[6:0] address;
  input[7:0] data_in;
  output[7:0] data_out;

  reg[7:0] data_out;

  reg[7:0] RAM[0:127];

  always @ (negedge clock)
  begin
    if((we == 1) && (cs == 1))
      RAM[address] <= data_in[7:0];

    data_out <= RAM[address];
  end
endmodule
