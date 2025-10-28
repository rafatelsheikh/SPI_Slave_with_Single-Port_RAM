package SPI_slave_monitor_pkg;
    import SPI_slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_monitor extends uvm_monitor;
        `uvm_component_utils(SPI_slave_monitor);

        virtual SPI_slave_if SPI_slave_vif;
        SPI_slave_seq_item seq_item;
        uvm_analysis_port #(SPI_slave_seq_item) monitor_ap;

        function new(string name = "SPI_slave_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            monitor_ap = new("monitor_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                seq_item = SPI_slave_seq_item::type_id::create("seq_item");

                @(negedge SPI_slave_vif.clk);

                seq_item.rst_n = SPI_slave_vif.rst_n;
                seq_item.SS_n = SPI_slave_vif.SS_n;
                seq_item.MOSI = SPI_slave_vif.MOSI;
                seq_item.tx_valid = SPI_slave_vif.tx_valid;
                seq_item.tx_data = SPI_slave_vif.tx_data;
                seq_item.MISO = SPI_slave_vif.MISO;
                seq_item.rx_valid = SPI_slave_vif.rx_valid;
                seq_item.rx_data = SPI_slave_vif.rx_data;
                seq_item.MISO_golden = SPI_slave_vif.MISO_golden;
                seq_item.rx_valid_golden = SPI_slave_vif.rx_valid_golden;
                seq_item.rx_data_golden = SPI_slave_vif.rx_data_golden;

                monitor_ap.write(seq_item);

                `uvm_info("run_phase", seq_item.convert2string(), UVM_HIGH)
            end
        endtask
    endclass
endpackage