vsim -gui work.harvard_cpu
add wave -position insertpoint  \
sim:/harvard_cpu/mem_write_de_out
add wave -position insertpoint  \
sim:/harvard_cpu/mem_write_em_out
add wave -position insertpoint  \
sim:/harvard_cpu/reset
add wave -position insertpoint  \
sim:/harvard_cpu/spOut
add wave -position insertpoint  \
sim:/harvard_cpu/sp_sel_controller_out \
sim:/harvard_cpu/sp_sel_de_out \
sim:/harvard_cpu/sp_sel_em_out
add wave -position insertpoint  \
sim:/harvard_cpu/writeData
add wave -position insertpoint  \
sim:/harvard_cpu/read_data2_de_out
add wave -position insertpoint  \
sim:/harvard_cpu/clk
add wave -position insertpoint  \
sim:/harvard_cpu/memAddressIn
add wave -position insertpoint  \
sim:/harvard_cpu/alu_out
add wave -position insertpoint  \
sim:/harvard_cpu/memory_out
add wave -position insertpoint  \
sim:/harvard_cpu/memReadIn
add wave -position insertpoint  \
sim:/harvard_cpu/memAddressIn
add wave -position insertpoint  \
sim:/harvard_cpu/memAddressToMem
add wave -position insertpoint  \
sim:/harvard_cpu/WB_data_src_from_C_to_DE
add wave -position insertpoint  \
sim:/harvard_cpu/WB_data_src_from_DE_to_EM
add wave -position insertpoint  \
sim:/harvard_cpu/WB_data_src_from_EM_to_MWB
add wave -position insertpoint  \
sim:/harvard_cpu/WB_data_src_from_MWB
add wave -position insertpoint  \
sim:/harvard_cpu/WB1_data
add wave -position insertpoint  \
sim:/harvard_cpu/memory_data_wb_out
add wave -position insertpoint  \
sim:/harvard_cpu/alu_em_out \
sim:/harvard_cpu/alu_out \
sim:/harvard_cpu/alu_result_wb_out \
sim:/harvard_cpu/immediate_value_de_in \
sim:/harvard_cpu/immediate_value_de_out
add wave -position insertpoint  \
sim:/harvard_cpu/alu_src1_after_mux \
sim:/harvard_cpu/alu_src2_after_mux \
sim:/harvard_cpu/alu_src2_in \
sim:/harvard_cpu/alu_src_controller_out \
sim:/harvard_cpu/alu_src_de_out \
sim:/harvard_cpu/alu_src_em_out
mem load -i D:/College/Sem8/Architecture/ArchProject/testingout3.mem /harvard_cpu/instruction_memory/cache
mem load -i D:/College/Sem8/Architecture/ArchProject/regfile.mem /harvard_cpu/register_file1/reg
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