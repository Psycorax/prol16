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
add wave -noupdate /cpu_tb/dut/control_inst/clk_i
add wave -noupdate /cpu_tb/dut/control_inst/res_i
add wave -noupdate /cpu_tb/dut/control_inst/op_code_i
add wave -noupdate /cpu_tb/dut/control_inst/reg_decode_error_i
add wave -noupdate /cpu_tb/dut/control_inst/sel_pc_o
add wave -noupdate /cpu_tb/dut/control_inst/sel_load_o
add wave -noupdate /cpu_tb/dut/control_inst/sel_addr_o
add wave -noupdate /cpu_tb/dut/control_inst/clk_en_pc_o
add wave -noupdate /cpu_tb/dut/control_inst/clk_en_reg_file_o
add wave -noupdate /cpu_tb/dut/control_inst/clk_en_op_code_o
add wave -noupdate /cpu_tb/dut/control_inst/alu_func_o
add wave -noupdate /cpu_tb/dut/control_inst/carry_o
add wave -noupdate /cpu_tb/dut/control_inst/carry_i
add wave -noupdate /cpu_tb/dut/control_inst/zero_i
add wave -noupdate /cpu_tb/dut/control_inst/mem_rd_stb_o
add wave -noupdate /cpu_tb/dut/control_inst/mem_wr_stb_o
add wave -noupdate /cpu_tb/dut/control_inst/illegal_inst_o
add wave -noupdate /cpu_tb/dut/control_inst/cpu_halt_o
add wave -noupdate /cpu_tb/dut/control_inst/R
add wave -noupdate /cpu_tb/dut/control_inst/NextR
add wave -noupdate /cpu_tb/dut/control_inst/opc_nop
add wave -noupdate /cpu_tb/dut/datapath_inst/clk_i
add wave -noupdate /cpu_tb/dut/datapath_inst/res_i
add wave -noupdate /cpu_tb/dut/datapath_inst/op_code_o
add wave -noupdate /cpu_tb/dut/datapath_inst/reg_decode_error_o
add wave -noupdate /cpu_tb/dut/datapath_inst/sel_pc_i
add wave -noupdate /cpu_tb/dut/datapath_inst/sel_load_i
add wave -noupdate /cpu_tb/dut/datapath_inst/sel_addr_i
add wave -noupdate /cpu_tb/dut/datapath_inst/clk_en_pc_i
add wave -noupdate /cpu_tb/dut/datapath_inst/clk_en_reg_file_i
add wave -noupdate /cpu_tb/dut/datapath_inst/clk_en_op_code_i
add wave -noupdate /cpu_tb/dut/datapath_inst/alu_func_i
add wave -noupdate /cpu_tb/dut/datapath_inst/carry_i
add wave -noupdate /cpu_tb/dut/datapath_inst/carry_o
add wave -noupdate /cpu_tb/dut/datapath_inst/zero_o
add wave -noupdate /cpu_tb/dut/datapath_inst/mem_addr_o
add wave -noupdate /cpu_tb/dut/datapath_inst/mem_data_o
add wave -noupdate /cpu_tb/dut/datapath_inst/mem_data_i
add wave -noupdate /cpu_tb/dut/datapath_inst/reg_sel_ra
add wave -noupdate /cpu_tb/dut/datapath_inst/reg_sel_rb
add wave -noupdate /cpu_tb/dut/datapath_inst/reg_opcode
add wave -noupdate /cpu_tb/dut/datapath_inst/reg_tmp_ra
add wave -noupdate /cpu_tb/dut/datapath_inst/reg_tmp_rb
add wave -noupdate /cpu_tb/dut/datapath_inst/reg_pc
add wave -noupdate /cpu_tb/dut/datapath_inst/regs_in
add wave -noupdate /cpu_tb/dut/datapath_inst/regs_out_a
add wave -noupdate /cpu_tb/dut/datapath_inst/regs_out_b
add wave -noupdate /cpu_tb/dut/datapath_inst/alu_in_a
add wave -noupdate /cpu_tb/dut/datapath_inst/alu_in_b
add wave -noupdate /cpu_tb/dut/datapath_inst/alu_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5500000000 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 315
configure wave -valuecolwidth 134
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
WaveRestoreZoom {0 fs} {20123926380 fs}
