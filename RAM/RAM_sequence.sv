package RAM_sequence_pkg;
    import uvm_pkg::*;
    import RAM_pkg::*;
    `include "uvm_macros.svh"
class reset_sequence extends uvm_sequence #(RAM_sequence_item);
    `uvm_object_utils(reset_sequence)

    RAM_sequence_item seq_item;

    function new(string name = "reset_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = RAM_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n = 0;
        seq_item.rx_valid = 0;
        seq_item.din = 0;
        finish_item(seq_item);
        
        // Release reset
        seq_item = RAM_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n = 1;
        seq_item.rx_valid = 0;
        seq_item.din = 0;
        finish_item(seq_item);
    endtask
endclass

// Write Only Sequence
class write_only_sequence extends uvm_sequence #(RAM_sequence_item);
    `uvm_object_utils(write_only_sequence)

    RAM_sequence_item seq_item;
    bit [1:0] prev_op = 2'b00;

    function new(string name = "write_only_sequence");
        super.new(name);
    endfunction

    task body();
        repeat(30) begin
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            assert(seq_item.randomize());
            
            seq_item.rx_valid = 1;
            case(prev_op)
                2'b00: begin
                    seq_item.din[9:8] = $urandom_range(0,1) ? 2'b00 : 2'b01;
                end
                2'b01: begin
                    seq_item.din[9:8] = $urandom_range(0,1) ? 2'b00 : 2'b01;
                end
                default: begin
                    seq_item.din[9:8] = 2'b00;
                end
            endcase
            
            prev_op = seq_item.din[9:8];
            finish_item(seq_item);
        end
    endtask
endclass

// Read Only Sequence
class read_only_sequence extends uvm_sequence #(RAM_sequence_item);
    `uvm_object_utils(read_only_sequence)

    RAM_sequence_item seq_item;
    bit [1:0] prev_op = 2'b10;

    function new(string name = "read_only_sequence");
        super.new(name);
    endfunction

    task body();
        repeat(1000) begin
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            assert(seq_item.randomize());
            
            seq_item.rx_valid = 1;
            case(prev_op)
                2'b10: begin
                    seq_item.din[9:8] = $urandom_range(0,1) ? 2'b10 : 2'b11;
                end
                2'b11: begin
                    seq_item.din[9:8] = $urandom_range(0,1) ? 2'b10 : 2'b11;
                end
                default: begin
                    seq_item.din[9:8] = 2'b10;
                end
            endcase
            
            prev_op = seq_item.din[9:8];
            finish_item(seq_item);
        end
    endtask
endclass

// Write-Read Sequence
class write_read_sequence extends uvm_sequence #(RAM_sequence_item);
    `uvm_object_utils(write_read_sequence)

    RAM_sequence_item seq_item;
    bit [1:0] prev_op = 2'b00;

    function new(string name = "write_read_sequence");
        super.new(name);
    endfunction

    task body();
        repeat(1000) begin
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            assert(seq_item.randomize());
            
            seq_item.rx_valid = 1;
            case(prev_op)
                2'b00: begin
                    seq_item.din[9:8] = $urandom_range(0,1) ? 2'b00 : 2'b01;
                end
                2'b01: begin
                    seq_item.din[9:8] = ($urandom_range(1,100) <= 60) ? 2'b10 : 2'b00;
                end
                2'b10: begin
                    seq_item.din[9:8] = $urandom_range(0,1) ? 2'b10 : 2'b11;
                end
                2'b11: begin
                    seq_item.din[9:8] = ($urandom_range(1,100) <= 60) ? 2'b00 : 2'b10;
                end
            endcase
            
            prev_op = seq_item.din[9:8];
            finish_item(seq_item);
        end
    endtask
endclass

// Main Sequence
class main_sequence extends uvm_sequence #(RAM_sequence_item);
    `uvm_object_utils(main_sequence)

    RAM_sequence_item seq_item;

    function new(string name = "main_sequence");
        super.new(name);
    endfunction

    task body();
        repeat(1000) begin
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            assert(seq_item.randomize());
            seq_item.rx_valid = 1;
            finish_item(seq_item);
        end
    endtask
endclass
endpackage