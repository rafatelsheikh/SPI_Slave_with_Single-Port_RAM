package RAM_driver_pkg ;
    import uvm_pkg::*;
    import RAM_pkg::*;
    `include "uvm_macros.svh"
class RAM_driver extends uvm_driver #(RAM_sequence_item);
    `uvm_component_utils(RAM_driver)

    virtual RAM_if vif;
    RAM_sequence_item seq_item;

    function new(string name = "RAM_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            seq_item_port.get_next_item(seq_item);
            
            vif.rst_n = seq_item.rst_n;
            vif.rx_valid = seq_item.rx_valid;
            vif.din = seq_item.din;
            
            @(negedge vif.clk);
            seq_item_port.item_done();
            `uvm_info(get_type_name(), seq_item.convert2string_stimulus(), UVM_HIGH)
        end
    endtask
endclass
endpackage