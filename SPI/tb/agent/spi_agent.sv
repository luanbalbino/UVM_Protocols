class spi_agent extends uvm_agent;

    `uvm_component_utils(spi_agent)
    
    virtual spi_if vif;

    spi_driver drv;
    spi_monitor mon;
    spi_monitor_in mon_in;

    function new(string name = "spi_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
  
    // Build phase
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
  
        if(!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif)) begin
          `uvm_fatal("NOVIF", "Virtual interface not found")
        end
  
        drv = spi_driver::type_id::create("drv", this);
        mon = spi_monitor::type_id::create("mon", this);
        mon_in = spi_monitor_in::type_id::create("mon_in", this);

        if(drv != null) drv.vif = vif;
        mon.vif   = vif;
        mon_in.vif = vif;
    endfunction
  
    // Connect phase
    //function void connect_phase(uvm_phase phase);
    //    super.connect_phase(phase);
    //    drv.vif    = vif;
    //    mon.vif    = vif; 
    //    mon_in.vif = vif; 
    //endfunction
  
  endclass : spi_agent
  