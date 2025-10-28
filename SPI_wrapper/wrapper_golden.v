module SPI_wrapper_golden (clk, rst_n, SS_n, MOSI, MISO_golden);
    input  clk, rst_n, MOSI, SS_n;
    output MISO_golden;

    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;

    SPI_slave_golden inst1 (clk, rst_n, SS_n, MOSI, tx_valid, tx_data, rx_valid, rx_data, MISO_golden);
    RAM_golden inst2 (clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);
endmodule