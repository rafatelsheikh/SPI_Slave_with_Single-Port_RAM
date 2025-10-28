import uvm_pkg::*;
import wrapper_test_pkg::*;
`include "uvm_macros.svh"

module top();

bit clk ;

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

SPI_slave_if SPI_slave_ifi (clk);
RAM_if vif(clk);
wrapper_if w_if(clk);

WRAPPER DUT (w_if.MOSI, w_if.MISO, w_if.SS_n, w_if.clk, w_if.rst_n);
SPI_wrapper_golden GOLD(w_if.clk, w_if.rst_n, w_if.SS_n, w_if.MOSI, w_if.MISO_golden);

bind WRAPPER RAM_assertions wrapper_sva (.clk(DUT.clk), .rst_n(DUT.rst_n), 
                                            .rx_valid(DUT.rx_valid), .din(DUT.rx_data_din),
                                            .dout(DUT.tx_data_dout), .tx_valid(DUT.tx_valid));

assign SPI_slave_ifi.rst_n = DUT.rst_n;
assign SPI_slave_ifi.SS_n = DUT.SS_n;
assign SPI_slave_ifi.MOSI = DUT.MOSI;
assign SPI_slave_ifi.tx_data = DUT.tx_data_dout;
assign SPI_slave_ifi.tx_valid = DUT.tx_valid;
assign SPI_slave_ifi.rx_data = DUT.rx_data_din;
assign SPI_slave_ifi.rx_valid = DUT.rx_valid;
assign SPI_slave_ifi.MISO = DUT.MISO;
assign SPI_slave_ifi.rx_data_golden = GOLD.rx_data;
assign SPI_slave_ifi.rx_valid_golden = GOLD.rx_valid;
assign SPI_slave_ifi.MISO_golden = GOLD.MISO_golden;

assign vif.rst_n = DUT.rst_n;
assign vif.din = DUT.rx_data_din;
assign vif.rx_valid = DUT.rx_valid;
assign vif.dout = DUT.tx_data_dout;
assign vif.tx_valid = DUT.tx_valid;
assign vif.dout_ref = GOLD.tx_data;
assign vif.tx_valid_ref = GOLD.tx_valid;



initial begin
    uvm_config_db#(virtual wrapper_if)::set(null, "uvm_test_top", "wrapper_IF", w_if);
    uvm_config_db#(virtual SPI_slave_if)::set(null, "uvm_test_top", "SPI_slave_IF", SPI_slave_ifi);
    uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", vif);
    run_test("wrapper_test");
end

    
endmodule