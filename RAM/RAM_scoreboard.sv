package RAM_scoreboard_pkg;
import uvm_pkg::*;
import RAM_pkg::*;
`include "uvm_macros.svh"
class RAM_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(RAM_scoreboard)
    uvm_analysis_export #(RAM_sequence_item) sb_export;
    uvm_tlm_analysis_fifo #(RAM_sequence_item) sb_fifo;
    RAM_sequence_item seq_item;
    int correct_count = 0;
    int error_count = 0;
    function new(string name = "RAM_scoreboard", uvm_component parent = null);
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
            compare(seq_item);
        end
    endtask
    task compare(RAM_sequence_item seq_item);
        if (seq_item.tx_valid == seq_item.tx_valid_ref && seq_item.dout == seq_item.dout_ref) begin
            correct_count++;
            `uvm_info(get_type_name(), $sformatf("correct: DUT(dout=%0h, tx_valid=%0b) and REF(dout=%0h, tx_valid=%0b)", 
                     seq_item.dout, seq_item.tx_valid, seq_item.dout_ref, seq_item.tx_valid_ref), UVM_HIGH)
        end else begin
            error_count++;
            `uvm_error(get_type_name(), $sformatf("eror: DUT(dout=%0h, tx_valid=%0b) and REF(dout=%0h, tx_valid=%0b)", 
                      seq_item.dout, seq_item.tx_valid, seq_item.dout_ref, seq_item.tx_valid_ref))
        end
    endtask
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf(" correct transactions: %0d", correct_count), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf(" errors: %0d", error_count), UVM_LOW)
        if(error_count == 0)
            `uvm_info(get_type_name(), $sformatf(" No Errors Detected!"), UVM_LOW)
        else
            `uvm_error(get_type_name(), $sformatf(" %0d Errors Detected!", error_count)) 
    endfunction
endclass
endpackage