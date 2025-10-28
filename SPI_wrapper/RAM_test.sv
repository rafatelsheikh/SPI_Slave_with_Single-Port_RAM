package RAM_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh" 
    import RAM_pkg::*;
    import RAM_sequence_pkg::*;
    import RAM_env_pkg::*; 
    import RAM_config_obj_pkg::*;
class RAM_test extends uvm_test;
RAM_config_obj cfg;
    `uvm_component_utils(RAM_test)
    RAM_env env;
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
        uvm_config_db#(RAM_config_obj)::set(this, "agt", "RAM_config_obj", cfg);
        env = RAM_env::type_id::create("env", this);
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "Starting Reset Sequence", UVM_MEDIUM)
        rst_seq = reset_sequence::type_id::create("rst_seq");
        rst_seq.start(env.agt.sqr);
        #10;
        `uvm_info(get_type_name(), "Starting Write Only Sequence", UVM_MEDIUM)
        wr_seq = write_only_sequence::type_id::create("wr_seq");
        wr_seq.start(env.agt.sqr);
        #10;
        `uvm_info(get_type_name(), "Starting Read Only Sequence", UVM_MEDIUM)
        rd_seq = read_only_sequence::type_id::create("rd_seq");
        rd_seq.start(env.agt.sqr);
        #10;
        `uvm_info(get_type_name(), "Starting Write-Read Sequence", UVM_MEDIUM)
        wr_rd_seq = write_read_sequence::type_id::create("wr_rd_seq");
        wr_rd_seq.start(env.agt.sqr);
        #10;
        `uvm_info(get_type_name(), "Starting Main Sequence", UVM_MEDIUM)
        main_seq = main_sequence::type_id::create("main_seq");
        main_seq.start(env.agt.sqr);
        #100;
        phase.drop_objection(this);
    endtask 
endclass

endpackage