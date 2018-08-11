vlib work
vcom -87 -lint -check_synthesis ../src/prol16_pack.vhd
vcom -87 -lint -check_synthesis ../src/alu-e.vhd
vcom -87 -lint -check_synthesis ../src/alu-Rtl-a.vhd
vcom -93 -lint ../src/tbAlu-Bhv-ea.vhd
vsim tbAlu

run 800 ns