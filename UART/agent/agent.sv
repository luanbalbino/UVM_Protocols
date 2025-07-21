class agent extends uvm_agent;
	`uvm_component_utils(agent)
	  
	uart_config cfg;
	driver drv;
	mon m_mon;
	uvm_sequencer#(transaction) seqr;
	 
	function new(input string inst = "agent", uvm_component parent = null);
		super.new(inst,parent);
	endfunction
	 
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cfg =  uart_config::type_id::create("cfg"); 
		m_mon = mon::type_id::create("m_mon",this);
	  
		if(cfg.is_active == UVM_ACTIVE) begin   
	   		drv    = driver::type_id::create("drv",this);
	   		seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
	   	end
	endfunction
	 
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	  	if(cfg.is_active == UVM_ACTIVE) begin  
			drv.seq_item_port.connect(seqr.seq_item_export);
	  	end
	endfunction
	 
endclass