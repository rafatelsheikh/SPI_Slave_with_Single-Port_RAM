module RAM_golden (clk, rst_n, din, rx_valid, dout, tx_valid);
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    input clk, rst_n, rx_valid;
    input [ADDR_SIZE + 1 : 0] din;
    output reg tx_valid;
    output reg [ADDR_SIZE - 1 : 0] dout;
    reg [ADDR_SIZE - 1 : 0] wr_address;
    reg [ADDR_SIZE - 1 : 0] rd_address;
    reg [ADDR_SIZE - 1 : 0] mem [MEM_DEPTH - 1 : 0];
    
    always @(posedge clk) begin
        if (~rst_n) begin
            tx_valid <= 0;
            dout <= 0;
            wr_address <= 0;
            rd_address <= 0;
        end else if (rx_valid) begin
            case (din[ADDR_SIZE + 1 : ADDR_SIZE])
                2'b00: begin
                    tx_valid <= 0;
                    wr_address <= din[ADDR_SIZE - 1 : 0];
                end
                2'b01: begin
                    tx_valid <= 0;
                    mem[wr_address] <= din[ADDR_SIZE - 1 : 0];
                end
                2'b10: begin
                    tx_valid <= 0;
                    rd_address <= din[ADDR_SIZE - 1 : 0];
                end
                2'b11: begin
                    tx_valid <= 1;
                    dout <= mem[rd_address];
                end
                default: begin
                    tx_valid <= 0;
                    dout <= 0;
                end
            endcase
        end
    end
endmodule