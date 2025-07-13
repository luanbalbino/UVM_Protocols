class spi_agent#(parameter int WORD_LEN = 12) extends uvm_agent;

	`uvm_component_param_utils(spi_agent#(WORD_LEN))
		
	virtual spi_if #(WORD_LEN) vif;
	spi_driver    #(WORD_LEN)drv;
	spi_monitor   #(WORD_LEN)mon;
	spi_sequencer #(WORD_LEN)sequencer;

	function new(string name = "spi_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(virtual spi_if#(WORD_LEN))::get(this, "", "spi_vif", vif)) begin
				`uvm_fatal("NOVIF", "Virtual interface not found")
		end

		drv       = spi_driver#(WORD_LEN)::type_id::create("drv", this);
		sequencer = spi_sequencer#(WORD_LEN)::type_id::create("sequencer", this);
		mon       = spi_monitor#(WORD_LEN)::type_id::create("mon", this);
		
		if(drv != null) drv.vif = vif;
		mon.vif    = vif;
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(sequencer.seq_item_export);
	endfunction
	
endclass : spi_agent
	