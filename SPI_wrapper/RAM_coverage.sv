package RAM_coverage_pkg ;
import uvm_pkg::*;
import RAM_pkg::*;
`include "uvm_macros.svh"
class RAM_coverage extends uvm_component;
    `uvm_component_utils(RAM_coverage)

    uvm_analysis_export #(RAM_sequence_item) cov_export;
    uvm_tlm_analysis_fifo #(RAM_sequence_item) cov_fifo;
    RAM_sequence_item seq_item;

    covergroup cvr_grp;
        cp_din: coverpoint seq_item.din[9:8] {
            bins write_address = {2'b00};
            bins write_data = {2'b01};
            bins read_address = {2'b10};
            bins read_data = {2'b11};
        }
        cp_rx_valid: coverpoint seq_item.rx_valid {
            bins high = {1};
            bins low = {0};
        }
        cp_tx_valid: coverpoint seq_item.tx_valid {
            bins high = {1};
            bins low = {0};
        }

        cp_write_sequence: coverpoint seq_item.din[9:8] {
            bins write_add_to_write_data = (2'b00 => 2'b01);
        }
        cp_read_sequence: coverpoint seq_item.din[9:8] {
            bins read_add_to_read_data = (2'b10 => 2'b11);
        }

        cross_din_rx_valid: cross cp_din, cp_rx_valid {
            ignore_bins ignore_rx_low = binsof(cp_rx_valid.low);
        }
        cross_read_tx_valid: cross cp_din, cp_tx_valid {
            bins read_with_tx = binsof(cp_din.read_data) && binsof(cp_tx_valid.high);
            ignore_bins ignore_others = binsof(cp_din.write_address) ||  binsof(cp_din.write_data) ||  binsof(cp_din.read_address) ||binsof(cp_tx_valid.low);
        }
    endgroup

    function new(string name = "RAM_coverage", uvm_component parent = null);
        super.new(name, parent);
        cvr_grp = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            cov_fifo.get(seq_item);
            cvr_grp.sample();
        end
    endtask
endclass
endpackage 
