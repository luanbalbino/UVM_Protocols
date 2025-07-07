class spi_scb extends uvm_scoreboard;

    `uvm_component_utils(spi_scb)

    virtual spi_if vif;

    uvm_tlm_analysis_fifo #(spi_transaction) rtl_out;
    uvm_tlm_analysis_fifo #(spi_transaction) tr_in;

    spi_transaction spi_seq_out;
    spi_transaction spi_seq_in;

    function new(string name = "spi_scb", uvm_component parent = null);
        super.new(name, parent);

        rtl_out = new(.name("rtl_out"),.parent(this));
        tr_in = new(.name("tr_in"),.parent(this));
    endfunction

    // Reset Phase
    task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        `uvm_info(get_name(), $sformatf("RESET PHASE"), UVM_HIGH)
        phase.raise_objection(this);
        rtl_out.flush();
        phase.drop_objection(this);
    endtask: reset_phase


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", vif))
            `uvm_fatal("NOVIF", "Could not get virtual interface 'spi_vif' from config_db.")
    endfunction


    task run_phase(uvm_phase phase);
        `uvm_info(get_name(), $sformatf("MAIN PHASE"), UVM_HIGH)

        // Functional
        forever begin
            tr_in.get(spi_seq_in);
            rtl_out.get(spi_seq_out);
            compare(spi_seq_in, spi_seq_out);
        end

    endtask: run_phase

    function void compare(spi_transaction expected, spi_transaction actual);
        `uvm_info(get_type_name(), $sformatf("Comparing Expected vs Actual..."), UVM_MEDIUM)
    
        if (expected.data !== actual.data)
            `uvm_error("SCOREBOARD", $sformatf("Mismatch! expected: %h, actual: %h", expected.data, actual.data))
        else
            `uvm_info("SCOREBOARD", "Match OK", UVM_MEDIUM)
    endfunction: compare

endclass
