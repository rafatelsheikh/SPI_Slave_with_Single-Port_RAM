package shared_pkg;
    int period;
    int count;
    bit have_address;
    logic [10:0] curr_op;

    bit was_write_address, was_write_data, was_read_address, was_read_data;
endpackage