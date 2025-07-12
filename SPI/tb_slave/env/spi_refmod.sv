// -----------------------------------------------------------------------------
// SPI Dummy refmod (need to be improved)
// -----------------------------------------------------------------------------
class spi_refmod#(parameter int WORD_LEN = 12) extends uvm_component;
    
    `uvm_component_utils(spi_refmod)

    uvm_analysis_imp#(spi_seq_item#(WORD_LEN), spi_refmod) in;

    uvm_analysis_port#(spi_seq_item#(WORD_LEN)) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        ap = new("ap", this);
    endfunction

    function void write(spi_seq_item tr_in);
        spi_seq_item tr_expected;
        
        tr_expected = spi_seq_item#(.WORD_LEN(WORD_LEN))::type_id::create("tr_expected");  
        tr_expected.mosi_data = tr_in.mosi_data;  
        
        `uvm_info("PREDICTOR", $sformatf("Predicted: %h", tr_expected.mosi_data ), UVM_MEDIUM)   
        ap.write(tr_expected);
    endfunction
endclass
