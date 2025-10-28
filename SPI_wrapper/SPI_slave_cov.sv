package SPI_slave_cov_pkg;
    import SPI_slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_cov extends uvm_component;
        `uvm_component_utils(SPI_slave_cov);

        uvm_analysis_export #(SPI_slave_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(SPI_slave_seq_item) cov_fifo;
        SPI_slave_seq_item seq_item;

        covergroup cg;
            cp_rx_data: coverpoint seq_item.rx_data[9:8] iff (seq_item.rst_n) {
                bins all_values[] = {2'b00, 2'b01, 2'b10, 2'b11};

                bins write_address_write_data = (2'b00 => 2'b01);
                bins write_address_read_address = (2'b00 => 2'b10); 

                bins write_data_write_address = (2'b01 => 2'b00);
                bins write_data_read_data = (2'b01 => 2'b11);

                bins read_address_write_address = (2'b10 => 2'b00);
                bins read_address_read_data = (2'b10 => 2'b11);

                bins read_data_write_data = (2'b11 => 2'b01);
                bins read_data_read_address = (2'b11 => 2'b10);
            }

            cp_SS_n: coverpoint seq_item.SS_n iff (seq_item.rst_n) {
                bins normal_sequence = (1 => 0 [*13] => 1);
                bins read_data_sequence = (1 => 0 [*23] => 1);

                bins MOSI_related = (1 => 0 [*4]);
            }

            cp_MOSI: coverpoint seq_item.MOSI iff (seq_item.rst_n) {
                bins write_address = (0 => 0 => 0);
                bins write_data = (0 => 0 => 1);
                bins read_address = (1 => 1 => 0);
                bins read_data = (1 => 1 => 1);
            }

            cr_SS_n_MOSI: cross cp_SS_n, cp_MOSI iff (seq_item.rst_n) {
                illegal_bins SS_n_normal = binsof(cp_SS_n.normal_sequence);
                illegal_bins SS_n_read_data = binsof(cp_SS_n.read_data_sequence);
            }
        endgroup

        function new(string name = "SPI_slave_cov", uvm_component parent = null);
            super.new(name, parent);
            cg = new();
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
                cg.sample();
            end
        endtask
    endclass
endpackage