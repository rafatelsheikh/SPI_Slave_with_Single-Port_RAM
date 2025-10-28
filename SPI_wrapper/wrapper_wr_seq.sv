package wrapper_wr_seq_pkg;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_wr_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_wr_seq)

        wrapper_seq_item seq_item;

        function new(string name = "wrapper_wr_seq");
            super.new(name);
        endfunction

        task body;
            repeat(10000) begin
                seq_item = wrapper_seq_item::type_id::create("seq_item");

                seq_item.c_after_read_data.constraint_mode(0);
                
                start_item(seq_item);

                assert(seq_item.randomize());

                finish_item(seq_item);
            end
        endtask
    endclass
endpackage