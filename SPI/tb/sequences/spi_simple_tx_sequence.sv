class spi_simple_tx_sequence extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_simple_tx_sequence)

    function new(string name = "spi_simple_tx_sequence");
        super.new(name);
    endfunction

    task body();
        spi_transaction tr = spi_transaction::type_id::create("tr");
        tr.data = 8'hA5;
        start_item(tr);
        finish_item(tr);
    endtask
endclass