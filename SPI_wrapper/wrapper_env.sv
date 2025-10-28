package wrapper_env_pkg;
    import wrapper_scoreboard_pkg::*;
    import wrapper_config_pkg::*;
    import wrapper_agent_pkg::*;
    import wrapper_cov_pkg::*;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_env extends uvm_env;
        `uvm_component_utils(wrapper_env)

        wrapper_scoreboard sb;
        wrapper_agent agent;
        wrapper_cov cov;

        function new(string name = "wrapper_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            sb = wrapper_scoreboard::type_id::create("sb", this);
            agent = wrapper_agent::type_id::create("agent", this);
            cov = wrapper_cov::type_id::create("cov", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            agent.agent_ap.connect(sb.sb_export);
            agent.agent_ap.connect(cov.cov_export);
        endfunction
    endclass
endpackage