# some variables
set exercise 7
set design cpu
set sources {prol16_pack alu-e alu-Rtl-a reg_file datapath control cpu}

# analyze
echo "Analyzing..."
foreach s $sources {
    analyze -format vhdl ../src/${s}.vhd
}

# elaborate
echo "Elaborate..."
elaborate $design

# set environment and constraints

# period 200 ns = 5 MHz clock
create_clock clk_i -period 200

#set_clock_latency 1 [get_clocks clk_i]
#set_clock_uncertainty 0.2 [get_clocks clk_i]
set_operating_conditions -library c35_CORELIB WORST
set_ideal_network [get_ports res_i]

# compile
echo "Compile..."
compile

# write results

# changing names is required for legal VHDL identifiers
echo "Changing names..."
change_names -rules vhdl -hierarchy

echo "Write netlist and SDF..."
write -hierarchy -format vhdl -output netlist_${design}.vhd
write_sdf -version 2.1 netlist_${design}.sdf
exec fix_sdf netlist_${design}.sdf

echo "Writing reports..."
report_area > ../doc/area_${exercise}.rep
report_timing > ../doc/timing_${exercise}.rep
