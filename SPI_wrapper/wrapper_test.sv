package wrapper_test_pkg;
    import wrapper_rst_seq_pkg::*;
    import wrapper_wr_seq_pkg::*;
    import wrapper_ro_seq_pkg::*;
    import wrapper_wo_seq_pkg::*;
    import wrapper_env_pkg::*;
    import RAM_env_pkg::*;
    import SPI_slave_env_pkg::*;
    import wrapper_config_pkg::*;
    import RAM_config_obj_pkg::*;
    import SPI_slave_config_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_test extends uvm_test;
        `uvm_component_utils(wrapper_test)

        wrapper_env w_env;
        RAM_env R_env;
        SPI_slave_env SPI_env;
        wrapper_config wrapper_cfg;
        RAM_config_obj RAM_cfg;
        SPI_slave_config SPI_slave_cfg;
        virtual wrapper_if wrapper_vif;
        virtual SPI_slave_if SPI_slave_vif;
        virtual RAM_if RAM_vif;
        wrapper_rst_seq rst_seq;
        wrapper_wo_seq wo_seq;
        wrapper_ro_seq ro_seq;
        wrapper_wr_seq wr_seq;

        function new(string name = "wrapper_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            w_env = wrapper_env::type_id::create("w_env", this);
            wrapper_cfg = wrapper_config::type_id::create("wrapper_cfg", this);
            R_env = RAM_env::type_id::create("R_env", this);
            RAM_cfg = RAM_config_obj::type_id::create("RAM_cfg", this);
            SPI_env = SPI_slave_env::type_id::create("SPI_env", this);
            SPI_slave_cfg = SPI_slave_config::type_id::create("SPI_slave_cfg", this);
            rst_seq = wrapper_rst_seq::type_id::create("rst_seq", this);
            wo_seq = wrapper_wo_seq::type_id::create("wo_seq", this);
            ro_seq = wrapper_ro_seq::type_id::create("ro_seq", this);
            wr_seq = wrapper_wr_seq::type_id::create("wr_seq", this);

            if (!uvm_config_db #(virtual wrapper_if)::get(this, "", "wrapper_IF", wrapper_cfg.wrapper_vif))
                `uvm_fatal("build_phase", "Test - unable to get the wrapper virtual interface");

            if (!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", RAM_cfg.vif))
                `uvm_fatal("build_phase", "Test - unable to get the RAM virtual interface");

            if (!uvm_config_db #(virtual SPI_slave_if)::get(this, "", "SPI_slave_IF", SPI_slave_cfg.SPI_slave_vif))
                `uvm_fatal("build_phase", "Test - unable to get the SPI_slave virtual interface");

            wrapper_cfg.is_active = UVM_ACTIVE;
            RAM_cfg.is_active = UVM_PASSIVE;
            SPI_slave_cfg.is_active = UVM_PASSIVE;

            uvm_config_db #(wrapper_config)::set(this, "*", "wrapper_CFG", wrapper_cfg);
            uvm_config_db #(RAM_config_obj)::set(this, "*", "RAM_config_obj", RAM_cfg);
            uvm_config_db #(SPI_slave_config)::set(this, "*", "SPI_slave_config", SPI_slave_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            phase.raise_objection(this);

            `uvm_info("run_phase", "reset asserted", UVM_LOW);
            
            rst_seq.start(w_env.agent.sequencer);
            
            `uvm_info("run_phase", "reset deasserted", UVM_LOW);

            `uvm_info("run_phase", "write only generation started", UVM_LOW);
            
            wo_seq.start(w_env.agent.sequencer);
            
            `uvm_info("run_phase", "write only generation ended", UVM_LOW);

            `uvm_info("run_phase", "read only generation started", UVM_LOW);
            
            ro_seq.start(w_env.agent.sequencer);
            
            `uvm_info("run_phase", "read only generation ended", UVM_LOW);

            `uvm_info("run_phase", "write read generation started", UVM_LOW);
            
            wr_seq.start(w_env.agent.sequencer);
           
            `uvm_info("run_phase", "write read generation ended", UVM_LOW);
           
            phase.drop_objection(this);
        endtask
    endclass
endpackage