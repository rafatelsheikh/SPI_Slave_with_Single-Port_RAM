module RAM_assertions(
    input clk,
    input rst_n,
    input rx_valid,
    input [9:0] din,
    input [7:0] dout,
    input tx_valid
);
    property p_reset_outputs;
        @(posedge clk) (!rst_n) |=> (tx_valid == 0 && dout == 0);
    endproperty
    assert_reset_outputs: assert property(p_reset_outputs)
        else $error("Assertion Failed: Outputs not low during reset");
    property p_tx_valid_during_input;
        @(posedge clk) (rst_n && rx_valid && (din[9:8] != 2'b11)) |=> (tx_valid == 0);
    endproperty
    assert_tx_valid_input: assert property(p_tx_valid_during_input)
        else $error("Assertion Failed: tx_valid asserted during address/data input");

    property p_tx_valid_read_data;
        @(posedge clk) (rst_n && rx_valid && din[9:8] == 2'b11) |=> (tx_valid == 1);
    endproperty
    assert_tx_valid_read: assert property(p_tx_valid_read_data)
        else $error("Assertion Failed: tx_valid behavior incorrect after read_data");

    sequence s_write_address;
        (rx_valid && din[9:8] == 2'b00);
    endsequence

    sequence s_write_data;
        (rx_valid && din[9:8] == 2'b01);
    endsequence
    property p_write_address_to_data;
        @(posedge clk) disable iff(!rst_n)
        s_write_address |-> ##[1:$] s_write_data;
    endproperty
    assert_write_sequence: assert property(p_write_address_to_data)
        else $error("Assertion Failed: Write Address not followed by Write Data");

    sequence s_read_address;
        (rx_valid && din[9:8] == 2'b10);
    endsequence

    sequence s_read_data;
        (rx_valid && din[9:8] == 2'b11);
    endsequence

 
    property p_read_address_to_data;
        @(posedge clk) disable iff(!rst_n)
        s_read_address |-> ##[1:$] s_read_data;
    endproperty
    assert_read_sequence: assert property(p_read_address_to_data)
        else $error("Assertion Failed: Read Address not followed by Read Data");
endmodule