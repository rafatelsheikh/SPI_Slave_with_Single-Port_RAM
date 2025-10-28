package SPI_slave_agent_pkg;
    import SPI_slave_sequencer_pkg::*;
    import SPI_slave_seq_item_pkg::*;
    import SPI_slave_driver_pkg::*;
    import SPI_slave_monitor_pkg::*;
    import SPI_slave_config_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_agent extends uvm_agent;
        `uvm_component_utils(SPI_slave_agent);

        SPI_slave_sequencer sequencer;
        SPI_slave_driver driver;
        SPI_slave_monitor monitor;
        SPI_slave_config cfg;
        uvm_analysis_port #(SPI_slave_seq_item) agent_ap;

        function new(string name = "SPI_slave_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db #(SPI_slave_config)::get(this, "", "SPI_slave_config", cfg))
                `uvm_fatal("build_phase", "unable to get config object");

            if (cfg.is_active == UVM_ACTIVE) begin
                sequencer = SPI_slave_sequencer::type_id::create("sequencer", this);
                driver = SPI_slave_driver::type_id::create("driver", this);
            end

            monitor = SPI_slave_monitor::type_id::create("monitor", this);
            agent_ap = new("agent_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            if (cfg.is_active == UVM_ACTIVE) begin
                driver.SPI_slave_vif = cfg.SPI_slave_vif;
                driver.seq_item_port.connect(sequencer.seq_item_export);
            end

            monitor.SPI_slave_vif = cfg.SPI_slave_vif;
            monitor.monitor_ap.connect(agent_ap);
        endfunction
    endclass
endpackage