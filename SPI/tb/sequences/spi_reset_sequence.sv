class spi_reset_sequence extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_reset_sequence)

    function new(string name = "spi_reset_sequence");
        super.new(name);
    endfunction

    task body();
        spi_transaction tr = spi_transaction::type_id::create("tr_pre_reset");
        tr.data = 8'hAA;
        start_item(tr);
        finish_item(tr);


        #(200); //random time

        // Aqui a ideia é acionar reset externo na simulação
        // Como sequencia não controla reset, em testbench você deve disparar reset

        `uvm_info("RESET_SEQ", "Reset deve ser aplicado externamente aqui", UVM_MEDIUM)

        // Após reset, envia novo dado para validar retomada correta
        tr = spi_transaction::type_id::create("tr_post_reset");
        tr.data = 8'h55;
        start_item(tr);
        finish_item(tr);
    endtask
endclass
