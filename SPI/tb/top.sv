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
    
    logic [7:0] slave_data_out;

    spi_if spi_if_inst(.clk(clk), .rst_n(rst_n));

    spi_master_simple master (
        .clk(clk),
        .rst_n(spi_if_inst.rst_n),    
        .start(spi_if_inst.start),    
        .data_in(spi_if_inst.data_in),
        .miso(1'b0),                   // MISO connected to zero, there is no slave module yet, I'll do this in the future
        .mosi(spi_if_inst.mosi),
        .sclk(spi_if_inst.sclk),
        .done(spi_if_inst.done),
        .data_out(spi_if_inst.data_out)
    );

    // // SPI Slave Simple
    // spi_slave_simple slave (
    //     .sclk(sclk),
    //     .mosi(mosi),
    //     .cs_n(1'b0), // Ignorado aqui
    //     .miso(miso),
    //     .received(slave_data_out)
    // );

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

        run_test("spi_test");
    end
endmodule
