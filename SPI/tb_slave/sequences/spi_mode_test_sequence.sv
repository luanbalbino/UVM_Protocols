class spi_mode_test_sequence#(parameter int WORD_LEN = 12) extends uvm_sequence #(spi_seq_item#(WORD_LEN));

  `uvm_object_param_utils(spi_mode_test_sequence#(WORD_LEN))

  function new(string name = "spi_mode_test_sequence");
      super.new(name);
  endfunction

  task body();
      spi_seq_item#(WORD_LEN) req;

      for (int mode = 0; mode < 4; mode++) begin
          req = spi_seq_item#(WORD_LEN)::type_id::create("req");
          void'(req.randomize());

          req.spi_mode = mode;
          req.cs_toggle = 0;

          start_item(req);
          finish_item(req);
      end
  endtask

endclass
