// -----------------------------------------------------------------------------
// Sequence UVM
// -----------------------------------------------------------------------------
class spi_sequence extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_sequence)

    function new(string name = "spi_sequence");
        super.new(name);
    endfunction

    virtual task body();
        spi_transaction tr;

        // Exemplo simples: enviar 3 bytes diferentes sequencialmente
        for (int i = 0; i < 5; i++) begin // Loop for para iterar 3 vezes
            tr = spi_transaction::type_id::create("tr");
            tr.data = $urandom_range(0, 255); // Random data
            `uvm_info(get_type_name(), $sformatf("Sending data %0d = 0x%0h", i, tr.data), UVM_MEDIUM)
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass
