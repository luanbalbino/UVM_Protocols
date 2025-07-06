// -----------------------------------------------------------------------------
// SPI Master RTL with MISO reception support
// Mode: CPOL = 0, CPHA = 0 | MSB First
// -----------------------------------------------------------------------------
module spi_master_simple#(
    parameter SPI_CLK_DIV  = 5,
    parameter int WORD_LEN = 8
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic [WORD_LEN-1:0] data_in,
    input  logic        miso,
    output logic        mosi,
    output logic        sclk,
    output logic        done,
    output logic [WORD_LEN-1:0] data_out,
    output logic        cs_n
);
    typedef enum logic [1:0] {IDLE, TRANSFER} state_t;
    state_t state; // We will use 'state' directly for FSM logic

    
    logic sclk_reg;
    logic mosi_reg; 
    logic done_reg; 
    logic [WORD_LEN-1:0] data_out_reg; // data_out must be a register
    
    logic [$clog2(WORD_LEN):0] bit_cnt;
    logic [WORD_LEN-1:0] shift_reg_tx;   // Transmission shift register (up to 16 bits)
    logic [WORD_LEN-1:0] shift_reg_rx;   // Reception shift register

    logic cs_n_reg;

    // Clock divider logic for sclk generation
    logic [($clog2(SPI_CLK_DIV)):0] clk_div_cnt;
    logic spi_clk_enable; // Signal that indicates when sclk should toggle

    // Outputs
    assign sclk = sclk_reg;
    assign mosi = mosi_reg;
    assign done = done_reg; // The 'done' output is the 'done_reg' register
    assign data_out = data_out_reg;
    assign cs_n = cs_n_reg;

    // Clock Divider Logic
    // This block is separate and controls the divider counter and the SPI clock enable
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_cnt <= '0;
            spi_clk_enable <= 1'b0;
        end else begin
            if (state == TRANSFER) begin // Only enable SPI clock during transfer
                if (clk_div_cnt == (SPI_CLK_DIV - 1)) begin
                    clk_div_cnt <= '0;
                    spi_clk_enable <= 1'b1; // Enable SCLK toggling
                end else begin
                    clk_div_cnt <= clk_div_cnt + 1;
                    spi_clk_enable <= 1'b0;
                end
            end else begin // In IDLE, reset the divider counter
                clk_div_cnt <= '0;
                spi_clk_enable <= 1'b0;
            end
        end
    end

    // FSM and Main Synchronous Logic
    // All assignments to registers (state, shift_reg_tx, shift_reg_rx, bit_cnt,
    // sclk_reg, mosi_reg, done_reg, data_out_reg) must be in this block.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: initialize all registers
            state        <= IDLE;
            shift_reg_tx <= 8'h00;
            shift_reg_rx <= 8'h00;
            bit_cnt      <= 3'd0;
            sclk_reg     <= 1'b0;
            mosi_reg     <= 1'b0;
            done_reg     <= 1'b0; // Reset done output
            data_out_reg <= 8'h00;
            cs_n_reg     <= 1'b1;
        end else begin

            // Maintain current value
            sclk_reg     <= sclk_reg;     
            mosi_reg     <= mosi_reg;    
            data_out_reg <= data_out_reg;
            cs_n_reg     <= cs_n_reg;

            // State Machine Logic
            case (state)
                IDLE: begin
                    cs_n_reg <= 1'b1;
                    // When in IDLE, if 'start' is asserted, transition to TRANSFER
                    if (start) begin
                        state        <= TRANSFER;
                        shift_reg_tx <= data_in; // Load data to be transmitted
                        shift_reg_rx <= 8'h00;   // Reset reception register
                        bit_cnt      <= 3'd0;    // Reset bit counter
                        sclk_reg     <= 1'b0;    // Ensure SCLK is low at the start of transfer (CPOL=0)
                        mosi_reg     <= 1'b0;    // Ensure MOSI is low at the start (or the first bit will be set)
                        done_reg     <= 1'b0;    // Ensure done is low when starting a new transaction
                        cs_n_reg     <= 1'b0;
                    end
                    // If no 'start' and in IDLE, ensure done_reg is 0
                    else begin
                        done_reg <= 1'b0;
                    end
                end

                TRANSFER: begin
                    cs_n_reg <= 1'b0;

                    // Logic for CPOL=0, CPHA=0
                    // SCLK starts low
                    // Data is valid on SCLK rising edge and changes on falling edge

                    if (spi_clk_enable) begin // Every SCLK cycle (determined by the divider)
                        sclk_reg <= ~sclk_reg; // Toggle SCLK

                        if (sclk_reg == 1'b1) begin // SCLK rising edge (sample MISO, shift TX)
                            // Capture bit from miso line
                            shift_reg_rx <= {shift_reg_rx[WORD_LEN-2:0], miso};

                            // If it's the last bit (WORD_LEN - 1)
                            if (bit_cnt == (WORD_LEN - 1)) begin
                                data_out_reg <= shift_reg_rx;
                                done_reg <= 1'b1; // Assert 'done'
                                state <= IDLE;    // Transition back to IDLE
                                cs_n_reg <= 1'b1;                            end
                            bit_cnt <= bit_cnt + 1; // Increment bit counter

                        end else begin // SCLK falling edge (change MOSI, shift TX)
                            // Send MSB on mosi
                            mosi_reg <= shift_reg_tx[WORD_LEN-1];
                            // Shift transmission data for the next bit
                            shift_reg_tx <= {shift_reg_tx[WORD_LEN-2:0], 1'b0};
                        end
                    end
                end
            endcase
        end
    end

endmodule
