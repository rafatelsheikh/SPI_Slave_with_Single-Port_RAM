package RAM_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh" 
    import RAM_pkg::*;
    import RAM_sequence_pkg::*;
    import RAM_env_pkg::*; 
    import RAM_config_obj_pkg::*;
class RAM_test extends uvm_test;
    `uvm_component_utils(RAM_test)
    RAM_env env;
    RAM_config_obj cfg;
    virtual RAM_if vif;
    reset_sequence rst_seq;
    write_only_sequence wr_seq;
    read_only_sequence rd_seq;
    write_read_sequence wr_rd_seq;
    main_sequence main_seq;

    function new(string name = "RAM_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = RAM_config_obj::type_id::create("cfg", this);
        env = RAM_env::type_id::create("env", this);
        rst_seq = reset_sequence::type_id::create("rst_seq", this);
        wr_seq = write_only_sequence::type_id::create("wr_seq", this);
        rd_seq = read_only_sequence::type_id::create("rd_seq", this);
        wr_rd_seq = write_read_sequence::type_id::create("wr_rd_seq", this);
        main_seq = main_sequence::type_id::create("main_seq", this);

        if (!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", cfg.vif))
            `uvm_fatal("build_phase", "Test - unable to get the wrapper virtual interface");

        cfg.is_active = UVM_ACTIVE;

        uvm_config_db#(RAM_config_obj)::set(this, "*", "RAM_config_obj", cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        `uvm_info(get_type_name(), "Starting Reset Sequence", UVM_MEDIUM)
        
        rst_seq.start(env.agt.sqr);

        #10;

        `uvm_info(get_type_name(), "Starting Write Only Sequence", UVM_MEDIUM)

        wr_seq.start(env.agt.sqr);

        #10;

        `uvm_info(get_type_name(), "Starting Read Only Sequence", UVM_MEDIUM)

        rd_seq.start(env.agt.sqr);

        #10;

        `uvm_info(get_type_name(), "Starting Write-Read Sequence", UVM_MEDIUM)


        wr_rd_seq.start(env.agt.sqr);

        #10;
    
        `uvm_info(get_type_name(), "Starting Main Sequence", UVM_MEDIUM)

        main_seq.start(env.agt.sqr);

        #100;

        phase.drop_objection(this);
    endtask 
endclass

endpackage