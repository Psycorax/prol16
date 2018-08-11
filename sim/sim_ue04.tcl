vlib work
vcom -87 -lint -check_synthesis ../src/prol16_pack.vhd
#vcom -87 -lint -check_synthesis ../src/spikefilter.vhd
vcom -87 -lint -check_synthesis ../syn/netlist_spikefilter.vhd
vcom -93 -lint ../src/spikefilter_tb.vhd

#vsim spikefilter_tb
vsim -sdfmax /DUT=../syn/netlist_spikefilter.sdf -noglitch -t ps spikefilter_tb

add wave -position end  sim:/spikefilter_tb/InputPin
add wave -position end  sim:/spikefilter_tb/RiseEdgeOnPin
add wave -position end  sim:/spikefilter_tb/FallEdgeOnPin
add wave -position end  sim:/spikefilter_tb/LevelOnPin
add wave -position end  sim:/spikefilter_tb/Clk
add wave -position end  sim:/spikefilter_tb/nReset
add wave -position end  sim:/spikefilter_tb/DUT/CaptureFlipFlop_0_port
add wave -position end  sim:/spikefilter_tb/DUT/CaptureFlipFlop_1_port
add wave -position end  sim:/spikefilter_tb/DUT/CaptureFlipFlop_2_port
add wave -position end  sim:/spikefilter_tb/DUT/CaptureFlipFlop_3_port
add wave -position end  sim:/spikefilter_tb/DUT/CaptureFlipFlop_4_port

run 1900 ns
