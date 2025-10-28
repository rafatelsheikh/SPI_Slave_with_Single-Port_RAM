package wrapper_full_seq_pkg;
    import shared_pkg::*;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_full_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_full_seq)

        wrapper_seq_item seq_item;

        function new(string name = "wrapper_full_seq");
            super.new(name);
        endfunction

        task body;
            repeat(1000) begin
                seq_item = wrapper_seq_item::type_id::create("seq_item");
                
                seq_item.constraint_mode(0);

                seq_item.random_arr_c.constraint_mode(1);

                start_item(seq_item);

                assert(seq_item.randomize() with {
                    if (was_write_address) {
                        MOSI_arr[9:8] == 2'b01;
                    } if (was_write_data) {
                        MOSI_arr[9:8] == 2'b10;
                    } if (was_read_address) {
                        MOSI_arr[9:8] == 2'b11;
                    } if (was_read_data) {
                        MOSI_arr[9:8] == 2'b00;
                    }

                    rst_n == 1;
                });

                finish_item(seq_item);
            end
        endtask
    endclass
endpackage