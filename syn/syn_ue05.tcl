#
# template script for synopsys
#

remove_design -all

# some variables
set exercise 5
set design datapath
set sources {prol16_pack alu-e alu-Rtl-a reg_file datapath}

# analyze
echo "Analyzing..."
foreach s $sources {
    analyze -format vhdl ../src/${s}.vhd
}

# elaborate
echo "Elaborate..."
elaborate $design

# set environment and constraints
set_operating_conditions WORST
create_clock clk_i -period 62.5
set_clock_latency 1.0 clk_i
set_clock_uncertainty 0.2 clk_i
set_dont_touch_network clk_i
set_ideal_network clk_i
set_ideal_network res_i

# set optimization constraints
set_max_area 0


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
