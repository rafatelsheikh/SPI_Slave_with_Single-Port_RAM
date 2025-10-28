package RAM_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
class RAM_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(RAM_sequence_item)
    rand bit rst_n;
    rand bit rx_valid;
    rand bit [9:0] din;
    bit [7:0] dout;
    bit tx_valid;
    bit [7:0] dout_ref;
    bit tx_valid_ref;
    constraint rst_c {
        rst_n dist {1 := 98, 0 := 2};
    }
    constraint rx_valid_c {
        rx_valid dist {1 := 95, 0 := 5};
    }
  
    constraint write_only_c {
        if (rx_valid && (din[9:8] == 2'b10)) 
            din[9:8] inside {2'b10, 2'b11}; 
    }
    constraint read_only_c {
        if (rx_valid && (din[9:8] == 2'b00)) 
            din[9:8] == 2'b01; 
        if (rx_valid && (din[9:8] == 2'b01)) 
            din[9:8] == 2'b00; 
    }
    constraint rw_c {
        if (rx_valid && (din[9:8] == 2'b10))
            din[9:8] inside {2'b10, 2'b11}; 
        if (rx_valid && (din[9:8] == 2'b11))
            din[9:8] dist {2'b00 := 60, 2'b10 := 40};
        if (rx_valid && (din[9:8] == 2'b00))
            din[9:8] == 2'b01; 
        if (rx_valid && (din[9:8] == 2'b01))
            din[9:8] dist {2'b10 := 60, 2'b00 := 40};
    }
    function new(string name = "RAM_sequence_item");
        super.new(name);
    endfunction
    function string convert2string();
        return $sformatf("rst_n=%0b, rx_valid=%0b, din=%0h, dout=%0h, tx_valid=%0b | REF: dout_ref=%0h, tx_valid_ref=%0b", 
                       rst_n, rx_valid, din, dout, tx_valid, dout_ref, tx_valid_ref);
    endfunction
    function string convert2string_stimulus();
        return $sformatf("rst_n=%0b, rx_valid=%0b, din=%0h", rst_n, rx_valid, din);
    endfunction
endclass
endpackage