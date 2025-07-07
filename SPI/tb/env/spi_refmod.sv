// -----------------------------------------------------------------------------
// SPI Dummy refmod (need to be improved)
// -----------------------------------------------------------------------------
class spi_refmod extends uvm_component;
    `uvm_component_utils(spi_refmod)

    uvm_analysis_imp#(spi_transaction, spi_refmod) in;

    uvm_analysis_port#(spi_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        ap = new("ap", this);
    endfunction

    function void write(spi_transaction tr_in);
        spi_transaction tr_expected;
        tr_expected = spi_transaction::type_id::create("tr_expected");  
        tr_expected.data = tr_in.data;  
        `uvm_info("PREDICTOR", $sformatf("Predicted: %h", tr_expected.data ), UVM_MEDIUM)   
        ap.write(tr_expected);
    endfunction
endclass
