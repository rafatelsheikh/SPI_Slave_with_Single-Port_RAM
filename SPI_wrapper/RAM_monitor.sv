package RAM_monitor_pkg;
import uvm_pkg::*;
import RAM_pkg::*;
`include "uvm_macros.svh" 
class RAM_monitor extends uvm_monitor;
    `uvm_component_utils(RAM_monitor)
    virtual RAM_if vif;
    RAM_sequence_item seq_item;
    uvm_analysis_port #(RAM_sequence_item) mon_ap;
    function new(string name = "RAM_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        mon_ap = new("mon_ap", this);
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            @(negedge vif.clk);
            seq_item.rst_n = vif.rst_n;
            seq_item.rx_valid = vif.rx_valid;
            seq_item.din = vif.din;
            seq_item.dout = vif.dout;
            seq_item.tx_valid = vif.tx_valid;
            seq_item.dout_ref = vif.dout_ref;
            seq_item.tx_valid_ref = vif.tx_valid_ref;
            mon_ap.write(seq_item);
            `uvm_info(get_type_name(), seq_item.convert2string(), UVM_HIGH)
        end
    endtask
endclass
endpackage