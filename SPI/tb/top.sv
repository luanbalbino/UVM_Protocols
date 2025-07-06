// -----------------------------------------------------------------------------
// Testbench Top
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

module top;
    
    logic start;
    logic clk;
    logic rst_n;
    logic miso, mosi, sclk;

    parameter int WORD_LEN = 8;
    
/* -------------------------------------------------------------------------
 * SPI MODES REFERENCE TABLE
 * -------------------------------------------------------------------------
 * CPOL: Clock Polarity
 * 0 = SCLK is low when idle
 * 1 = SCLK is high when idle
 *
 * CPHA: Clock Phase
 * 0 = Data is sampled on the first clock edge, shifted on the second.
 * 1 = Data is sampled on the second clock edge, shifted on the first.
 *
 * -------------------------------------------------------------------------
 * | SPI Mode | CPOL | CPHA | Data is shifted out on | Data is sampled on  |
 * |----------|------|------|------------------------|---------------------|
 * |    0     |  0   |  0   | falling SCLK           | rising SCLK         |
 * |    1     |  0   |  1   | rising SCLK            | falling SCLK        |
 * |    2     |  1   |  0   | rising SCLK            | falling SCLK        |
 * |    3     |  1   |  1   | falling SCLK           | rising SCLK         |
 * -------------------------------------------------------------------------
 * source: https://en.wikipedia.org/wiki/Serial_Peripheral_Interface 
 */   
    // only [0,0] and [1,0] working.. I need to debug yet
    parameter bit CPOL = 0;
    parameter bit CPHA = 0;
    
    logic [WORD_LEN-1:0] slave_data_out;

    spi_if spi_if_inst(.clk(clk), .rst_n(rst_n));

    assign spi_if_inst.received_slave = slave_data_out;

    spi_master_simple #(
        .SPI_CLK_DIV('d2),
        .WORD_LEN(WORD_LEN),
        .CPOL(CPOL),
        .CPHA(CPHA) 
    ) master (
        .clk(clk),
        .rst_n(spi_if_inst.rst_n),    
        .start(spi_if_inst.start),    
        .data_in(spi_if_inst.data_in),
        .miso(spi_if_inst.miso),           
        .mosi(spi_if_inst.mosi),
        .sclk(spi_if_inst.sclk),
        .done(spi_if_inst.done),
        .data_out(spi_if_inst.data_out),
        .cs_n(spi_if_inst.cs_n)
    );

    spi_slave_simple #(
        .WORD_LEN(WORD_LEN),
        .CPOL(CPOL),
        .CPHA(CPHA) 
    ) slave (
        .clk     (clk),
        .rst_n   (rst_n),
        .sclk    (spi_if_inst.sclk),
        .mosi    (spi_if_inst.mosi),
        .cs_n    (spi_if_inst.cs_n), 
        .miso    (spi_if_inst.miso),
        .received(slave_data_out)
    );

    `ifdef ENABLE_ASSERTIONS
        spi_assertions uu_spi_assertions (
            .clk(clk),
            .rst_n(spi_if_inst.rst_n),
            .start(spi_if_inst.start),
            .sclk(spi_if_inst.sclk),
            .mosi(spi_if_inst.mosi),
            .miso(spi_if_inst.miso),
            .cs_n(cs_n),
            .done(done),
            .data_in(data_in),
            .data_out(data_out),
            .expected_data_out(expected_value)
        );
    `endif

    // Reset generation
    initial begin
        rst_n = 1'b0;
        #100;        
        rst_n = 1'b1;
    end
   
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin

        uvm_config_db#(virtual spi_if)::set(null, "*", "spi_vif", spi_if_inst);

        run_test();
    end
endmodule
