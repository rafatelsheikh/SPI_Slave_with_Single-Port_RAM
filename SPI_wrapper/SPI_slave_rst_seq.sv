package SPI_slave_rst_seq_pkg;
    import SPI_slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_rst_seq extends uvm_sequence #(SPI_slave_seq_item);
        `uvm_object_utils(SPI_slave_rst_seq);

        SPI_slave_seq_item seq_item;

        function new(string name = "SPI_slave_rst_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = SPI_slave_seq_item::type_id::create("seq_item");
            
            start_item(seq_item);

            seq_item.rst_n = 0;

            finish_item(seq_item);
        endtask
    endclass
endpackage