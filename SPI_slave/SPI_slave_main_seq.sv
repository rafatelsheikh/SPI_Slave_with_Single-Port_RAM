package SPI_slave_main_seq_pkg;
    import SPI_slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_main_seq extends uvm_sequence #(SPI_slave_seq_item);
        `uvm_object_utils(SPI_slave_main_seq);

        SPI_slave_seq_item seq_item;

        function new(string name = "SPI_slave_main_seq");
            super.new(name);
        endfunction

        task body;
            repeat (10000) begin
                seq_item = SPI_slave_seq_item::type_id::create("seq_item");

                start_item(seq_item);

                assert(seq_item.randomize());

                finish_item(seq_item);
            end
        endtask
    endclass
endpackage