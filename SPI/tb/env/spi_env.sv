// -----------------------------------------------------------------------------
// UVM Environment
// -----------------------------------------------------------------------------
class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    spi_agent agt;
    spi_cov cov;
    spi_scb sb;
    spi_refmod refmod;
    spi_virtual_sequencer spi_v_seq;

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
        cov     = spi_cov::type_id::create("cov", this);
        sb      = spi_scb::type_id::create("sb", this);
        refmod  = spi_refmod::type_id::create("refmod", this);
        spi_v_seq = spi_virtual_sequencer::type_id::create("spi_v_seq",this);
        
        // Connect driver to sequencer
        uvm_config_db#(virtual spi_if)::set(this, "agt", "vif", vif);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        cov.vif = vif;
        sb.vif  = vif;

        // monitor -> coverage
        agt.mon.ap.connect(cov.analysis_export);

        spi_v_seq.seqr = agt.sequencer;

        // input transaction -> refmod
        agt.mon_in.ap.connect(refmod.in);
        
        // refmod -> scoreboard
        refmod.ap.connect(sb.tr_in.analysis_export);
        
        // output transaction -> scoreboard
        agt.mon.ap.connect(sb.rtl_out.analysis_export);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    
        $display("\n==================================================================");
        $display("                         UVM TEST REPORT                          ");
        $display("==================================================================");
        $display(">>> ENVIRONMENT: MASTER + SLAVE");
        $display("==================================================================\n");
    endfunction

endclass
