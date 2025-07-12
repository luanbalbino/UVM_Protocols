class spi_partial_transaction_sequence#(parameter int WORD_LEN = 12) extends uvm_sequence #(spi_seq_item#(WORD_LEN));
    `uvm_object_param_utils(spi_partial_transaction_sequence#(WORD_LEN))
  
    function new(string name = "spi_partial_transaction_sequence");
      super.new(name);
    endfunction
  
    task body();
      spi_seq_item#(WORD_LEN) req = spi_seq_item#(WORD_LEN)::type_id::create("req");
      req.spi_mode      = 2'b00;
      req.mosi_data     = 'h0F;  // parcial
      req.slave_tx_data = {WORD_LEN{1'b0}};
      req.cs_toggle     = 1;     // cs_n sobe antes de completar
      start_item(req);
      finish_item(req);
    endtask
  endclass