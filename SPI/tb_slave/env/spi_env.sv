// -----------------------------------------------------------------------------
// UVM Environment
// -----------------------------------------------------------------------------
class spi_env#(parameter int WORD_LEN = 12) extends uvm_env;
   
    `uvm_component_utils(spi_env#(WORD_LEN))

    spi_virtual_sequencer#(.WORD_LEN(WORD_LEN)) spi_v_seq;
    spi_agent#(.WORD_LEN(WORD_LEN)) agt;
    spi_scb#(.WORD_LEN(WORD_LEN)) sb;
    spi_cov#(.WORD_LEN(WORD_LEN)) cov;
    spi_refmod#(.WORD_LEN(WORD_LEN)) refmod;

    virtual spi_if #(WORD_LEN) vif;

    function new(string name = "spi_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Get the virtual interface from the UVM configuration database
        if(!uvm_config_db#(virtual spi_if#(WORD_LEN))::get(this, "", "spi_vif", vif)) begin
            `uvm_fatal("NOVIF", "Could not get virtual interface 'spi_vif' from config_db.")
        end

        agt       = spi_agent#(.WORD_LEN(WORD_LEN))::type_id::create("agt", this);
        cov       = spi_cov#(.WORD_LEN(WORD_LEN))::type_id::create("cov", this);
        sb        = spi_scb#(.WORD_LEN(WORD_LEN))::type_id::create("sb", this);
        refmod    = spi_refmod#(.WORD_LEN(WORD_LEN))::type_id::create("refmod", this);
        spi_v_seq = spi_virtual_sequencer#(.WORD_LEN(WORD_LEN))::type_id::create("spi_v_seq",this);
        
        // Connect driver to sequencer
        uvm_config_db#(virtual spi_if#(WORD_LEN))::set(this, "agt", "vif", vif);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        sb.vif  = vif;

        // monitor -> coverage
        agt.mon.ap.connect(cov.analysis_export);

        spi_v_seq.seqr = agt.sequencer;
        
        // refmod -> scoreboard
        refmod.ap.connect(sb.refmod_ap);

        agt.mon.ap.connect(refmod.in);
        
        // output transaction -> scoreboard
        agt.mon.ap.connect(sb.mon_ap);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    
        $display("\n==================================================================");
        $display("                         UVM TEST REPORT                          ");
        $display("==================================================================");
        $display(">>> ENVIRONMENT: SLAVE ONLY");
        $display("==================================================================\n");
    endfunction

endclass
