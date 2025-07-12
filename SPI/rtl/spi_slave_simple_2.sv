module spi_slave_simple_2 #(
    parameter int WORD_LEN = 8
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   sclk,
    input  logic                   mosi,
    input  logic                   cs_n,
    output logic                   miso,
    output logic [WORD_LEN-1:0]   received
);

    logic [WORD_LEN-1:0] shift_rx;
    logic [WORD_LEN-1:0] shift_tx;
    logic [$clog2(WORD_LEN):0] bit_cnt;
    logic [WORD_LEN-1:0] received_reg;

    logic sclk_d;
    wire sclk_rising  =  (sclk == 1'b1 && sclk_d == 1'b0);
    wire sclk_falling =  (sclk == 1'b0 && sclk_d == 1'b1);

    // Assume CPOL = 0, CPHA = 0 as default SPI mode; 
    // adjust sample/shift edges here if needed for other modes
    wire first_edge  = sclk_rising;
    wire second_edge = sclk_falling;

    // For CPHA=0: sample on first_edge, shift on second_edge
    wire sample_edge = first_edge;
    wire shift_edge  = second_edge;

    assign received = received_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sclk_d <= 0;
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
        end else if (cs_n) begin
            bit_cnt <= '0; // reset bit counter on CS inactive
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            miso <= 1'b0;
            shift_tx <= '0;
        end else if (!cs_n) begin
            // Load shift_tx once at start of transaction
            if (bit_cnt == 0 && sample_edge) begin
                shift_tx <= received_reg; // or set by testbench via other means
            end

            if (shift_edge && bit_cnt < WORD_LEN) begin
                miso <= shift_tx[WORD_LEN - 1 - bit_cnt];
            end
        end else begin
            miso <= 1'bz;
        end
    end

endmodule
