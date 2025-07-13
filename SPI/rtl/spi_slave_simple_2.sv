module spi_slave_simple_2 #(
    parameter int WORD_LEN  = 12,
    parameter bit MSB_FIRST = 1
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  sclk,
    input  logic                  mosi,
    input  logic                  cs_n,
    input  logic                  cpol_in,
    input  logic                  cpha_in,
    output logic                  miso,
    output logic [WORD_LEN-1:0]   received
);

    logic [WORD_LEN-1:0] shift_rx;
    logic [WORD_LEN-1:0] shift_tx;
    logic [$clog2(WORD_LEN+1)-1:0] bit_cnt;
    logic [WORD_LEN-1:0] received_reg;

    logic sclk_d;
    logic sample_edge, shift_edge;

    assign received = received_reg;

    // Register SCLK to detect edges
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sclk_d <= 1'b0;
        else
            sclk_d <= sclk;
    end

    wire sclk_rising  = (sclk == 1'b1 && sclk_d == 1'b0);
    wire sclk_falling = (sclk == 1'b0 && sclk_d == 1'b1);

    always_comb begin
        logic first_edge, second_edge;
        first_edge  = (cpol_in == 1'b0) ? sclk_rising  : sclk_falling;
        second_edge = (cpol_in == 1'b0) ? sclk_falling : sclk_rising;

        sample_edge = (cpha_in == 1'b0) ? first_edge  : second_edge;
        shift_edge  = (cpha_in == 1'b0) ? second_edge : first_edge;
    end

    // >>> FIXED <<<: nova variável para controlar incremento
    logic [$clog2(WORD_LEN+1)-1:0] next_cnt;

    // Recepção
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_rx     <= '0;
            bit_cnt      <= '0;
            received_reg <= '0;
        end else if (!cs_n) begin
            if (sample_edge) begin
                // Shift-in
                if (MSB_FIRST)
                    shift_rx <= {shift_rx[WORD_LEN-2:0], mosi};
                else
                    shift_rx <= {mosi, shift_rx[WORD_LEN-1:1]};

                next_cnt = bit_cnt + 1;                     // >>> FIXED <<<

                if (bit_cnt == WORD_LEN - 1) begin          // >>> FIXED <<<
                    if (MSB_FIRST)
                        received_reg <= {shift_rx[WORD_LEN-2:0], mosi};
                    else
                        received_reg <= {mosi, shift_rx[WORD_LEN-1:1]};
                    bit_cnt <= '0;                          // >>> FIXED <<<
                end else begin
                    bit_cnt <= next_cnt;                   // >>> FIXED <<<
                end
            end
        end else begin
            bit_cnt <= '0;
        end
    end

    // Transmissão
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            miso     <= 1'b0;
            shift_tx <= '0;
        end else if (!cs_n) begin
            if (bit_cnt == 0 && sample_edge) begin
                shift_tx <= received_reg;
            end

            if (shift_edge && bit_cnt < WORD_LEN) begin
                if (MSB_FIRST)
                    miso <= shift_tx[WORD_LEN-1 - bit_cnt];
                else
                    miso <= shift_tx[bit_cnt];
            end
        end else begin
            miso <= 1'bz;
        end
    end

endmodule
