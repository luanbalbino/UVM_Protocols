class apb_env extends uvm_env;
	`uvm_component_utils(apb_env)
	
	apb_agent agent;
	apb_scoreboard scb;
	apb_ref_model model;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = apb_agent::type_id::create ("agent", this);
		scb   = apb_scoreboard::type_id::create("scb",this);
		model = apb_ref_model::type_id::create("model",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		agent.mon.refmod_ap.connect(model.req_export);
		agent.mon.dut_read_ap.connect(scb.dut_read_imp);
		model.ap.connect(scb.ref_expected_imp);
		
	endfunction
endclass
