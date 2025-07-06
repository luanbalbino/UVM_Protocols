module spi_assertions (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic        sclk,
    input  logic        mosi,
    input  logic        miso,
    input  logic [7:0]  data_in,
    input  logic [7:0]  expected_data_out,
    input  logic        cs_n,       // Slave select, active low
    input  logic        done,
    input  logic [7:0]  data_out    // Received data from MISO
);

    // TODO: 
    initial begin
        `uvm_info("SPI_ASSERTIONS", "Module instantiated and active.", UVM_LOW);
    end

endmodule
