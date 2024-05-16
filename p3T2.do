mem load -i {E:/university/comp arch/MyArchProject/testingout2.mem} /harvard_cpu/instruction_memory/cache
mem load -i {E:/university/comp arch/MyArchProject/regfile.mem} /harvard_cpu/register_file1/reg
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /harvard_cpu/memory1/mem(0)
mem load -filltype value -filldata 0000000011111111 -fillradix symbolic /harvard_cpu/memory1/mem(1)
force -freeze sim:/harvard_cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/harvard_cpu/reset 1 0
run
force -freeze sim:/harvard_cpu/reset 0 0
force -freeze sim:/harvard_cpu/InputPort 'h00000005 0
run
force -freeze sim:/harvard_cpu/InputPort 'h00000019 0
run
force -freeze sim:/harvard_cpu/InputPort 'hffffffff 0
run
force -freeze sim:/harvard_cpu/InputPort 'hfffff320 0
run

