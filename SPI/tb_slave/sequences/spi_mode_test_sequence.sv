class spi_mode_test_sequence#(parameter int WORD_LEN = 12) extends uvm_sequence #(spi_seq_item#(WORD_LEN));
    
    `uvm_object_param_utils(spi_mode_test_sequence#(WORD_LEN))
  
    function new(string name = "spi_mode_test_sequence");
      super.new(name);
    endfunction
  
    task body();
        spi_seq_item req;
        for(int mode = 0; mode < 4; mode++) begin
            req = spi_seq_item#(.WORD_LEN(WORD_LEN))::type_id::create("tr");
            req.randomize();

            req.spi_mode      = mode;
            req.slave_tx_data = 8'h5A;
            req.cs_toggle     = 0;
            req.miso_expected = 8'h5A;
            start_item(req);
            finish_item(req);
      end
    endtask
endclass
  