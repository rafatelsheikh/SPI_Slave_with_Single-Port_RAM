package SPI_slave_env_pkg;
    import SPI_slave_scoreboard_pkg::*;
    import SPI_slave_cov_pkg::*;
    import SPI_slave_agent_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_env extends uvm_env;
        `uvm_component_utils(SPI_slave_env)

        SPI_slave_scoreboard sb;
        SPI_slave_agent agent;
        SPI_slave_cov cov;

        function new(string name = "SPI_slave_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            sb = SPI_slave_scoreboard::type_id::create("sb", this);
            agent = SPI_slave_agent::type_id::create("agent", this);
            cov = SPI_slave_cov::type_id::create("cov", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            agent.agent_ap.connect(sb.sb_export);
            agent.agent_ap.connect(cov.cov_export);
        endfunction
    endclass
endpackage