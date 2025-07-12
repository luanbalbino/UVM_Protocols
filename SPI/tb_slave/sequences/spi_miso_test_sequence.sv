class spi_miso_test_sequence#(parameter int WORD_LEN = 12) extends uvm_sequence #(spi_seq_item#(WORD_LEN));
  `uvm_object_param_utils(spi_miso_test_sequence#(WORD_LEN))

  function new(string name = "spi_miso_test_sequence");
    super.new(name);
  endfunction

  task body();
    spi_seq_item#(WORD_LEN) req;
    
    // --- First Transaction: Send non-zero data for the slave to receive ---
    req = spi_seq_item#(WORD_LEN)::type_id::create("req");
    req.spi_mode      = 2'b00;         // CPOL=0, CPHA=0 (Mode 0)
    req.mosi_data     = {{(WORD_LEN-8){1'b0}}, 8'hA5}; 
    
    // Note: req.slave_tx_data and req.miso_expected are not used by the slave
    // to *generate* MISO in this design. They are for verification in the monitor/scoreboard.
    // In this first transaction, the slave's MISO will still be 0, as received_reg is initially 0.
    req.cs_toggle     = 0;
    start_item(req);
    finish_item(req);

    // --- Second Transaction: (Optionally) Send new data and verify MISO echo ---
    // At this point, the slave should have 0xA5 in its received_reg (from the previous transaction).
    // It will echo 0xA5 in this transaction.
    req = spi_seq_item#(WORD_LEN)::type_id::create("req");
    req.spi_mode      = 2'b00;         // CPOL=0, CPHA=0 (Mode 0)
    req.mosi_data     = {{(WORD_LEN-8){1'b0}}, 8'h5A}; // Send new data (e.g., 0x5A)
    req.miso_expected = {{(WORD_LEN-8){1'b0}}, 8'hA5}; // SPECIFY what is expected on MISO: the 0xA5 from the previous transaction
    req.cs_toggle     = 0;
    start_item(req);
    finish_item(req);

    // --- Third Transaction (Example for other modes): Test Mode 1 (CPOL=0, CPHA=1) ---
    req = spi_seq_item#(WORD_LEN)::type_id::create("req");
    req.spi_mode      = 2'b01;         // CPOL=0, CPHA=1 (Mode 1)
    req.mosi_data     = {{(WORD_LEN-8){1'b0}}, 8'hC3}; // New data
    req.miso_expected = {{(WORD_LEN-8){1'b0}}, 8'h5A}; // Expect 0x5A echo from the previous transaction
    req.cs_toggle     = 0;
    start_item(req);
    finish_item(req);

  endtask
endclass