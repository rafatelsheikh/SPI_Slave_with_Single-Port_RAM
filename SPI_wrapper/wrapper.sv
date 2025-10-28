module WRAPPER (MOSI,MISO,SS_n,clk,rst_n);

input  MOSI, SS_n, clk, rst_n;
output MISO;

wire [9:0] rx_data_din;
wire       rx_valid;
wire       tx_valid;
wire [7:0] tx_data_dout;

RAM   RAM_instance   (rx_data_din,clk,rst_n,rx_valid,tx_data_dout,tx_valid);
SLAVE SLAVE_instance (MOSI,MISO,SS_n,clk,rst_n,rx_data_din,rx_valid,tx_data_dout,tx_valid);

`ifdef SIM

  property reset_check;
    @(posedge clk) rst_n == 0 |=> (MISO == 0 && rx_valid == 0 && rx_data_din == 0);
  endproperty

  property miso_stable_when_not_read;
    @(posedge clk) disable iff (!rst_n)
      ((!tx_valid) && $fell(SS_n)) |=> (SS_n == 0 && $stable(MISO)) [*11];
  endproperty

  a_reset_check: assert property (reset_check);
  c_reset_check: cover property (reset_check);
  a_miso_stable_when_not_read: assert property (miso_stable_when_not_read);
  c_miso_stable_when_not_read: cover property (miso_stable_when_not_read);

`endif

endmodule