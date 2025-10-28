interface SPI_slave_if (clk);
    input clk;
    logic rst_n;
    logic SS_n;
    logic MOSI;
    logic MISO;
    logic rx_valid;
    logic tx_valid;
    logic [9:0] rx_data;
    logic [7:0] tx_data;
    logic MISO_golden;
    logic rx_valid_golden;
    logic [9:0] rx_data_golden;
endinterface