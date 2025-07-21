class test extends uvm_test;
	`uvm_component_utils(test)
	 
	function new(input string inst = "test", uvm_component c);
		super.new(inst,c);
	endfunction

	env m_env;
	seq1 my_seq;
	  
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_env  = env::type_id::create("m_env",this);
		my_seq = seq1::type_id::create("my_seq");
	endfunction
	 
	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			my_seq.start(m_env.agt.seqr);
			#5;
		phase.drop_objection(this);
	endtask
endclass