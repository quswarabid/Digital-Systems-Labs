module synchSP(CLK, D, Qout);
    input CLK, D;
    output Qout;
    wire Qint;

    //oneHertzClk oneHzClk(CLK, oneHz);
    debounce_divider dbdiv(CLK, db_clk);
    debouncer db(db_clk, D, Qint);
    singlePulse sp(CLK, Qint, Qout);

endmodule

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

module singlePulse(CLK, D, SP);
     input CLK, D;
     output SP;
     reg Q;
     assign Qn = ~Q;
     assign SP = D & Qn;

     always @(posedge CLK) begin
         Q <= D;
     end
endmodule
