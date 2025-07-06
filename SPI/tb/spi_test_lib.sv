// -----------------------------------------------------------------------------
// SPI Test Library — UVM Sequences
// -----------------------------------------------------------------------------

`ifndef SPI_TEST_LIB_SV
`define SPI_TEST_LIB_SV

class basic_transfer_seq extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(basic_transfer_seq)

    function new(string name = "basic_transfer_seq");
        super.new(name);
    endfunction

    task body();
        spi_transaction tr = spi_transaction::type_id::create("tr");
        tr.data = 8'hA5;
        start_item(tr);
        finish_item(tr);
    endtask
endclass

// -----------------------------------------------------------------------------

class all_zeros_seq extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(all_zeros_seq)

    function new(string name = "all_zeros_seq");
        super.new(name);
    endfunction

    task body();
        spi_transaction tr = spi_transaction::type_id::create("tr");
        tr.data = 8'h00;
        start_item(tr);
        finish_item(tr);
    endtask
endclass

// -----------------------------------------------------------------------------

class all_ones_seq extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(all_ones_seq)

    function new(string name = "all_ones_seq");
        super.new(name);
    endfunction

    task body();
        spi_transaction tr = spi_transaction::type_id::create("tr");
        tr.data = 8'hFF;
        start_item(tr);
        finish_item(tr);
    endtask
endclass

// -----------------------------------------------------------------------------

class alternating_seq extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(alternating_seq)

    function new(string name = "alternating_seq");
        super.new(name);
    endfunction

    task body();
        for(int i=0; i<3; i++) begin
            spi_transaction tr = spi_transaction::type_id::create($sformatf("tr_%0d", i));
            tr.data = (i == 0) ? 8'hAA : 8'h55;
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass

// -----------------------------------------------------------------------------

class random_data_seq extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(random_data_seq)

    function new(string name = "random_data_seq");
        super.new(name);
    endfunction

    task body();
        repeat (5) begin
            spi_transaction tr = spi_transaction::type_id::create("tr");
            assert(tr.randomize());
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass

// -----------------------------------------------------------------------------
`endif // SPI_TEST_LIB_SV
