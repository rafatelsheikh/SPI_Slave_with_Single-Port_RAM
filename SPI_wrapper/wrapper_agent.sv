package wrapper_agent_pkg;
    import wrapper_sqr_pkg::*;
    import wrapper_seq_item_pkg::*;
    import wrapper_driver_pkg::*;
    import wrapper_monitor_pkg::*;
    import wrapper_config_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_agent extends uvm_agent;
        `uvm_component_utils(wrapper_agent);

        wrapper_sqr sequencer;
        wrapper_driver driver;
        wrapper_monitor monitor;
        wrapper_config cfg;
        uvm_analysis_port #(wrapper_seq_item) agent_ap;

        function new(string name = "wrapper_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db #(wrapper_config)::get(this, "", "wrapper_CFG", cfg))
                `uvm_fatal("build_phase", "unable to get config object");

            if (cfg.is_active == UVM_ACTIVE) begin
                sequencer = wrapper_sqr::type_id::create("sequencer", this);
                driver = wrapper_driver::type_id::create("driver", this);
            end

            monitor = wrapper_monitor::type_id::create("monitor", this);
            agent_ap = new("agent_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            if (cfg.is_active == UVM_ACTIVE) begin
                driver.wrapper_vif = cfg.wrapper_vif;
                driver.seq_item_port.connect(sequencer.seq_item_export);
            end

            monitor.wrapper_vif = cfg.wrapper_vif;
            monitor.monitor_ap.connect(agent_ap);
        endfunction
    endclass
endpackage