class apb_write_sequence extends uvm_sequence#(apb_trans);
	`uvm_object_utils(apb_write_sequence)
	
	 int last_addr;
	
	function new(string name = "apb_write_sequence");
		super.new(name);
	endfunction 
	
	virtual task body();
        apb_trans write_trans;

        write_trans = apb_trans::type_id::create("write_trans");

		if (!write_trans.randomize()) begin
            `uvm_error(get_type_name(), "Failed during randomization");
        end

		write_trans.PSEL    = 'd1;
        write_trans.PWRITE  = 'd1;
        write_trans.PENABLE = 'd1;
        write_trans.PWDATA  = 'hBEBACAFE;

        start_item(write_trans);
        `uvm_info("SEQUENCE MESSAGE", $sformatf("ENVIANDO write_trans.PWRITE = %0d", write_trans.PWRITE), UVM_LOW) 
        finish_item(write_trans);
    endtask
endclass
