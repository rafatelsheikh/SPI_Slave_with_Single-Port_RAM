vlib work
vlog -f src_files.list +cover -covercells 
vsim -voptargs=+acc work.SPI_slave_top -classdebug -uvmcontrol=all -cover -l sim.log -sv_seed 1909088641
add wave /SPI_slave_top/SPI_slave_ifi/*
add wave /SPI_slave_top/dut/a_rst_MISO /SPI_slave_top/dut/a_rst_rx_valid /SPI_slave_top/dut/a_rst_rx_data /SPI_slave_top/dut/a_rx_valid_write_address /SPI_slave_top/dut/a_rx_valid_write_data /SPI_slave_top/dut/a_rx_valid_read_address /SPI_slave_top/dut/a_rx_valid_read_data /SPI_slave_top/dut/a_IDLE_to_CHK_CMD /SPI_slave_top/dut/a_CHK_CMD_to_WRITE /SPI_slave_top/dut/a_CHK_CMD_to_READ_ADD /SPI_slave_top/dut/a_CHK_CMD_to_READ_DATA /SPI_slave_top/dut/a_WRITE_to_IDLE /SPI_slave_top/dut/a_READ_ADD_to_IDLE /SPI_slave_top/dut/a_READ_DATA_to_IDLE
coverage save SPI_slave.ucdb -onexit 
run -all