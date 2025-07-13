`uvm_analysis_imp_decl(_mon)
`uvm_analysis_imp_decl(_refmod)

class spi_scb#(parameter int WORD_LEN = 12) extends uvm_scoreboard;

    `uvm_component_utils(spi_scb#(WORD_LEN))

    virtual spi_if #(WORD_LEN) vif;

    uvm_analysis_imp_mon #(spi_seq_item#(WORD_LEN), spi_scb#(WORD_LEN)) mon_ap;
    uvm_analysis_imp_refmod #(spi_seq_item#(WORD_LEN), spi_scb#(WORD_LEN)) refmod_ap;
    
    spi_seq_item#(WORD_LEN) mon_tr;
    spi_seq_item#(WORD_LEN) refmod_tr;

    bit mon_received, refmod_received;

    function new(string name = "spi_scb", uvm_component parent = null);
        super.new(name, parent);
        mon_received    = 0;
        refmod_received = 0;

        mon_ap    = new("mon_ap", this);
        refmod_ap = new("refmod_ap", this);
    endfunction

    virtual function void write_mon(spi_seq_item#(WORD_LEN) tr);
        `uvm_info(get_type_name(), $sformatf("RECEIVED FROM MONITOR -> MOSI: 0x%0h | MISO: 0x%0h | MODE: %0h", tr.mosi_data, tr.miso_expected, tr.spi_mode), UVM_MEDIUM);
        mon_tr = spi_seq_item#(WORD_LEN)::type_id::create("mon_tr", this);
        mon_tr.copy(tr);
        mon_received = 1;
    endfunction

    virtual function void write_refmod(spi_seq_item#(WORD_LEN) tr);
        `uvm_info(get_type_name(), $sformatf("RECEIVED FROM REFMOD  -> MOSI: 0x%0h | MISO: 0x%0h | MODE: %0h", tr.mosi_data, tr.miso_expected, tr.spi_mode), UVM_MEDIUM);
        refmod_tr = spi_seq_item#(WORD_LEN)::type_id::create("refmod_tr", this);
        refmod_tr.copy(tr);
        refmod_received = 1;
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual spi_if#(WORD_LEN))::get(this, "", "spi_vif", vif))
            `uvm_fatal("NOVIF", "Could not get virtual interface 'spi_vif' from config_db.")
    endfunction

    task run_phase(uvm_phase phase);

        forever begin 
            wait(mon_received && refmod_received);
            compare(refmod_tr, mon_tr);
        end

    endtask

    function void compare(spi_seq_item expected, spi_seq_item actual);
        `uvm_info(get_type_name(), "Comparing Expected vs Actual...", UVM_MEDIUM)
      
        
        if (expected.mosi_data !== actual.mosi_data)
            `uvm_error("SCOREBOARD", $sformatf("Mismatch! expected MOSI: 0x%0h, actual: 0x%0h", expected.mosi_data, actual.mosi_data))
        else
            `uvm_info("SCOREBOARD", "MOSI Match OK", UVM_MEDIUM)
        if (expected.miso_expected !== actual.miso_expected)
            `uvm_error("SCOREBOARD", $sformatf("Mismatch! expected MISO: 0x%0h, actual: 0x%0h", expected.miso_expected, actual.miso_expected))
        else
            `uvm_info("SCOREBOARD", "MISO Match OK", UVM_MEDIUM)

        mon_received    = 0;
        refmod_received = 0;

    endfunction

endclass
