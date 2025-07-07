// -----------------------------------------------------------------------------
// UVM Environment
// -----------------------------------------------------------------------------
class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    spi_agent agt;
    spi_sequencer seq;
    spi_cov cov;
    spi_scb sb;
    spi_refmod refmod;

    // Variable for the virtual interface
    virtual spi_if vif;

    function new(string name = "spi_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Get the virtual interface from the UVM configuration database
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", vif)) begin
            `uvm_fatal("NOVIF", "Could not get virtual interface 'spi_vif' from config_db.")
        end

        agt     = spi_agent::type_id::create("agt", this);
        seq     = spi_sequencer::type_id::create("seq", this);
        cov     = spi_cov::type_id::create("cov", this);
        sb      = spi_scb::type_id::create("sb", this);
        refmod  = spi_refmod::type_id::create("refmod", this);
        
        // Connect driver to sequencer
        uvm_config_db#(virtual spi_if)::set(this, "agt", "vif", vif);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        cov.vif = vif;
        sb.vif  = vif;

        // driver to sequencer
        agt.drv.seq_item_port.connect(seq.seq_item_export);

        // monitor -> coverage
        agt.mon.ap.connect(cov.analysis_export);

        // input transaction -> refmod
        agt.mon_in.ap.connect(refmod.in);
        
        // refmod -> scoreboard
        refmod.ap.connect(sb.tr_in.analysis_export);
        
        // output transaction -> scoreboard
        agt.mon.ap.connect(sb.rtl_out.analysis_export);
    endfunction

endclass
