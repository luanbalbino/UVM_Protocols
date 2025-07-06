module spi_slave_simple#(
    parameter int WORD_LEN = 8
) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       sclk,
    input  logic       mosi,
    input  logic       cs_n,
    output logic       miso,
    output logic [WORD_LEN-1:0] received
);

    logic [WORD_LEN-1:0] shift_rx;
    logic [WORD_LEN-1:0] shift_tx;
    logic [$clog2(WORD_LEN):0] bit_cnt;
    logic [WORD_LEN-1:0] received_reg;

    assign received = received_reg;

    always_ff @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            shift_rx     <= 16'h0000;
            bit_cnt      <= '0;
            received_reg <= '0;
        end
        else if (!cs_n) begin
            shift_rx <= {shift_rx[WORD_LEN-2:0], mosi};
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == WORD_LEN - 1) begin
                received_reg <= {shift_rx[WORD_LEN-2:0], mosi};
                bit_cnt <= '0;
            end
        end
    end

    always_comb begin
        if (bit_cnt < WORD_LEN)
        miso = shift_tx[WORD_LEN - 1 - bit_cnt];
    else
        miso = 1'bz;
    end

    initial shift_tx = 16'h3C0F;

endmodule
