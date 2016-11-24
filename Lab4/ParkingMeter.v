module ParkingMeter(CLK, ad30, ad120, ad180, ad300, rs15, rs185, Qout);
    input CLK, ad30, ad120, ad180, ad300, rs15, rs185;
    output [15:0] Qout;
    wire [15:0] Q;
    assign Qout = Q;
    reg [15:0] addMux;
    reg [15:0] D;

    wire add, reset, load;
    assign enable = 1;

    assign add = ad30 || ad120 || ad180 || ad300;
    assign reset = rs15 || rs185;
    assign load = add || reset;

	initial begin
		addMux = 16'd0;
		D = 16'd0;
	end

    //select how much to add
    wire [15:0] sum;
    always @(*) begin
		addMux = 0;
		    if (ad30) addMux = 16'b0000000000110000;
		    else if (ad120) addMux = 16'b0000000100100000;
		    else if (ad180) addMux = 16'b0000000110000000;
		    else if (ad300) addMux = 16'b0000001100000000;
		    else addMux <= 16'd0;
    end
    BCD_Adder adder(Q, addMux, sum);

    //select what data gets loaded into counter
    always @(*) begin
        if (rs185) D = 16'b0000000110000101;
        else if (rs15) D = 16'b0000000000010101;
        else D = sum;
    end

    fourBCDdec decrementer(CLK, enable, load, D, Q);

endmodule
