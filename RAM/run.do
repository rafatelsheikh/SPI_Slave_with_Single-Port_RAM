vlib work
vlog -f src_files.list +cover -covercells 
vsim -voptargs=+acc work.RAM_top -classdebug -uvmcontrol=all -cover -l sim.log -sv_seed 1463002509
add wave /RAM_top/vif/*
add wave /RAM_top/dut/ram_assertions_inst/assert_reset_outputs /RAM_top/dut/ram_assertions_inst/assert_tx_valid_input /RAM_top/dut/ram_assertions_inst/assert_tx_valid_read /RAM_top/dut/ram_assertions_inst/assert_write_sequence /RAM_top/dut/ram_assertions_inst/assert_read_sequence
coverage save RAM.ucdb -onexit 
run -all 
