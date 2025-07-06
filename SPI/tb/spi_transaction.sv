class spi_transaction extends uvm_sequence_item;
    rand bit [7:0] data;          // Data to be send
    bit [7:0] expected_data_out;  // Expected value from MISO (for checking)

    `uvm_object_utils(spi_transaction)

    function new(string name = "spi_transaction");
        super.new(name);
    endfunction
endclass