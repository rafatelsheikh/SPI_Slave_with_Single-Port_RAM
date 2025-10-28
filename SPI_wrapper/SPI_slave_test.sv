package SPI_slave_test_pkg;
    import SPI_slave_rst_seq_pkg::*;
    import SPI_slave_main_seq_pkg::*;
    import SPI_slave_env_pkg::*;
    import SPI_slave_config_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_test extends uvm_test;
        `uvm_component_utils(SPI_slave_test)

        SPI_slave_env env;
        SPI_slave_config SPI_slave_cfg;
        virtual SPI_slave_if SPI_slave_vif;
        SPI_slave_rst_seq rst_seq;
        SPI_slave_main_seq main_seq;

        function new(string name = "SPI_slave_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            env = SPI_slave_env::type_id::create("env" ,this);
            SPI_slave_cfg = SPI_slave_config::type_id::create("SPI_slave_cfg" ,this);
            rst_seq = SPI_slave_rst_seq::type_id::create("rst_seq", this);
            main_seq = SPI_slave_main_seq::type_id::create("main_seq", this);

            if (!uvm_config_db #(virtual SPI_slave_if)::get(this, "", "SPI_SLAVE_IF", SPI_slave_cfg.SPI_slave_vif))
                `uvm_fatal("build_phase", "Test - unable to get the virtual interface");

            SPI_slave_cfg.is_active = UVM_ACTIVE;

            uvm_config_db #(SPI_slave_config)::set(this, "*", "SPI_SLAVE_CFG", SPI_slave_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            phase.raise_objection(this);

            `uvm_info("run_phase", "reset asserted", UVM_LOW);
            
            rst_seq.start(env.agent.sequencer);

            `uvm_info("run_phase", "reset deasserted", UVM_LOW);

            `uvm_info("run_phase", "stimulus generation started", UVM_LOW);

            main_seq.start(env.agent.sequencer);

            `uvm_info("run_phase", "stimulus generation ended", UVM_LOW);

            phase.drop_objection(this);
        endtask
    endclass
endpackage