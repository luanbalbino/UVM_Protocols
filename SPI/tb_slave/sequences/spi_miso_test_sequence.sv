class spi_miso_test_sequence#(parameter int WORD_LEN = 12) extends uvm_sequence #(spi_seq_item#(WORD_LEN));
  `uvm_object_param_utils(spi_miso_test_sequence#(WORD_LEN))

  function new(string name = "spi_miso_test_sequence");
    super.new(name);
  endfunction

  task body();
    spi_seq_item#(WORD_LEN) req;

    // SEQ 1: send 0xA5
    req = spi_seq_item#(WORD_LEN)::type_id::create("req1");
    req.spi_mode      = 2'b00;
    req.mosi_data     = {{(WORD_LEN-8){1'b0}}, 8'hA5};
    req.cs_toggle     = 0;
    start_item(req);
    finish_item(req);

    // SEQ 2: send 0x5A, wait for 0xA5 on MISO signal
    req = spi_seq_item#(WORD_LEN)::type_id::create("req2");
    req.spi_mode      = 2'b00;
    req.mosi_data     = {{(WORD_LEN-8){1'b0}}, 8'h5A};
    req.miso_expected = {{(WORD_LEN-8){1'b0}}, 8'hA5};
    req.cs_toggle     = 0;
    start_item(req);
    finish_item(req);

    // SEQ 3: send 0xC3, wait for 0x5A on MISO signal
    req = spi_seq_item#(WORD_LEN)::type_id::create("req3");
    req.spi_mode      = 2'b01;
    req.mosi_data     = {{(WORD_LEN-8){1'b0}}, 8'hC3};
    req.miso_expected = {{(WORD_LEN-8){1'b0}}, 8'h5A};
    req.cs_toggle     = 0;
    start_item(req);
    finish_item(req);
  endtask
endclass
