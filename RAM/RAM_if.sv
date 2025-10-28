interface RAM_if(input bit clk);
    logic rst_n;
    logic rx_valid;
    logic [9:0] din;
    logic [7:0] dout;
    logic tx_valid;
    logic [7:0] dout_ref;
    logic tx_valid_ref;
endinterface