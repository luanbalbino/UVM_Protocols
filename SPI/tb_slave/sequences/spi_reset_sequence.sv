class spi_reset_sequence#(parameter int WORD_LEN = 12) extends uvm_sequence #(spi_seq_item#(WORD_LEN));
    `uvm_object_param_utils(spi_reset_sequence#(WORD_LEN))
  
    function new(string name = "spi_reset_sequence");
      super.new(name);
    endfunction
  
    task body();
      spi_seq_item#(WORD_LEN) req = spi_seq_item#(WORD_LEN)::type_id::create("req");
      req.spi_mode      = 2'b00;
      req.mosi_data     = 8'h3C;
      req.slave_tx_data = 8'hF0;
      req.cs_toggle     = 0;
      req.miso_expected = 8'hF0;
      start_item(req);
      finish_item(req);
    endtask
endclass

  