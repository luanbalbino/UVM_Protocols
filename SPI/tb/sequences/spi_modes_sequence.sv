// -----------------------------------------------------------------------------
// Sequence to test all SPI modes (CPOL/CPHA)
// -----------------------------------------------------------------------------
class spi_modes_sequence extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_modes_sequence)

    function new(string name = "spi_modes_sequence");
        super.new(name);
    endfunction

    task body();
        bit [7:0] test_data[] = {8'hA5, 8'h3C, 8'hF0, 8'h55};
        for (int i = 0; i < 4; i++) begin
            spi_transaction tr = spi_transaction::type_id::create("tr");
            tr.data = test_data[i];
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass
