module spi_slave_simple (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       sclk,
    input  logic       mosi,
    input  logic       cs_n,
    output logic       miso,
    output logic [7:0] received
);

    logic [7:0] shift_rx;
    logic [7:0] shift_tx;
    logic [2:0] bit_cnt;
    logic [7:0] received_reg;

    assign received = received_reg;

    always_ff @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            shift_rx     <= 8'h00;
            bit_cnt      <= 3'd0;
            received_reg <= 8'h00;
        end
        else if (!cs_n) begin
            shift_rx <= {shift_rx[6:0], mosi};
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 3'd7) begin
                received_reg <= {shift_rx[6:0], mosi};
                bit_cnt <= 3'd0;
            end
        end
    end

    always_comb begin
        miso = shift_tx[7 - bit_cnt];
    end

    initial shift_tx = 8'h3C;

endmodule
