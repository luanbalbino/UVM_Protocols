class apb_read_sequence extends uvm_sequence#(apb_trans);
	`uvm_object_utils(apb_read_sequence)
	
	 int last_addr;

	function new(string name = "apb_read_sequence");
		super.new(name);
	endfunction 
	
	virtual task body();
		apb_trans read_trans;

		//generate read transaction 
		read_trans = apb_trans::type_id::create("read_trans");
		read_trans.PSEL    = 'd1;
		read_trans.PWRITE  = 'd0;
		read_trans.PENABLE = 'd1;
		read_trans.PADDR   = last_addr;
		
		start_item(read_trans);
		`uvm_info("READ SEQUENCE",$sformatf("Read Transaction Generated: PRESETn =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d ", read_trans.PRESETn,read_trans.PSEL,read_trans.PWRITE,read_trans.PENABLE,read_trans.PADDR),UVM_LOW)
		finish_item(read_trans);

	endtask
endclass
