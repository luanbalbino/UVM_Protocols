// -----------------------------------------------------------------------------
// Sequencer UVM
// -----------------------------------------------------------------------------
class spi_virtual_sequencer#(parameter int WORD_LEN = 12) extends uvm_sequencer #(spi_seq_item#(WORD_LEN));
    `uvm_component_utils(spi_virtual_sequencer#(WORD_LEN))

    spi_sequencer#(WORD_LEN) seqr;

    function new(string name = "spi_virtual_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = spi_sequencer#(WORD_LEN)::type_id::create("seqr", this);
    endfunction
endclass
