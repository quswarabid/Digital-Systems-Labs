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
