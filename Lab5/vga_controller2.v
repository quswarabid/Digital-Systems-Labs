module vga(clk,switch0,switch1,switch2,switch3,switch4,switch5,switch6,switch7,R,G,B,Hsync,Vsync);
input clk,switch0,switch1,switch2,switch3,switch4,switch5,switch6,switch7;
output Hsync,Vsync;
output [3:0] R,G,B;
wire Xmax = (Xcount == 10'd800);
wire Ymax = (Ycount == 10'd525);
reg [9:0] Xcount,Vcount;
reg [3:0] Rcolor,Gcolor,Bcolor;
reg display;

always @ (posedge clk)
begin
if (switch0)
begin
Rcolor = 4'd0;
Gcolor = 4'd0;
Bcolor = 4'd0;
end
else if (switch1)
begin
Rcolor = 4'd15;
Gcolor = 4'd0;
Bcolor = 4'd15;
end
else if (switch2)
begin
Rcolor = 4'd0;
Gcolor = 4'd6;
Bcolor = 4'd0;
end
else if (switch3)
begin
Rcolor = 4'd0;
Gcolor = 4'd0;
Bcolor = 4'd15;
end
else if (switch4)
begin
Rcolor = 4'd15;
Gcolor = 4'd0;
Bcolor = 4'd0;
end
else if (switch5)
begin
Rcolor = 4'd15;
Gcolor = 4'd10;
Bcolor = 4'd0;
end
else if (switch6)
begin
Rcolor = 4'd15;
Gcolor = 4'd15;
Bcolor = 4'd0;
end
else if (switch7)
begin
Rcolor = 4'd15;
Gcolor = 4'd15;
Bcolor = 4'd15;
end
else
begin
Rcolor = 4'd15;
Gcolor = 4'd15;
Bcolor = 4'd15;
end
end

always @ (posedge clk)
begin
if (Xmax)
	Xcount = 0;
else
	Xcount = Xcount + 1;
end

always @ (posedge clk)
begin
if (Xmax)
	begin
	if (Ymax)
		Ycount = 0;
	else
		Ycount = Ycount + 1;
	end
end

assign display = ((Xcount < 640) && (Ycount <480));

assign Hsync = ~((Xcount >658) && (Xcount <756));
assign Vsync = ~((Ycount >492) &&(Ycount < 495));

always @ (posedge clk)
if (!display)
begin
	R = 0;
	G = 0;
	B = 0;
end
else if (((Xcount - xval[0] < 10'd10)&& (Xcount -xval[0] >= 10'd0)&&(Ycount - yval[0] < 10'd10) && (Ycount -yval[0] >= 10'd0))||((Xcount - xval[1] < 10'd10)&& (Xcount -xval[1] >= 10'd0)&&(Ycount - yval[1] < 10'd10) && (Ycount -yval[1] >= 10'd0))||((Xcount - xval[2] < 10'd10)&& (Xcount -xval[2] >= 10'd0)&&(Ycount - yval[2] < 10'd10) && (Ycount -yval[2] >= 10'd0))||((Xcount - xval[3] < 10'd10)&& (Xcount -xval[3] >= 10'd0)&&(Ycount - yval[3] < 10'd10) && (Ycount -yval[3] >= 10'd0))||((Xcount - xval[4] < 10'd10)&& (Xcount -xval[4] >= 10'd0)&&(Ycount - yval[4] < 10'd10) && (Ycount -yval[4] >= 10'd0)))
begin
R = 4'd15;
G = 4'd0;
B = 4'd0;
else
begin
	R = Rcolor;
	G = Gcolor;
	B = Bcolor;
end
endmodule
