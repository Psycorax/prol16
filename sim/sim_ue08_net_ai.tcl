vlib work

vcom -reportprogress 300 -work work ../src/prol16_pack.vhd
vcom -reportprogress 300 -work work ../syn/netlist_cpu.vhd
vcom -reportprogress 300 -work work ../src/memory.vhd
vcom -reportprogress 300 -work work ../src/cpu_tb.vhd

vsim -t ps cpu_tb -suppress 3240 -suppress 3569 -suppress 8683 -suppress 1954 -noglitch -sdfmax /DUT=../syn/netlist_cpu.sdf -gfile_base_g="ai"


catch {do wave_ue08_net.do}
run -all
wave zoom full
