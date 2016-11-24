module SorterTest;
  
  parameter N = 13; 
  reg [11:0] weight; 
  wire [7:0] Grp1,Grp2,Grp3,Grp4,Grp5,Grp6;
  wire [2:0] currentGrp;
  
  reg [11:0] weight_array [1:N]; 
  reg [7:0] grp1_array [1:N];
  reg [7:0] grp2_array [1:N];
  reg [7:0] grp3_array [1:N];
  reg [7:0] grp4_array [1:N];
  reg [7:0] grp5_array [1:N];
  reg [7:0] grp6_array [1:N];
  reg [2:0] currentGrp_array [1:N]; 
  reg reset; 
  reg CLK; 
  integer i; 
  
  sorter packages(CLK, weight, reset, Grp1, Grp2, Grp3, Grp4, Grp5, Grp5, currentGrp); 
  
  always 
    #10 CLK = ~CLK; 
    
  initial begin
    CLK = 0; 
    weight_array[1] = 12'd1;
    currentGrp_array[1] = 3'd1; 
    grp1_array[1] = 8'd1;  
    grp2_array[1] = 8'd0;
    grp3_array[1] = 8'd0;
    grp4_array[1] = 8'd0;
    grp5_array[1] = 8'd0;
    grp6_array[1] = 8'd0;
    
    weight_array[2] = 12'd56;
    currentGrp_array[2] = 3'd1; 
    grp1_array[2] = 8'd2;  
    grp2_array[2] = 8'd0;
    grp3_array[2] = 8'd0;
    grp4_array[2] = 8'd0;
    grp5_array[2] = 8'd0;
    grp6_array[2] = 8'd0;
    
    weight_array[3] = 12'd200;
    currentGrp_array[3] = 3'd1; 
    grp1_array[3] = 8'd3;  
    grp2_array[3] = 8'd0;
    grp3_array[3] = 8'd0;
    grp4_array[3] = 8'd0;
    grp5_array[3] = 8'd0;
    grp6_array[3] = 8'd0;
    
    weight_array[4] = 12'd201;
    currentGrp_array[4] = 3'd2; 
    grp1_array[4] = 8'd3;  
    grp2_array[4] = 8'd1;
    grp3_array[4] = 8'd0;
    grp4_array[4] = 8'd0;
    grp5_array[4] = 8'd0;
    grp6_array[4] = 8'd0;
    
    weight_array[5] = 12'd500;
    currentGrp_array[5] = 3'd2; 
    grp1_array[5] = 8'd3;  
    grp2_array[5] = 8'd2;
    grp3_array[5] = 8'd0;
    grp4_array[5] = 8'd0;
    grp5_array[5] = 8'd0;
    grp6_array[5] = 8'd0;
    
    weight_array[6] = 12'd501;
    currentGrp_array[6] = 3'd3; 
    grp1_array[6] = 8'd3;  
    grp2_array[6] = 8'd2;
    grp3_array[6] = 8'd1;
    grp4_array[6] = 8'd0;
    grp5_array[6] = 8'd0;
    grp6_array[6] = 8'd0;
    
    weight_array[7] = 12'd800;
    currentGrp_array[7] = 3'd3; 
    grp1_array[7] = 8'd3;  
    grp2_array[7] = 8'd2;
    grp3_array[7] = 8'd2;
    grp4_array[7] = 8'd0;
    grp5_array[7] = 8'd0;
    grp6_array[7] = 8'd0;
    
    weight_array[8] = 12'd801;
    currentGrp_array[8] = 3'd4; 
    grp1_array[8] = 8'd3;  
    grp2_array[8] = 8'd2;
    grp3_array[8] = 8'd2;
    grp4_array[8] = 8'd1;
    grp5_array[8] = 8'd0;
    grp6_array[8] = 8'd0;
    
    weight_array[9] = 12'd1000;
    currentGrp_array[9] = 3'd4; 
    grp1_array[9] = 8'd3;  
    grp2_array[9] = 8'd2;
    grp3_array[9] = 8'd2;
    grp4_array[9] = 8'd2;
    grp5_array[9] = 8'd0;
    grp6_array[9] = 8'd0;
    
    weight_array[10] = 12'd1001;
    currentGrp_array[10] = 3'd5; 
    grp1_array[10] = 8'd3;  
    grp2_array[10] = 8'd2;
    grp3_array[10] = 8'd2;
    grp4_array[10] = 8'd2;
    grp5_array[10] = 8'd1;
    grp6_array[10] = 8'd0;
    
    weight_array[11] = 12'd2000;
    currentGrp_array[11] = 3'd5; 
    grp1_array[11] = 8'd3;  
    grp2_array[11] = 8'd2;
    grp3_array[11] = 8'd2;
    grp4_array[11] = 8'd2;
    grp5_array[11] = 8'd2;
    grp6_array[11] = 8'd0;
    
    weight_array[12] = 12'd2001;
    currentGrp_array[12] = 3'd6; 
    grp1_array[12] = 8'd3;  
    grp2_array[12] = 8'd2;
    grp3_array[12] = 8'd2;
    grp4_array[12] = 8'd2;
    grp5_array[12] = 8'd2;
    grp6_array[12] = 8'd1;
    
    weight_array[13] = 12'b111111111111;
    currentGrp_array[13] = 3'd6; 
    grp1_array[13] = 8'd3;  
    grp2_array[13] = 8'd2;
    grp3_array[13] = 8'd2;
    grp4_array[13] = 8'd2;
    grp5_array[13] = 8'd2;
    grp6_array[13] = 8'd2;
  end
  
  
  always begin 
    reset = 1; 
    @(posedge CLK);
    reset <= 0; 
    $display("TESTING GROUPS"); 
    for(i = 1; i <= N; i = i + 1) begin 
      $display("ITERATION%d", i); 
      weight <= weight_array[i]; 
    
      //page 506 for testing timing help
      @(negedge CLK); //latch next values
      //$display("%d weight should be latched", weight);
      @(posedge CLK);
      if(currentGrp != currentGrp_array[i])
        $display("ERROR: currentGrp supposed to be %d", currentGrp_array[i]);
      if(Grp1 != grp1_array[i])
        $display("ERROR: grp1 supposed to be %d", grp1_array[i]);
      if(Grp2 != grp2_array[i])
        $display("ERROR: grp2 supposed to be %d", grp2_array[i]);
      if(Grp3 != grp3_array[i])
        $display("ERROR: grp3 supposed to be %d", grp3_array[i]);
      if(Grp4 != grp4_array[i])
        $display("ERROR: grp4 supposed to be %d", grp4_array[i]);
      if(Grp5 != grp5_array[i])
        $display("ERROR: grp5 supposed to be %d", grp5_array[i]);
      if(Grp6 != grp6_array[i])
        $display("ERROR: grp6 supposed to be %d", grp6_array[i]);
        
      weight <= 12'd0;
      @(negedge CLK); //latch weight = 0
    end
    
    $display("TESTING RESET"); 
    reset = 1; 
    @(posedge CLK);
    if(currentGrp != 3'b000 || Grp1 !=  8'd0 || Grp2 !=  8'd0 || Grp3 !=  8'd0 || 
      Grp4 !=  8'd0 || Grp5 !=  8'd0 || Grp6 !=  8'd0 )
        $display("RESET ERROR");
    else 
      $display("RESET GUCCI");
      
    reset = 0;
    $display("TESTING ADDING WEIGHT");
    weight = 12'd500;
    @(negedge CLK);
    @(posedge CLK);
    if(currentGrp != 3'd2)
      $display("ERROR: expected currentGrp: 2");
    if(Grp2 != 8'd1)
      $display("ERROR: grp2 expected count: 1");
    #(3);
    weight = 12'd501; 
    #(3);
    if(currentGrp != 3'd3)
      $display("ERROR: expected currentGrp: 3");
    if(Grp2 != 8'd1)
      $display("ERROR: grp2 expected count still 1");
    
    $display("TESTING FINISHED"); 
    $stop; 
  end

endmodule