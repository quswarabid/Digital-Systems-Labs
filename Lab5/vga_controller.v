module vga(clk, sw0, sw1, sw2, sw3, sw4, sw5, sw6,
	xval0, xval1, xval2, xval3, xval4, yval0, yval1, yval2, yval3, yval4,
	start, R, G, B, Hsync, Vsync);
	input clk, sw0, sw1, sw2, sw3, sw4, sw5, sw6, start;
	input [9:0] xval0, xval1, xval2, xval3, xval4, yval0, yval1, yval2, yval3, yval4;
	output wire Hsync,Vsync;
	output wire [3:0] R,G,B;
	wire Xmax = (Xcount == 10'd800);
	wire Ymax = (Ycount == 10'd525);
	reg [9:0] Xcount,Ycount;
	reg [3:0] Rcolor,Gcolor,Bcolor;
	wire display;

	always @(posedge clk) begin
		if (sw0) begin
			Rcolor <= 4'd0;
			Gcolor <= 4'd0;
			Bcolor <= 4'd0;
		end
		else if (sw1) begin
			Rcolor <= 4'd15;
			Gcolor <= 4'd0;
			Bcolor <= 4'd15;
		end
		else if (sw2) begin
			Rcolor <= 4'd0;
			Gcolor <= 4'd6;
			Bcolor <= 4'd0;
		end
		else if (sw3) begin
			Rcolor <= 4'd0;
			Gcolor <= 4'd0;
			Bcolor <= 4'd15;
		end
		else if (sw4) begin
			Rcolor <= 4'd15;
			Gcolor <= 4'd0;
			Bcolor <= 4'd0;
		end
		else if (sw5) begin
			Rcolor <= 4'd15;
			Gcolor <= 4'd10;
			Bcolor <= 4'd0;
		end
		else if (sw6) begin
			Rcolor <= 4'd15;
			Gcolor <= 4'd15;
			Bcolor <= 4'd0;
		end
		else begin
			Rcolor <= 4'd15;
			Gcolor <= 4'd15;
			Bcolor <= 4'd15;
		end
	end

	always @(posedge clk) begin
		if (Xmax) Xcount <= 0;
		else Xcount <= Xcount + 1;
	end

	always @(posedge clk) begin
		if (Xmax) begin
			if (Ymax) Ycount <= 0;
			else Ycount <= Ycount + 1;
		end
	end

	assign display = ((Xcount < 640) && (Ycount < 480))&&start;
	assign Hsync = ~((Xcount > 658) && (Xcount < 756));
	assign Vsync = ~((Ycount > 492) && (Ycount < 495));

    assign R = (!display) ? 0 : ((((Xcount - xval0 < 10'd10) && (Xcount - xval0 >= 10'd0) &&
                                        (Ycount - yval0 < 10'd10) && (Ycount - yval0 >= 10'd0)) ||
                                    ((Xcount - xval1 < 10'd10) && (Xcount - xval1 >= 10'd0) &&
                                        (Ycount - yval1 < 10'd10) && (Ycount - yval1 >= 10'd0)) ||
                                    ((Xcount - xval2 < 10'd10) && (Xcount - xval2 >= 10'd0) &&
                                        (Ycount - yval2 < 10'd10) && (Ycount - yval2 >= 10'd0)) ||
                                    ((Xcount - xval3 < 10'd10) && (Xcount - xval3 >= 10'd0) &&
                                        (Ycount - yval3 < 10'd10) && (Ycount - yval3 >= 10'd0)) ||
                                    ((Xcount - xval4 < 10'd10)&& (Xcount - xval4 >= 10'd0) &&
                                        (Ycount - yval4 < 10'd10) && (Ycount - yval4 >= 10'd0))) ? 4'd15 : Rcolor); 
    assign G = (!display) ? 0 : ((((Xcount - xval0 < 10'd10) && (Xcount - xval0 >= 10'd0) &&
                                        (Ycount - yval0 < 10'd10) && (Ycount - yval0 >= 10'd0)) ||
                                    ((Xcount - xval1 < 10'd10) && (Xcount - xval1 >= 10'd0) &&
                                        (Ycount - yval1 < 10'd10) && (Ycount - yval1 >= 10'd0)) ||
                                    ((Xcount - xval2 < 10'd10) && (Xcount - xval2 >= 10'd0) &&
                                        (Ycount - yval2 < 10'd10) && (Ycount - yval2 >= 10'd0)) ||
                                    ((Xcount - xval3 < 10'd10) && (Xcount - xval3 >= 10'd0) &&
                                        (Ycount - yval3 < 10'd10) && (Ycount - yval3 >= 10'd0)) ||
                                    ((Xcount - xval4 < 10'd10)&& (Xcount - xval4 >= 10'd0) &&
                                        (Ycount - yval4 < 10'd10) && (Ycount - yval4 >= 10'd0))) ? 4'd0 : Gcolor); 
    assign B = (!display) ? 0 : ((((Xcount - xval0 < 10'd10) && (Xcount - xval0 >= 10'd0) &&
                                        (Ycount - yval0 < 10'd10) && (Ycount - yval0 >= 10'd0)) ||
                                    ((Xcount - xval1 < 10'd10) && (Xcount - xval1 >= 10'd0) &&
                                        (Ycount - yval1 < 10'd10) && (Ycount - yval1 >= 10'd0)) ||
                                    ((Xcount - xval2 < 10'd10) && (Xcount - xval2 >= 10'd0) &&
                                        (Ycount - yval2 < 10'd10) && (Ycount - yval2 >= 10'd0)) ||
                                    ((Xcount - xval3 < 10'd10) && (Xcount - xval3 >= 10'd0) &&
                                        (Ycount - yval3 < 10'd10) && (Ycount - yval3 >= 10'd0)) ||
                                    ((Xcount - xval4 < 10'd10)&& (Xcount - xval4 >= 10'd0) &&
                                        (Ycount - yval4 < 10'd10) && (Ycount - yval4 >= 10'd0))) ? 4'd0 : Bcolor); 
    
//	always @* begin
//		if (!display || !start) begin
//			R <= 0;
//			G <= 0;
//			B <= 0;
//		end
//		else if (((Xcount - xval0 < 10'd10) && (Xcount - xval0 >= 10'd0) &&
//						(Ycount - yval0 < 10'd10) && (Ycount - yval0 >= 10'd0)) ||
//					((Xcount - xval1 < 10'd10) && (Xcount - xval1 >= 10'd0) &&
//						(Ycount - yval1 < 10'd10) && (Ycount - yval1 >= 10'd0)) ||
//					((Xcount - xval2 < 10'd10) && (Xcount - xval2 >= 10'd0) &&
//						(Ycount - yval2 < 10'd10) && (Ycount - yval2 >= 10'd0)) ||
//					((Xcount - xval3 < 10'd10) && (Xcount - xval3 >= 10'd0) &&
//						(Ycount - yval3 < 10'd10) && (Ycount - yval3 >= 10'd0)) ||
//					((Xcount - xval4 < 10'd10)&& (Xcount - xval4 >= 10'd0) &&
//						(Ycount - yval4 < 10'd10) && (Ycount - yval4 >= 10'd0))) begin
//			R <= 4'd15;
//			G <= 4'd0;
//			B <= 4'd0;
//		end
//		else begin
//			R <= Rcolor;
//			G <= Gcolor;
//			B <= Bcolor;
//		end
//	end
endmodule


