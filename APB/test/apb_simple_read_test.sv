class apb_simple_read_test extends apb_base_test;
	`uvm_component_utils(apb_simple_read_test)
	
	apb_read_sequence read_seq;

	function new(string name ="apb_simple_read_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		read_seq = apb_read_sequence::type_id::create("read_seq");
	endfunction
		
	task run_phase(uvm_phase phase);
		`uvm_info(get_name(), "RUN PHASE START", UVM_HIGH)
		phase.raise_objection(this);

		read_seq.start(env.agent.sqr);
	  
		phase.drop_objection(this);
	endtask

endclass