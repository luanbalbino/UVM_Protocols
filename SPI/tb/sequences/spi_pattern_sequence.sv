class spi_pattern_sequence extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_pattern_sequence)

    function new(string name = "spi_pattern_sequence");
        super.new(name);
    endfunction

    task body();
        bit [7:0] patterns[] = {8'hAA, 8'h55, 8'hFF, 8'h00};
        foreach (patterns[i]) begin
            spi_transaction tr = spi_transaction::type_id::create($sformatf("tr_pattern_%0d", i));
            tr.data = patterns[i];
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass
