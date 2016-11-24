module ALU (A, B, Cin, Cout, Output, Control);
input [3:0] A, B;
input Cin; 
input [2:0] Control; 
output [3:0] Output;
output Cout; 
reg [3:0] Output;
reg Cout; 
wire Co, Bo; 
wire [3:0] Sum, Difference, o, a, lsh, rsh, lrot, rrot; 

Adder4 add(Sum, Co, A, B, Cin); 
Subtractor4 sub(A, B, Cin, Difference, Bo); 
assign o = A | B; 
assign a = A & B;
assign lsh = A << 1;
assign rsh = A >> 1;
assign lrot = {A[2:0], A[3]};
assign rrot = {A[0], A[3:1]};

always @(*)
begin

case(Control)
	'b000: begin Output <= Sum; Cout <= Co; end 
	'b001: begin Output <= Difference; Cout <= Bo; end
	'b010: begin Output <= o; Cout <= 0; end
	'b011: begin Output <= a; Cout <= 0; end
	'b100: begin Output <= lsh; Cout <= 0; end
	'b101: begin Output <= rsh; Cout <= 0; end
	'b110: begin Output <= lrot; Cout <= 0; end
	'b111: begin Output <= rrot; Cout <= 0; end
endcase
end
endmodule 