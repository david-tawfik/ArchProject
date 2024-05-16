mem load -i {E:/university/comp arch/MyArchProject/regfile.mem} /harvard_cpu/register_file1/reg
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /harvard_cpu/memory1/mem(0)
mem load -filltype value -filldata 0000000010100000 -fillradix symbolic /harvard_cpu/memory1/mem(1)
mem load -i {E:/university/comp arch/MyArchProject/testingout1.mem} /harvard_cpu/instruction_memory/cache
force -freeze sim:/harvard_cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/harvard_cpu/reset 1 0
run
force -freeze sim:/harvard_cpu/reset 0 0
run
force -freeze sim:/harvard_cpu/InputPort 'h00000005 0
run
run
run
force -freeze sim:/harvard_cpu/InputPort 'h00000010 0
run
