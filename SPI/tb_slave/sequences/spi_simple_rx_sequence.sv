// -----------------------------------------------------------------------------
// Simple Sequence (TBD)
// -----------------------------------------------------------------------------
class spi_simple_rx_sequence#(parameter int WORD_LEN = 12) extends uvm_sequence #(spi_seq_item#(WORD_LEN));

    `uvm_object_param_utils(spi_simple_rx_sequence#(WORD_LEN))

    function new(string name = "spi_simple_rx_sequence");
        super.new(name);
    endfunction

    task body();
        spi_seq_item tr = spi_seq_item#(.WORD_LEN(WORD_LEN))::type_id::create("tr");
        
        tr.mosi_data = WORD_LEN'(8'hA5);
        
        start_item(tr);
        finish_item(tr);
    endtask
endclass