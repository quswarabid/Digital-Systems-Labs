module sorter(clk,weight,reset,Grp1,Grp2,Grp3,Grp4,Grp5,Grp6,currentGrp);
	input clk,reset;
	input [11:0] weight;
	output reg [7:0] Grp1,Grp2,Grp3,Grp4,Grp5,Grp6;
	output reg [2:0] currentGrp;
	reg ready; 
	
	initial begin
		Grp1 = 8'b00000000;
		Grp2 = 8'b00000000;
		Grp3 = 8'b00000000;
		Grp4 = 8'b00000000;
		Grp5 = 8'b00000000;
		Grp6 = 8'b00000000;
		ready = 1'b1; 
	end
	
	always @(negedge clk, reset) begin
		if (reset) begin
		   Grp1 = 8'b00000000;
		   Grp2 = 8'b00000000;
		   Grp3 = 8'b00000000;
		   Grp4 = 8'b00000000;
		   Grp5 = 8'b00000000;
		   Grp6 = 8'b00000000;
		   ready = 1'b1; 
		end
		else if (weight == 12'b000000000000) begin
		    ready = 1'b1; 
		    //$display("ready for more weight");
		end
		else if (ready) begin
	      if (weight > 12'b011111010000) begin 
		       Grp6 = Grp6 + 1;
		       //$display("Group6 incremented; weight = %d", weight); 
		    end
	      else if (weight > 12'b001111101000) begin 
		       Grp5 = Grp5 + 1;
		       //$display("Group5 incremented; weight = %d", weight); 
		    end
	      else if (weight > 12'b001100100000) begin
		       Grp4 = Grp4 + 1;
		       //$display("Group4 incremented; weight = %d", weight); 
		    end
	      else if (weight > 12'b000111110100) begin
		       Grp3 = Grp3 + 1;
		       //$display("Group3 incremented; weight = %d", weight); 
		    end
	      else if (weight > 12'b000011001000) begin
		       Grp2 = Grp2 + 1;
		       //$display("Group2 incremented; weight = %d", weight); 
		    end
	      else if (weight > 12'b000000000000) begin 
		       Grp1 = Grp1 + 1;
		       //$display("Group1 incremented; weight = %d", weight); 
		    end
		    else begin
		      $display("Invalid weight: %d", weight);
		    end
		    ready <= 1'b0; 
		    //$display("not ready"); 
		end
	end
	
	always @(weight)
	begin
	  if (weight == 12'b000000000000)
	    currentGrp = 3'b000;
	  else if (weight > 12'b011111010000)
	    currentGrp = 3'b110;
	  else if (weight > 12'b001111101000)
	    currentGrp = 3'b101;
	  else if (weight > 12'b001100100000)
	    	currentGrp = 3'b100;
	  else if (weight > 12'b000111110100)
	    currentGrp = 3'b011;
	  else if (weight > 12'b000011001000)
	    currentGrp = 3'b010;
	  else if (weight > 12'b000000000000)
	    currentGrp = 3'b001; 
	end

endmodule