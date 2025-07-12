class spi_monitor_in#(parameter int WORD_LEN = 12) extends uvm_monitor;
    `uvm_component_utils(spi_monitor_in)

    virtual spi_if #(WORD_LEN) vif;

    uvm_analysis_port #(spi_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual spi_if#(WORD_LEN))::get(this, "", "spi_vif", vif))
            `uvm_fatal("NOVIF", "Could not get virtual interface 'spi_vif'")
    endfunction

    task run_phase(uvm_phase phase);
        spi_seq_item tr;

        // I'm still not sure if I'll keep this..
        
    endtask
endclass
