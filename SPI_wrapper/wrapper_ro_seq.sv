package wrapper_ro_seq_pkg;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_ro_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_ro_seq)

        wrapper_seq_item seq_item;

        function new(string name = "wrapper_ro_seq");
            super.new(name);
        endfunction

        task body;
            repeat(1000) begin
                seq_item = wrapper_seq_item::type_id::create("seq_item");

                start_item(seq_item);

                assert(seq_item.randomize() with {
                    MOSI_arr[9] == 1'b1;
                });
                
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage