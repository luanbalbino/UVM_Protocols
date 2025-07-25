class apb_simple_write_test extends apb_base_test;
	`uvm_component_utils(apb_simple_write_test)
	
	apb_write_sequence write_seq;

	function new(string name ="apb_simple_write_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		write_seq = apb_write_sequence::type_id::create("write_seq");
	endfunction
		
	task run_phase(uvm_phase phase);
		`uvm_info(get_name(), "RUN PHASE START", UVM_HIGH)
		phase.raise_objection(this);

		write_seq.start(env.agent.sqr);
		#40ns

		phase.drop_objection(this);
	endtask

endclass