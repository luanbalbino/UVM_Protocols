class spi_loopback_sequence extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_loopback_sequence)

    function new(string name = "spi_loopback_sequence");
        super.new(name);
    endfunction

    task body();
        //TBD
    endtask
endclass
