import SPI_slave_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module SPI_slave_top();
    bit clk;

    always #1 clk = ~clk;

    SPI_slave_if SPI_slave_ifi (clk);
    SLAVE dut (SPI_slave_ifi.MOSI, SPI_slave_ifi.MISO, SPI_slave_ifi.SS_n, SPI_slave_ifi.clk, SPI_slave_ifi.rst_n,
                SPI_slave_ifi.rx_data, SPI_slave_ifi.rx_valid, SPI_slave_ifi.tx_data, SPI_slave_ifi.tx_valid);
    SPI_slave_golden golden (SPI_slave_ifi.clk, SPI_slave_ifi.rst_n, SPI_slave_ifi.SS_n,
                                SPI_slave_ifi.MOSI, SPI_slave_ifi.tx_valid, SPI_slave_ifi.tx_data,
                                SPI_slave_ifi.rx_valid_golden, SPI_slave_ifi.rx_data_golden, SPI_slave_ifi.MISO_golden);

    initial begin
        uvm_config_db #(virtual SPI_slave_if)::set(null, "uvm_test_top", "SPI_SLAVE_IF", SPI_slave_ifi);
        run_test("SPI_slave_test");
    end
endmodule