module Top(CLK, kbClk, kbData, SevenOut, Digit, pulse,
						sw0,sw1,sw2,sw3,sw4,sw5,sw6,up,down,R,G,B,Hsync,Vsync,speed);
	input CLK, kbClk, kbData,sw0,sw1,sw2,sw3,sw4,sw5,sw6;
	output wire [6:0] SevenOut;
	output wire [3:0] Digit;
	output pulse, Hsync, Vsync;
	output wire [3:0] R,G,B;
	output wire [3:0] speed;
	wire [6:0] Seven0, Seven1;
	wire [7:0] scanCode;
	wire clk100Hz, start, pause;// //, clk10hz, Strobe;
	wire [1:0] direction;
	wire [9:0] xval0, xval1, xval2, xval3, xval4, yval0, yval1, yval2, yval3, yval4;
	//assign CLR = !Strobe;

	//KEYBOARD
	keyReader keyboard(CLK, kbClk, kbData, scanCode, Strobe);
	tenHertzClk clk100ms(CLK, clk10hz);
	singlePulse strobe(clk10hz, Strobe, pulse);
	twoHexSeven twoHexToSeven(scanCode, Seven0, Seven1);
	sevenSegClock sevenClk(CLK, clk100Hz);
	sevenSeg2 display(Strobe, clk100Hz, Seven0, Seven1, SevenOut, Digit);

	//snake
	//wire ezclk;
	//tenHertzClk snakeclk(CLK, ezclk);
	snake slither(CLK, variableClk, scanCode, Strobe, xval0, xval1, xval2, xval3, xval4, yval0, yval1, yval2, yval3, yval4,start);


	//display
	pixelClk pclk(CLK, pixClk);
	vga monitor(pixClk, sw0, sw1, sw2, sw3, sw4, sw5, sw6,
							xval0, xval1, xval2, xval3, xval4, yval0, yval1, yval2, yval3, yval4,
							start, R, G, B, Hsync, Vsync);


	//snake speed
	input up, down;
	wire faster, slower;
	synchSP btnU(CLK, up, faster);
	synchSP btnD(CLK, down, slower);
	dynamic_clock varClk(CLK, faster, slower, variableClk, speed);
endmodule
