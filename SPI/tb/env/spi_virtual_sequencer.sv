// -----------------------------------------------------------------------------
// Sequencer UVM
// -----------------------------------------------------------------------------
class spi_virtual_sequencer extends uvm_sequencer #(spi_transaction);
    `uvm_component_utils(spi_virtual_sequencer)

    spi_sequencer seqr;

    function new(string name = "spi_virtual_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
