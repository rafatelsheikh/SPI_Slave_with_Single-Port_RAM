interface wrapper_if(clk);

input clk;
logic MOSI, SS_n, rst_n;
logic MISO;
logic MISO_golden;

endinterface : wrapper_if
