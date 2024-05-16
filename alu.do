vsim -gui work.controllertoalu
add wave -position insertpoint  \
sim:/controllertoalu/A \
sim:/controllertoalu/B \
sim:/controllertoalu/opCode \
sim:/controllertoalu/F \
sim:/controllertoalu/zeroFlag \
sim:/controllertoalu/overflowFlag \
sim:/controllertoalu/negativeFlag \
sim:/controllertoalu/carryFlag
force -freeze sim:/controllertoalu/A 32'h0 0
force -freeze sim:/controllertoalu/B 32'h3 0
force -freeze sim:/controllertoalu/opCode 000001 0
run
force -freeze sim:/controllertoalu/opCode 000100 0
run
force -freeze sim:/controllertoalu/opCode 000111 0
run
force -freeze sim:/controllertoalu/opCode 001000 0
run
force -freeze sim:/controllertoalu/opCode 010010 0
run
force -freeze sim:/controllertoalu/opCode 110010 0
run
#force -freeze sim:/controllertoalu/opCode 0110 0
#run
#force -freeze sim:/controllertoalu/opCode 0111 0
#run
#force -freeze sim:/controllertoalu/opCode 1000 0
#run
#force -freeze sim:/controllertoalu/opCode 1001 0
#run
#force -freeze sim:/controllertoalu/opCode 1010 0
#run
#force -freeze sim:/controllertoalu/opCode 1111 0
#run

