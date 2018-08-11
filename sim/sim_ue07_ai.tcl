vlib work

vcom -reportprogress 300 -work work ../src/prol16_pack.vhd
vcom -reportprogress 300 -work work ../src/reg_file.vhd
vcom -reportprogress 300 -work work ../src/alu-e.vhd
vcom -reportprogress 300 -work work ../src/alu-Rtl-a.vhd
vcom -reportprogress 300 -work work ../src/datapath.vhd
vcom -reportprogress 300 -work work ../src/control.vhd
vcom -reportprogress 300 -work work ../src/cpu.vhd
vcom -reportprogress 300 -work work ../src/memory.vhd
vcom -reportprogress 300 -work work ../src/cpu_tb.vhd

vsim -novopt -t fs work.cpu_tb(beh) -gfile_base_g="ai"

add wave \
sim:/cpu_tb/dut/datapath_inst/registerFile/regs \
sim:/cpu_tb/dut/control_inst/R \
sim:/cpu_tb/dut/control_inst/op_code_i \
sim:/cpu_tb/dut/sel_pc \
sim:/cpu_tb/dut/sel_load \
sim:/cpu_tb/dut/sel_addr \
sim:/cpu_tb/dut/clk_en_pc \
sim:/cpu_tb/dut/clk_en_reg_file \
sim:/cpu_tb/dut/clk_en_op_code \
sim:/cpu_tb/dut/alu_func

run -all

