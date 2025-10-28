vlib work
vlog -f src_files.list +cover -covercells 
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover -l sim.log -sv_seed 1374903841
add wave /top/w_if/*
add wave /top/SPI_slave_ifi/*
add wave /top/vif/*
add wave /top/DUT/a_reset_check /top/DUT/a_miso_stable_when_not_read /top/DUT/SLAVE_instance/a_rst_MISO /top/DUT/SLAVE_instance/a_rst_rx_valid /top/DUT/SLAVE_instance/a_rst_rx_data /top/DUT/SLAVE_instance/a_rx_valid_write_address /top/DUT/SLAVE_instance/a_rx_valid_write_data /top/DUT/SLAVE_instance/a_rx_valid_read_address /top/DUT/SLAVE_instance/a_rx_valid_read_data /top/DUT/SLAVE_instance/a_IDLE_to_CHK_CMD /top/DUT/SLAVE_instance/a_CHK_CMD_to_WRITE /top/DUT/SLAVE_instance/a_CHK_CMD_to_READ_ADD /top/DUT/SLAVE_instance/a_CHK_CMD_to_READ_DATA /top/DUT/SLAVE_instance/a_WRITE_to_IDLE /top/DUT/SLAVE_instance/a_READ_ADD_to_IDLE /top/DUT/SLAVE_instance/a_READ_DATA_to_IDLE /top/DUT/wrapper_sva/assert_reset_outputs /top/DUT/wrapper_sva/assert_tx_valid_input /top/DUT/wrapper_sva/assert_tx_valid_read /top/DUT/wrapper_sva/assert_write_sequence /top/DUT/wrapper_sva/assert_read_sequence
coverage save WRAPPER.ucdb -onexit 
run -all 
