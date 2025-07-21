class env extends uvm_env;
	`uvm_component_utils(env)
	 
	function new(input string inst = "env", uvm_component c);
	super.new(inst,c);
	endfunction
	 
	agent agt;
	sco scb;
	 
	virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		agt = agent::type_id::create("agt",this);
		scb = sco::type_id::create("scb", this);
	endfunction
	 
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	 	agt.m_mon.send.connect(scb.recv);
	endfunction
	 
endclass