module calculator (clk,sw14,sw15,btnl,btnr,sw0,sw1,sw2,sw3,sw4,sw5,sw6,sw7,empty,DVR,DAR)
	input clk,sw14,sw15,btnl,btnr,sw0,sw1,sw2,sw3,sw4,sw5,sw6,sw7;
	output reg [7:0] DVR;
	output reg [6:0] DAR;
	output wire empty;
	reg [6:0] SPR;
	wire [1:0] control;
	wire [7:0] numeral;

	assign numeral = {sw7,sw6,sw5,sw4,sw3,sw2,sw1,sw0};
	assign control = {sw15,sw14};
	assign empty = (SPR == 7'b1111111) ? 1 : 0;

	always @(posedge clk) begin
		if (empty) begin
			DAR = 7'b0000000;
			DVR = 8'b00000000;
			end
	end

	always @(posedge clk) begin
		case (control)
			2'b00 : begin
				if (btnl) begin //pop
					if (empty == 0) begin
						SPR <= SPR + 1;
						DAR <= SPR + 2;
					end
				end
				else if (btnr) begin //push
						[SPR] <= numeral;
						SPR <= SPR - 1;
						DAR <= SPR;
					end
			end
			2'b01 : begin
				if (btnl) begin //subtract
					if (SPR < 7'b1111110) begin
						[SPR +2] <= [SPR +1] - [SPR +2];
						SPR <= SPR + 1;
						DAR <= SPR + 2;
					end
				end
				else if (btnr) begin //add
					if (SPR < 7'b1111110) begin
						[SPR +2] <= [SPR +1] + [SPR +2];
						SPR <= SPR + 1;
						DAR <= SPR + 2;
					end
				end
			end
			2'b10 : begin
				if (btnl) begin //clear
					SPR <= 7'b1111111;
				end
				else if (btnr) begin //top
					DAR <= SPR + 1;
				end
			end
			2'b11 : begin
				if (btnl) begin //dec addr
					DAR <= DAR - 1;
				end
				else if (btnr) begin //inc addr
					DAR <= DAR + 1;
				end
			end
		endcase
	end
endmodule
