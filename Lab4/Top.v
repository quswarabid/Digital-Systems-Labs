module Top(CLK, add30, add120, add180, add300, rst15, rst185, SevenOut, Digit);
	input CLK, add30, add120, add180, add300, rst15, rst185;
	output wire [6:0] SevenOut;
	output wire [3:0] Digit;
	wire [6:0] Seven0, Seven1, Seven2, Seven3;
	wire db30, db120, db180, db300, clk100Hz, twoHzClk;
	wire [15:0] fourSeven;

	//Inputs
	synchSP btnU(CLK, add30, db30);
	synchSP btnL(CLK, add120, db120);
	synchSP btnR(CLK, add180, db180);
	synchSP btnD(CLK, add300, db300);

	//Controller
	Controller trafficMeter(CLK, db30, db120, db180, db300, rst15, rst185, fourSeven);

	//Output
	fourBCDSeven bcdToSeven(fourSeven, Seven0, Seven1, Seven2, Seven3);
	SevenSegClock sevenClk(CLK, clk100Hz);
	sevenSeg display(clk100Hz, Seven0, Seven1, Seven2, Seven3, SevenOut, Digit);
endmodule
