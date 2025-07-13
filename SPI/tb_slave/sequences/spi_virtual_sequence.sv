// -----------------------------------------------------------------------------
// Virtual Sequence
// -----------------------------------------------------------------------------
class spi_virtual_sequence#(parameter int WORD_LEN = 12) extends uvm_sequence #(spi_seq_item#(WORD_LEN));
    `uvm_object_param_utils(spi_virtual_sequence#(WORD_LEN))

    `uvm_declare_p_sequencer(spi_virtual_sequencer#(WORD_LEN))
  
    function new(string name = "spi_virtual_sequence");
        super.new(name);
    endfunction

    spi_simple_rx_sequence#(WORD_LEN) simple_seq;
    spi_mode_test_sequence#(WORD_LEN) mode_seq;
    spi_cs_check_sequence#(WORD_LEN)  cs_seq;
    spi_miso_test_sequence#(WORD_LEN) miso_seq;

    task body();

        `uvm_info(get_type_name(), "INIT SEQUENCES", UVM_LOW)
        
        `uvm_info(get_type_name(), "Starting spi_simple_rx_sequence", UVM_LOW)
        simple_seq = spi_simple_rx_sequence#(.WORD_LEN(WORD_LEN))::type_id::create("simple_seq");
        simple_seq.start(p_sequencer.seqr);

        `uvm_info(get_type_name(), "Starting spi_mode_test_sequence", UVM_LOW)
        mode_seq = spi_mode_test_sequence#(.WORD_LEN(WORD_LEN))::type_id::create("mode_seq");
        mode_seq.start(p_sequencer.seqr);

        `uvm_info(get_type_name(), "Starting spi_cs_check_sequence", UVM_LOW)
        cs_seq = spi_cs_check_sequence#(.WORD_LEN(WORD_LEN))::type_id::create("cs_seq");
        cs_seq.start(p_sequencer.seqr);

        `uvm_info(get_type_name(), "Starting spi_miso_test_sequence", UVM_LOW)
        miso_seq = spi_miso_test_sequence#(.WORD_LEN(WORD_LEN))::type_id::create("miso_seq");
        miso_seq.start(p_sequencer.seqr);

        `uvm_info(get_type_name(), "FINISH ALL SEQUENCES", UVM_LOW)

    endtask
endclass
