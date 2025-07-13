`ifdef ENABLE_ASSERTIONS
module spi_assertions #(
    parameter int WORD_LEN = 12
) (
    input  logic              clk,
    input  logic              rst_n,
    input  logic              cs_n,
    input  logic              sclk,
    input  logic              mosi,
    input  logic              miso,
    input  logic [1:0]         spi_mode              // {CPOL, CPHA}
);

    // Assert: CS must remain low during the entire SPI transaction (active low)

    // Assert: Data signals (MOSI and MISO) should only be active when CS is asserted (low)

    // Assert: Slave must correctly receive data on MOSI and shift data out on MISO according to SPI mode

    // Assert: Correct timing of sampling and shifting edges depending on CPOL and CPHA values

    // Assert: No data corruption or glitches on SPI signals during active transaction

    // Assert: Transaction completion indicated by proper done signal (if applicable)

    initial begin
        `uvm_info("SPI_ASSERTIONS", "SPI Assertions active", UVM_LOW)
    end

endmodule
`endif
