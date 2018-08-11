vlib work
vcom -87 -lint -check_synthesis ../src/prol16_pack.vhd
vcom -87 -lint -check_synthesis ../syn/netlist_alu.vhd
vcom -93 -lint ../src/tbAlu-Bhv-ea.vhd

#vsim tbAlu
vsim -sdfmax /TheAlu=../syn/netlist_alu.sdf -noglitch -t ps tbAlu

run 900 ns