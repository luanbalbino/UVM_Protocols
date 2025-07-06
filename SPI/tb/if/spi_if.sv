interface spi_if #(
    parameter int WORD_LEN = 8,
    parameter bit CPOL = 0,
    parameter bit CPHA = 0 
)( 
    input logic clk, 
    input logic rst_n
);
    
    logic mosi;
    logic miso;
    logic sclk;
    logic start;            // Start signal for the master
    logic done;             // Done signal from the master
    logic cs_n;

    logic [WORD_LEN-1:0] data_in;    // Input data for the master
    logic [WORD_LEN-1:0] data_out;   // Output data from the master (received)
    logic [WORD_LEN-1:0] received_slave;

    modport master (
        input  clk, rst_n,
        output mosi, sclk, start, data_in,
        input  miso, done, data_out, cs_n
    );

    modport slave (
        input  clk, rst_n, mosi, sclk, cs_n,
        output miso
    );

endinterface
