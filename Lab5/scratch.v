//scratch code

singlePulse rst(snakeclk, restart, restartSP);
singlePulse starter(snakeclk, running, start);

always @(posedge clk) begin
  if (scanCode == 8'h1b) begin//if S pressed
    if (running) restart <= 1; //if already running, restart
    else begin
      restart <= 0;
      running <= 1;
    end
    dir <= 2'b01;
    pause <= 0;
  end
  else begin
    restart <= 0;
    if (scanCode == 8'h76) start <= 0;
    else if (scanCode == 8'h4d) pause <= 1;
    else if (scanCode == 8'h2d) pause <= 0;
    else if (running && !pause && scanCode == 8'h75) dir <= 2'b00;
    else if (running && !pause && scanCode == 8'h74) dir <= 2'b01;
    else if (running && !pause && scanCode == 8'h72) dir <= 2'b10;
    else if (running && !pause && scanCode == 8'h6b) dir <= 2'b11;
  end
end


always @(posedge snakeclk) begin
  if (!start || restartSP) begin //||init
    xval0 <= 10'd0;
    yval0 <= 10'd240;
    xval1 <= 10'd10;
    yval1 <= 10'd240;
    xval2 <= 10'd20;
    yval2 <= 10'd240;
    xval3 <= 10'd30;
    yval3 <= 10'd240;
    xval4 <= 10'd40;
    yval4 <= 10'd240;
  //init <= 0;
  end
