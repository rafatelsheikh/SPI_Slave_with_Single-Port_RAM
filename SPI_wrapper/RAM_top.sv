import uvm_pkg::*;
import RAM_pkg::*;
import RAM_test_pkg::*;
`include "uvm_macros.svh"
module RAM_top;
    bit clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    RAM_if vif(clk);
    RAM dut (.din(vif.din),.clk(vif.clk),.rst_n(vif.rst_n),.rx_valid(vif.rx_valid),.dout(vif.dout),.tx_valid(vif.tx_valid));
    RAM_golden golden (.clk(vif.clk), .rst_n(vif.rst_n),.din(vif.din),.rx_valid(vif.rx_valid),.dout(vif.dout_ref),.tx_valid(vif.tx_valid_ref) );
    bind RAM RAM_assertions ram_assertions_inst (.clk(clk),.rst_n(rst_n),.rx_valid(rx_valid),.din(din),.dout(dout), .tx_valid(tx_valid));

    initial begin
        uvm_config_db#(virtual RAM_if)::set(null, "*", "RAM_IF", vif);
        run_test("RAM_test");
    end 
    
endmodule