#add
#force A 'b1001 0ns
#force B 'b1011 0ns
#force Cin 1 0ns
#force Control 'b000
#run 10ns

#subtract
#force A 'b1001 0ns
#force B 'b0011 0ns
#force Cin 1 0ns
#force Control 'b001
#run 10ns

#bitwise or
#force A 'b1010 0ns
#force B 'b0011 0ns
#force Control 'b010
#run 10ns

#bitwise and
#force A 'b1010 0ns
#force B 'b0011 0ns
#force Control 'b011
#run 10ns

#shift left
#force A 'b1010 0ns
#force Control 'b100
#run 10ns

#shift right
#force A 'b1010 0ns
#force Control 'b101
#run 10ns

#rotate left
#force A 'b0111 0ns
#force Control 'b110
#run 10ns

#rotate right
force A 'b1110 0ns
force Control 'b111
run 10ns
