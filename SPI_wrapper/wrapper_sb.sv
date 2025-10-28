package wrapper_scoreboard_pkg;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(wrapper_scoreboard);

        uvm_analysis_export #(wrapper_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(wrapper_seq_item) sb_fifo;
        wrapper_seq_item seq_item;

        int error_count, correct_count;

        function new(string name = "wrapper_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                sb_fifo.get(seq_item);

                if (seq_item.MISO != seq_item.MISO_golden) begin
                    error_count++;

                    `uvm_error("run_phase", $sformatf("Wrong Output: %s",
                                seq_item.convert2string()));
                end else begin
                    correct_count++;

                    `uvm_info("run_phase", $sformatf("Correct Output: %s",
                                seq_item.convert2string()), UVM_HIGH);
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);

            `uvm_info("report_phase", $sformatf("total correct: %d, total error: %d", correct_count, error_count), UVM_MEDIUM);
        endfunction
    endclass
endpackage