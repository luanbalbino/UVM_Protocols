class spi_read_sequence extends uvm_sequence#(spi_transaction);
    `uvm_object_utils(spi_read_sequence)

    // Construtor
    function new(string name = "spi_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        spi_transaction tr; 
       
        for (int i = 0; i < 50; i++) begin
            tr = spi_transaction::type_id::create("tr");
            tr.data = i;
            
            start_item(tr); 
            finish_item(tr);
        end

        `uvm_info(get_full_name(), $sformatf("Sent SPI Read Transaction: %s", tr.sprint()), UVM_LOW)
    endtask

endclass