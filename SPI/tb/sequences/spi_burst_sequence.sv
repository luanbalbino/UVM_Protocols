class spi_burst_sequence extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_burst_sequence)

    function new(string name = "spi_burst_sequence");
        super.new(name);
    endfunction

    task body();
        bit [7:0] burst_data[] = {8'h11, 8'h22, 8'h33, 8'h44, 8'h55};
        foreach (burst_data[i]) begin
            spi_transaction tr = spi_transaction::type_id::create($sformatf("tr_%0d", i));
            tr.data = burst_data[i];
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass
