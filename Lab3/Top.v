module top(clk, RST, Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw);
  input clk, RST;
  output Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw;
  wire slowCLK; 
  
  Divider slow(clk, slowCLK);
  trafficlight controller(slowCLK, RST, Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw);
  
 endmodule 
  
