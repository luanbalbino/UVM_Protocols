// -----------------------------------------------------------------------------
// Virtual Sequence - Executa todos os testes básicos SPI
// -----------------------------------------------------------------------------
class spi_virtual_sequence extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_virtual_sequence)

    function new(string name = "spi_virtual_sequence");
        super.new(name);
    endfunction

    task body();
        spi_simple_tx_sequence      simple_seq;
        spi_loopback_sequence       loopback_seq;
        spi_burst_sequence          burst_seq;
        spi_pattern_sequence        pattern_seq;

        `uvm_info(get_type_name(), "INIT SEQUENCES", UVM_LOW)
        

        `uvm_info(get_type_name(), "Starting spi_simple_tx_sequence", UVM_MEDIUM)
        simple_seq = spi_simple_tx_sequence::type_id::create("simple_seq");
        simple_seq.start(m_sequencer);

        //`uvm_info(get_type_name(), "Starting spi_loopback_sequence", UVM_MEDIUM)
        //loopback_seq = spi_loopback_sequence::type_id::create("loopback_seq");
        //loopback_seq.start(m_sequencer);

        `uvm_info(get_type_name(), "Starting spi_burst_sequence", UVM_MEDIUM)
        burst_seq = spi_burst_sequence::type_id::create("burst_seq");
        burst_seq.start(m_sequencer);

        `uvm_info(get_type_name(), "Starting spi_pattern_sequence", UVM_MEDIUM)
        pattern_seq = spi_pattern_sequence::type_id::create("pattern_seq");
        pattern_seq.start(m_sequencer);

        `uvm_info(get_type_name(), "FINISH ALL SEQUENCES", UVM_LOW)

    endtask
endclass
