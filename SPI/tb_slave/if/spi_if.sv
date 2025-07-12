interface spi_if #(
    parameter int WORD_LEN = 12
)( 
    input logic clk, 
    input logic rst_n
);
    
    logic mosi;
    logic miso;
    logic sclk;
    logic cs_n;
    logic cpol;
    logic cpha;
    logic [WORD_LEN-1:0] data;  

    modport master (
        input  clk, rst_n,
        output mosi, sclk, cs_n, cpol, cpha,
        input  miso
    );

    modport slave (
        input  clk, rst_n, mosi, sclk, cs_n, cpol, cpha,
        output miso
    );

endinterface