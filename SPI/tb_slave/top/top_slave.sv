// -----------------------------------------------------------------------------
// Testbench Top
// -----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

module top_slave;
    
    logic start;
    logic clk;
    logic rst_n;
    logic miso, mosi, sclk;

    parameter int WORD_LEN = 12; // WORD_LEN can remain a parameter if fixed for this top

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
    
    logic cpol_sig;
    logic cpha_sig;
    
    logic [WORD_LEN-1:0] slave_data_out; // Output from the slave (received data)
    logic [WORD_LEN-1:0] slave_data_in;  // Input to the slave (data to send)
    
    spi_if #(.WORD_LEN(WORD_LEN)) spi_if_inst(.clk(clk), .rst_n(rst_n));

    spi_slave_simple_2 #(
        .WORD_LEN(WORD_LEN)
    ) slave (
        .clk        (clk),
        .rst_n      (rst_n),
        .sclk       (spi_if_inst.sclk),
        .mosi       (spi_if_inst.mosi),
        .cs_n       (spi_if_inst.cs_n), 
        .miso       (spi_if_inst.miso),
        .cpol_in    (spi_if_inst.cpol), 
        .cpha_in    (spi_if_inst.cpha),
        .received   (slave_data_out)
    );

    // Reset generation
    initial begin
        rst_n = 1'b0;
        #100;        
        rst_n = 1'b1;
    end

    // Initial values for SPI signals (can be overridden by driver)
    initial begin
        spi_if_inst.cs_n  = 1'b1;
        spi_if_inst.sclk  = cpol_sig; 
        spi_if_inst.mosi  = 1'b0;
        slave_data_in = '0; 
    end
    
    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period (100 MHz)

    initial begin
        // Pass the interface to UVM environment
        uvm_config_db#(virtual spi_if #(.WORD_LEN(WORD_LEN)))::set(null, "*", "spi_vif", spi_if_inst);

        run_test();
    end
endmodule   