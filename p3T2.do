
mem load -i D:/College/Sem8/Architecture/ArchProject/testingout.mem /harvard_cpu/instruction_memory/cache
mem load -i D:/College/Sem8/Architecture/ArchProject/regfile.mem /harvard_cpu/register_file1/reg
mem load -i D:/College/Sem8/Architecture/ArchProject/memory.mem /harvard_cpu/protected1/reg
mem load -filltype value -filldata 00 -fillradix symbolic /harvard_cpu/protected1/reg
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /harvard_cpu/memory1/mem(0)
mem load -filltype value -filldata 0000001100000000 -fillradix symbolic /harvard_cpu/memory1/mem(1)
force -freeze sim:/harvard_cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/harvard_cpu/reset 1 0
run
force -freeze sim:/harvard_cpu/reset 0 0
force -freeze sim:/harvard_cpu/InputPort 'h00000019 0
run
force -freeze sim:/harvard_cpu/InputPort 'hffffffff 0
run
force -freeze sim:/harvard_cpu/InputPort 'hfffff320 0
run
force -freeze sim:/harvard_cpu/InputPort 'h00000010 0
run