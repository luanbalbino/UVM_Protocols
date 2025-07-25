class apb_base_test extends uvm_test;
	`uvm_component_utils(apb_base_test)
	
	apb_env env;

	function new(string name ="apb_base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		env = apb_env::type_id::create("env",this);
	endfunction
		
	task run_phase(uvm_phase phase);
		`uvm_info(get_name(), "RUN PHASE START", UVM_HIGH)
		phase.raise_objection(this);

		`uvm_info(get_name(), "TEST BASE CLASS", UVM_LOW)
	  
		phase.drop_objection(this);
	endtask

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction:end_of_elaboration_phase

endclass