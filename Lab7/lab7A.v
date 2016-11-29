// You can use this skeleton testbench code, the textbook testbench code, or your own
module MIPS_Testbench ();
  reg CLK;
  wire CS, WE;

  parameter N = 10;
  reg[31:0] expected[N:1];

  wire[31:0] Mem_Bus;
  reg[31:0] AddressTB;
  wire[6:0] Address, Address_Mux;
  wire WE_Mux, CS_Mux;
  reg init, RST, WE_TB, CS_TB;
  assign halt = 0;
  wire [7:0] reg1_out;

  integer i;

  MIPS CPU(CLK, RST, halt, CS, WE, Address, Mem_Bus, reg1_out);
  Memory MEM(CS, WE, CLK, Address, Mem_Bus);

  assign Address_Mux = (init) ? AddressTB : Address;
  assign WE_Mux = (init) ? WE_TB : WE;
  assign CS_Mux = (init) ? CS_TB : CS;

  always #5 CLK = !CLK;

  initial begin
    expected[1] = 32'h00000006;
    expected[2] = 32'h00000012;
    expected[3] = 32'h00000018;
    expected[4] = 32'h0000000C;
    expected[5] = 32'h00000002;
    expected[6] = 32'h00000016;
    expected[7] = 32'h00000001;
    expected[8] = 32'h00000120;
    expected[9] = 32'h00000003;
    expected[10] = 32'h00412022;
    CLK = 0;
  end //initial

  always begin
    //Notice that the memory is initialize in the in the memory module not here
    RST <= 1'b1; //reset the processor
    @(posedge CLK);
    init <= 1; CS_TB <= 1; WE_TB <= 1;
    @(posedge CLK);
    CS_TB <= 0; WE_TB <= 0; init <= 0;
    @(posedge CLK);
    // driving reset low here puts processor in normal operating mode
    RST = 1'b0;
    for (i = 1; i <= N; i = i+1) begin
      @(posedge WE);
      @(negedge CLK);
      if (Mem_Bus != expected[i])
        $display("Output mismatch: got %d, expect %d", Mem_Bus, expected[i]);
      else
        $display("#%d correct", i);
    end//for

    /* add your testing code here */
    // you can add in a 'Halt' signal here as well to test Halt operation
    // you will be verifying your program operation using the
    // waveform viewer and/or self-checking operations

    $display("TEST COMPLETE");
    $stop;
  end//always

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module Complete_MIPS(CLK, RST, HALT, reg1_out);
  // Will need to be modified to add functionality
  input CLK;
  input RST;
  input HALT;
  output [7:0] reg1_out;

  wire CS, WE;
  wire [6:0] ADDR;
  wire [31:0] Mem_Bus;
  wire twoHz;

  twoHertzClk slowclk(CLK, twoHz);
  MIPS CPU(twoHz, RST, HALT, CS, WE, ADDR, Mem_Bus, reg1_out);
  Memory MEM(CS, WE, CLK, ADDR, Mem_Bus);

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module Memory(CS, WE, CLK, ADDR, Mem_Bus);
  input CS;
  input WE;
  input CLK;
  input [6:0] ADDR;
  inout [31:0] Mem_Bus;

  reg [31:0] data_out;
  reg [31:0] RAM [0:127];


  initial
  begin
    $readmemh("MIPS_Instructions.txt", RAM);
  end

  assign Mem_Bus = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bZ : data_out;

  always @(negedge CLK)
  begin

    if((CS == 1'b1) && (WE == 1'b1))
      RAM[ADDR] <= Mem_Bus[31:0];

    data_out <= RAM[ADDR];
  end
endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module REG(CLK, RegW, DR, SR1, SR2, Reg_In, ReadReg1, ReadReg2, reg1_out);
  input CLK;
  input RegW;
  input [4:0] DR;
  input [4:0] SR1;
  input [4:0] SR2;
  input [31:0] Reg_In;
  output reg [31:0] ReadReg1;
  output reg [31:0] ReadReg2;
  output [7:0] reg1_out;

  reg [31:0] REG [0:31];
  integer i;

  initial begin
    ReadReg1 = 0;
    ReadReg2 = 0;
    for (i = 0; i < 32; i = i + 1)
      REG[i] = 0;
  end

  assign reg1_out = REG[1][7:0];

  always @(posedge CLK)
  begin

    if(RegW == 1'b1)
      REG[DR] <= Reg_In[31:0];

    ReadReg1 <= REG[SR1];
    ReadReg2 <= REG[SR2];
  end
endmodule


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`define opcode instr[31:26]
`define sr1 instr[25:21]
`define sr2 instr[20:16]
`define f_code instr[5:0]
`define numshift instr[10:6]

module MIPS (CLK, RST, HALT, CS, WE, ADDR, Mem_Bus, reg1_out);
  input CLK, RST;
  output reg CS, WE;
  output [6:0] ADDR;
  inout [31:0] Mem_Bus;
  output reg1_out;

  //special instructions (opcode == 000000), values of F code (bits 5-0):
  parameter add = 6'b100000;
  parameter sub = 6'b100010;
  parameter xor1 = 6'b100110;
  parameter and1 = 6'b100100;
  parameter or1 = 6'b100101;
  parameter slt = 6'b101010;
  parameter srl = 6'b000010;
  parameter sll = 6'b000000;
  parameter jr = 6'b001000;

  //non-special instructions, values of opcodes:
  parameter addi = 6'b001000;
  parameter andi = 6'b001100;
  parameter ori = 6'b001101;
  parameter lw = 6'b100011;
  parameter sw = 6'b101011;
  parameter beq = 6'b000100;
  parameter bne = 6'b000101;
  parameter j = 6'b000010;

  //instruction format
  parameter R = 2'd0;
  parameter I = 2'd1;
  parameter J = 2'd2;

  //internal signals
  reg [5:0] op, opsave;
  wire [1:0] format;
  reg [31:0] instr, alu_result;
  reg [6:0] pc, npc;
  wire [31:0] imm_ext, alu_in_A, alu_in_B, reg_in, readreg1, readreg2;
  reg [31:0] alu_result_save;
  reg alu_or_mem, alu_or_mem_save, regw, writing, reg_or_imm, reg_or_imm_save;
  reg fetchDorI;
  wire [4:0] dr;
  reg [2:0] state, nstate;

  //combinational
  assign imm_ext = (instr[15] == 1)? {16'hFFFF, instr[15:0]} : {16'h0000, instr[15:0]};//Sign extend immediate field
  assign dr = (format == R)? instr[15:11] : instr[20:16]; //Destination Register MUX (MUX1)
  assign alu_in_A = readreg1;
  assign alu_in_B = (reg_or_imm_save)? imm_ext : readreg2; //ALU MUX (MUX2)
  assign reg_in = (alu_or_mem_save)? Mem_Bus : alu_result_save; //Data MUX
  assign format = (`opcode == 6'd0)? R : ((`opcode == 6'd2)? J : I);
  assign Mem_Bus = (writing)? readreg2 : 32'bZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ;

  //drive memory bus only during writes
  assign ADDR = (fetchDorI)? pc : alu_result_save[6:0]; //ADDR Mux
  REG Register(CLK, regw, dr, `sr1, `sr2, reg_in, readreg1, readreg2, reg1_out);

  initial begin
    op = and1; opsave = and1;
    state = 3'b0; nstate = 3'b0;
    alu_or_mem = 0;
    regw = 0;
    fetchDorI = 0;
    writing = 0;
    reg_or_imm = 0; reg_or_imm_save = 0;
    alu_or_mem_save = 0;
  end

  always @(*)
  begin
    fetchDorI = 0; CS = 0; WE = 0; regw = 0; writing = 0; alu_result = 32'd0;
    npc = pc; op = jr; reg_or_imm = 0; alu_or_mem = 0; nstate = 3'd0;
    case (state)
      0: begin //fetch
        npc = pc + 7'd1; CS = 1; nstate = 3'd1;
        fetchDorI = 1;
      end
      1: begin //decode
        nstate = 3'd2; reg_or_imm = 0; alu_or_mem = 0;
        if (format == J) begin //jump, and finish
          npc = instr[6:0];
          nstate = 3'd0;
        end
        else if (format == R) //register instructions
          op = `f_code;
        else if (format == I) begin //immediate instructions
          reg_or_imm = 1;
          if(`opcode == lw) begin
            op = add;
            alu_or_mem = 1;
          end
          else if ((`opcode == lw)||(`opcode == sw)||(`opcode == addi)) op = add;
          else if ((`opcode == beq)||(`opcode == bne)) begin
            op = sub;
            reg_or_imm = 0;
          end
          else if (`opcode == andi) op = and1;
          else if (`opcode == ori) op = or1;
        end
      end
      2: begin //execute
        nstate = 3'd3;
        if (opsave == and1) alu_result = alu_in_A & alu_in_B;
        else if (opsave == or1) alu_result = alu_in_A | alu_in_B;
        else if (opsave == add) alu_result = alu_in_A + alu_in_B;
        else if (opsave == sub) alu_result = alu_in_A - alu_in_B;
        else if (opsave == srl) alu_result = alu_in_B >> `numshift;
        else if (opsave == sll) alu_result = alu_in_B << `numshift;
        else if (opsave == slt) alu_result = (alu_in_A < alu_in_B)? 32'd1 : 32'd0;
        else if (opsave == xor1) alu_result = alu_in_A ^ alu_in_B;
        if (((alu_in_A == alu_in_B)&&(`opcode == beq)) || ((alu_in_A != alu_in_B)&&(`opcode == bne))) begin
          npc = pc + imm_ext[6:0];
          nstate = 3'd0;
        end
        else if ((`opcode == bne)||(`opcode == beq)) nstate = 3'd0;
        else if (opsave == jr) begin
          npc = alu_in_A[6:0];
          nstate = 3'd0;
        end
      end
      3: begin //prepare to write to mem
        nstate = 3'd0;
        if ((format == R)||(`opcode == addi)||(`opcode == andi)||(`opcode == ori)) regw = 1;
        else if (`opcode == sw) begin
          CS = 1;
          WE = 1;
          writing = 1;
        end
        else if (`opcode == lw) begin
          CS = 1;
          nstate = 3'd4;
        end
      end
      4: begin
        if (HALT) begin
          nstate = 3d'4;
        end
        else begin
          nstate = 3'd0;
          CS = 1;
          if (`opcode == lw) regw = 1;
        end
      end
    endcase
  end //always

  always @(posedge CLK) begin

    if (RST) begin
      state <= 3'd0;
      pc <= 7'd0;
    end
    else begin
      state <= nstate;
      pc <= npc;
    end

    if (state == 3'd0) instr <= Mem_Bus;
    else if (state == 3'd1) begin
      opsave <= op;
      reg_or_imm_save <= reg_or_imm;
      alu_or_mem_save <= alu_or_mem;
    end
    else if (state == 3'd2) alu_result_save <= alu_result;

  end //always

endmodule

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
