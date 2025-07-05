// -----------------------------------------------------------------------------
// UVM Environment
// -----------------------------------------------------------------------------
class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    spi_driver drv;
    spi_monitor mon;
    spi_sequencer seq;

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

        seq = spi_sequencer::type_id::create("seq", this);
        drv = spi_driver::type_id::create("drv", this);
        mon = spi_monitor::type_id::create("mon", this);
        
        // Connect driver to sequencer
        drv.seq_item_port.connect(seq.seq_item_export);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect the virtual interface to the components
        drv.vif = vif;
        mon.vif = vif; 
    
        drv.seq_item_port.connect(seq.seq_item_export);
    endfunction

endclass
