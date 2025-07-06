module spi_slave_simple #(
    parameter int WORD_LEN = 8,
    parameter bit CPOL = 0,
    parameter bit CPHA = 0 
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   sclk,
    input  logic                   mosi,
    input  logic                   cs_n,
    output logic                   miso,
    output logic [WORD_LEN-1:0]    received
);

    logic [WORD_LEN-1:0] shift_rx;
    logic [WORD_LEN-1:0] shift_tx;
    logic [$clog2(WORD_LEN):0] bit_cnt;
    logic [WORD_LEN-1:0] received_reg;

    logic sclk_d;
    wire sclk_rising  =  (sclk == 1'b1 && sclk_d == 1'b0);
    wire sclk_falling =  (sclk == 1'b0 && sclk_d == 1'b1);

    // Determine the "first" and "second" edge based on CPOL
    wire first_edge;
    wire second_edge;

    generate
        if (CPOL == 0) begin // SCLK idle low
            assign first_edge  = sclk_rising;
            assign second_edge = sclk_falling;
        end else begin // CPOL == 1, SCLK idle high
            assign first_edge  = sclk_falling;
            assign second_edge = sclk_rising;
        end
    endgenerate

    // determine sample and shift edge based on CPHA
    wire sample_edge = (CPHA == 0) ? first_edge : second_edge;
    wire shift_edge  = (CPHA == 0) ? second_edge : first_edge;

    assign received = received_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sclk_d <= CPOL;
        else
            sclk_d <= sclk;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_rx     <= '0;
            bit_cnt      <= '0;
            received_reg <= '0;
        end else if (!cs_n && sample_edge) begin
            shift_rx <= {shift_rx[WORD_LEN-2:0], mosi};
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == WORD_LEN - 1) begin
                received_reg <= {shift_rx[WORD_LEN-2:0], mosi};
                bit_cnt <= '0;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            miso <= 1'b0;
        end else if (!cs_n && shift_edge && bit_cnt < WORD_LEN) begin
            miso <= shift_tx[WORD_LEN - 1 - bit_cnt];
        end else if (cs_n) begin
            miso <= 1'bz;
        end
    end

    initial shift_tx = 16'h3C0F;

endmodule
