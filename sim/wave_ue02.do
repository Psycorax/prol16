onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbalu/alu_func
add wave -noupdate /tbalu/side_a
add wave -noupdate /tbalu/side_b
add wave -noupdate /tbalu/cin
add wave -noupdate /tbalu/result
add wave -noupdate /tbalu/cout
add wave -noupdate /tbalu/zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {64 ns}
