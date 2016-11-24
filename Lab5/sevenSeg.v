module sevenSeg2(start, CLK, Seven0, Seven1, SevOut, Dig);
	input CLK, start;
	input [6:0] Seven0, Seven1;
	output reg [6:0] SevOut;
	output reg [3:0] Dig;
	reg [1:0] State, NextState;

	initial begin
		State <= 2'd2;
	end

	always @* begin
		case (State)
			0: begin
				//if (CLR) SevOut <= 7'b1111111;
				//else
				SevOut <= Seven0;
				Dig <= 4'b1110;
				NextState <= 1;
			end
			1: begin
				//if (CLR) SevOut <= 7'b1111111;
				//else
				SevOut <= Seven1;
				Dig <= 4'b1101;
				NextState <= 0;
			end
			2: begin
				SevOut <= 7'b1111111;
				Dig <= 4'b1110;
				if (start) NextState <= 0;
				else NextState <= 3;
			end
			3: begin
				SevOut <= 7'b1111111;
				Dig <= 4'b1101;
				if (start) NextState <= 1;
				else NextState <= 2;
			end
		endcase
	end

	always @(posedge CLK) begin
		State <= NextState;
	end
endmodule

module twoHexSeven(D, Seven0, Seven1);
		//input CLR;
    input [7:0] D;
    output [7:1] Seven0, Seven1;
    wire [3:0] Dig0, Dig1;

    assign Dig0 = D[3:0];
    assign Dig1 = D[7:4];

    hexSeven hex0(Dig0, Seven0);
    hexSeven hex1(Dig1, Seven1);
endmodule

module hexSeven(hex, seven);
		//input CLR;
    input [3:0] hex;
    output reg [7:1] seven;

    always @* begin
        case (hex)
            4'b0000 : seven = 7'b1000000;
            4'b0001 : seven = 7'b1111001;
            4'b0010 : seven = 7'b0100100;
            4'b0011 : seven = 7'b0110000;
            4'b0100 : seven = 7'b0011001;
            4'b0101 : seven = 7'b0010010;
            4'b0110 : seven = 7'b0000010;
            4'b0111 : seven = 7'b1111000;
            4'b1000 : seven = 7'b0000000;
            4'b1001 : seven = 7'b0010000;
						4'b1010 : seven = 7'b0001000;
						4'b1011 : seven = 7'b0000011;
						4'b1100 : seven = 7'b1000110;
						4'b1101 : seven = 7'b0100001;
						4'b1110 : seven = 7'b0000110;
						4'b1111 : seven = 7'b0001110;
            default : seven = 7'b1111111;
        endcase
			//end
    end
endmodule
