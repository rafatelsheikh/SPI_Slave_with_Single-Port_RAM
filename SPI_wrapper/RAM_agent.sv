package RAM_agent_pkg ;
    import uvm_pkg::*;
    import RAM_sequencer_pkg::*;
    import RAM_driver_pkg::*;
    import RAM_pkg::*;
    import RAM_monitor_pkg::*;
    import RAM_config_obj_pkg::*;
    `include "uvm_macros.svh"
class RAM_agent extends uvm_agent;
    `uvm_component_utils(RAM_agent)

    RAM_driver drv;
    RAM_sequencer sqr;
    RAM_monitor mon;
    RAM_config_obj cfg;
    uvm_analysis_port #(RAM_sequence_item) agent_ap;

    function new(string name = "RAM_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(RAM_config_obj)::get(this, "", "RAM_config_obj", cfg))
                `uvm_fatal("build_phase", "unable to get config object");

        if(cfg.is_active == UVM_ACTIVE) begin
            drv = RAM_driver::type_id::create("drv", this);
            sqr = RAM_sequencer::type_id::create("sqr", this);
        end

        agent_ap = new("agent_ap", this);
        mon = RAM_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(cfg.is_active == UVM_ACTIVE) begin
            drv.vif = cfg.vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
        end

        mon.vif = cfg.vif;
        mon.mon_ap.connect(agent_ap);
    endfunction
endclass
endpackage 

