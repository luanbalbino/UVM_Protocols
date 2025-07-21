class seq1 extends uvm_sequence#(transaction);
	`uvm_object_utils(seq1)
	
	transaction tr;
   
	function new(string name = "seq1");
		super.new(name);
	endfunction
	
	virtual task body();
	  	repeat(1) begin
		  	tr = transaction::type_id::create("tr");
		  	start_item(tr);
		  	assert(tr.randomize);
		  	tr.length    = 'd8;
		  	tr.rst       = 1'b0;
		  	tr.tx_start  = 1'b1;
		  	tr.rx_start  = 1'b1;
		  	tr.parity_en = 1'b1;
		  	tr.stop2     = 1'b0;
		  	finish_item(tr);
		end
	endtask

endclass