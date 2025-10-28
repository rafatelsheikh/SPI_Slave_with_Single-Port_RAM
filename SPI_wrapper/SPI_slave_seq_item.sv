package SPI_slave_seq_item_pkg;
    import shared_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_seq_item extends uvm_sequence_item;
        `uvm_object_utils(SPI_slave_seq_item)

        rand logic rst_n;
        rand logic SS_n;
        logic MOSI;
        rand logic tx_valid;
        rand logic [7:0] tx_data;
        logic MISO;
        logic rx_valid;
        logic [9:0] rx_data;
        logic MISO_golden;
        logic rx_valid_golden;
        logic [9:0] rx_data_golden;
        rand logic [10:0] MOSI_arr;

        function new(string name = "SPI_slave_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s rst_n: %b, SS_n: %b, MOSI: %b, tx_valid: %b, tx_data: %h, 
                                MISO: %b, rx_valid: %b, rx_data: %h,
                                MISO_golden: %b, rx_valid_golden: %b, rx_data_golden: %h",
                                super.convert2string(), rst_n, SS_n, MOSI, tx_valid, tx_data,
                                MISO, rx_valid, rx_data, MISO_golden, rx_valid_golden, rx_data_golden);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst_n: %b, SS_n: %b, MOSI: %b, tx_valid: %b, tx_data: %h",
                                rst_n, SS_n, MOSI, tx_valid, tx_data);
        endfunction

        constraint SPI_SLAVE_1 {
            rst_n dist {1 :/ 95, 0 :/ 5};
        }

        constraint SPI_SLAVE_6 {
            if (SS_n == 0) {
                MOSI_arr[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};

                if (!have_address) {
                    MOSI_arr[10:8] != 3'b111;
                }
            }
        }

        constraint SPI_SLAVE_8 {
            if (count > 14) {
                tx_valid == 1;
            } else {
                tx_valid == 0;
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