onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /cpu_tb/dut/datapath_inst/registerFile/regs
add wave -noupdate -expand /cpu_tb/dut/control_inst/R
add wave -noupdate /cpu_tb/dut/control_inst/op_code_i
add wave -noupdate /cpu_tb/dut/sel_pc
add wave -noupdate /cpu_tb/dut/sel_load
add wave -noupdate /cpu_tb/dut/sel_addr
add wave -noupdate /cpu_tb/dut/clk_en_pc
add wave -noupdate /cpu_tb/dut/clk_en_reg_file
add wave -noupdate /cpu_tb/dut/clk_en_op_code
add wave -noupdate /cpu_tb/dut/alu_func
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32456424870 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 142
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits fs
update
WaveRestoreZoom {0 fs} {32740196891 fs}
