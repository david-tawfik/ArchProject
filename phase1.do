vsim -gui work.harvard_cpu
mem load -i {E:/university/comp arch/MyArchProject/testingout.mem} /harvard_cpu/instruction_memory/cache


mem load -skip 0 -filltype value -filldata 0000000000000000 -fillradix symbolic /harvard_cpu/register_file1/reg
mem load -skip 0 -filltype value -filldata 0 -fillradix symbolic /harvard_cpu/flag_register1/reg

add wave -position insertpoint  \
sim:/harvard_cpu/clk \
sim:/harvard_cpu/reset \
sim:/harvard_cpu/count \
sim:/harvard_cpu/flag_register1/reg

force -freeze sim:/harvard_cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/harvard_cpu/reset 1 0
run
force -freeze sim:/harvard_cpu/reset 0 0