interface spi_if(input logic clk, input logic rst_n);
    
    logic mosi;
    logic miso;
    logic sclk;
    logic start;            // Start signal for the master
    logic [7:0] data_in;    // Input data for the master
    logic done;             // Done signal from the master
    logic [7:0] data_out;   // Output data from the master (received)
    logic [7:0] received_slave;

    modport master (
        input  clk, rst_n,
        output mosi, sclk, start, data_in,
        input  miso, done, data_out
    );

    modport slave (
        input  clk, rst_n, mosi, sclk,
        output miso
    );

endinterface
