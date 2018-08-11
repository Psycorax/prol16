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

vsim -novopt -t fs work.cpu_tb(beh) -gfile_base_g="mul"

catch {do wave_ue08.do}
run -all
wave zoom full
