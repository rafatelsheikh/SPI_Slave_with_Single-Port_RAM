package wrapper_seq_item_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_seq_item extends uvm_sequence_item;
        `uvm_object_utils(wrapper_seq_item)

        rand logic rst_n;
        rand logic SS_n;
        logic MOSI;
        logic MISO;
        logic MISO_golden;
        rand logic [10:0] MOSI_arr;                    

        function new(string name = "wrapper_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s rst_n: %b, SS_n: %b, MOSI: %b, MISO: %b, MISO_golden: %b",
                             super.convert2string(), rst_n, SS_n, MOSI, MISO, MISO_golden);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst_n: %b, SS_n: %b, MOSI: %b, MISO: %b, MISO_golden: %b",
                             rst_n, SS_n, MOSI, MISO, MISO_golden);
        endfunction

        constraint reset_c {
            rst_n dist {1 :/ 95, 0 :/ 5};
        }

        constraint random_arr_c {
            MOSI_arr[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
            if (!have_address) {
                MOSI_arr[10:8] != 3'b111;
            }
        }

        constraint c_next_operation { 
            if (was_write_address) {
                soft MOSI_arr[9] == 1'b0;
            } else if (was_read_address) {
                soft MOSI_arr[9:8] == 2'b11;
            }
        }

        constraint c_after_read_data { 
            if (was_read_data) {
                soft MOSI_arr[9:8] == 2'b10;
            }
        }

        constraint c_after_read_address { 
            if (!was_read_address) {
                MOSI_arr[9:8] != 2'b11;
            }
        }

        constraint c_after_write_and_read_data { 
            if (was_write_data) {
                soft MOSI_arr[9:8] dist {2'b10 :/ 60, 2'b00 :/ 40};
            } else if (was_read_data) {
                soft MOSI_arr[9:8] dist {2'b00 :/ 60, 2'b10 :/ 40};
            }
        }

        function void post_randomize();
            if (count == 0) begin
                curr_op = MOSI_arr;
            end

            if (curr_op[10:8] == 3'b111) begin
                period = 23;
            end else begin
                period = 13;
            end

            if (count == period) begin
                SS_n = 1;
            end else begin
                SS_n = 0;
            end


            if (curr_op[10:8] == 3'b110) begin
                have_address = 1;
            end

            if (curr_op[10:8] == 3'b111 || !rst_n) begin
                have_address = 0;
            end

            if (count > 0 && count < 12) begin
                MOSI = curr_op[11 - count];
            end else begin
                MOSI = 0;
            end

            if (curr_op[9:8] == 2'b00) begin
                was_write_address = 1;
            end else begin
                was_write_address = 0;
            end

            if (curr_op[9:8] == 2'b01) begin
                was_write_data = 1;
            end else begin
                was_write_data = 0;
            end

            if (curr_op[9:8] == 2'b10) begin
                was_read_address = 1;
            end else begin
                was_read_address = 0;
            end

            if (curr_op[9:8] == 2'b11) begin
                was_read_data = 1;
            end else begin
                was_read_data = 0;
            end

            if (!rst_n) begin
                count = 0;
            end else begin
                if (count == period) begin
                    count = 0;
                end else begin
                    count++;
                end
            end
        endfunction
    endclass
endpackage

