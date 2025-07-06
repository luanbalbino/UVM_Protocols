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
        int unsigned word_len = 12; //example, i'll remove this later to make more flexible
        int unsigned max_val = (1 << word_len) - 1;
    
        for (int i = 0; i < 10; i++) begin
            tr = spi_transaction::type_id::create("tr");
            tr.data = $urandom_range(0, max_val);
    
            `uvm_info(get_type_name(),
                $sformatf("Sending data %0d = 0x%0h (%0d bits)", i, tr.data, word_len),
                UVM_MEDIUM)
    
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass