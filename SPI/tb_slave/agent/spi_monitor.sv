// -----------------------------------------------------------------------------
// UVM Monitor - Observes SPI signals and generates transactions
// -----------------------------------------------------------------------------
class spi_monitor#(parameter int WORD_LEN = 12) extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    virtual spi_if #(WORD_LEN) vif;
    uvm_analysis_port #(spi_seq_item) ap;

    function new(string name = "spi_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        spi_seq_item tr;
        `uvm_info(get_type_name(), $sformatf("@%0t: Monitor starting run_phase.", $time), UVM_MEDIUM)
        
        // I'll include here the logic
        // forever begin
    
        // end
    endtask
endclass