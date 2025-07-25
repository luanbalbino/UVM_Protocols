class apb_driver extends uvm_driver#(apb_trans);
	`uvm_component_utils(apb_driver)
	
	virtual apb_if.MASTER vif; 

	function new(string name ="apb_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual apb_if.MASTER)::get(this,"","vif",vif)) begin
			`uvm_error("build_phase","driver virtual interface failed")
		end
	endfunction

	task run_phase(uvm_phase phase);
		apb_trans tr;

		forever begin
			seq_item_port.get_next_item(tr);
			`uvm_info(get_type_name(), $sformatf("DRIVER: Sending to DUT -> addr=0x%0h, write=%0b, data=0x%0h", tr.PADDR, tr.PWRITE, tr.PWDATA), UVM_LOW)

			drive_transfer(tr);
			seq_item_port.item_done();
		end
	endtask

	// I need to review this
	task drive_transfer(apb_trans tr);
		`uvm_info("WRITE DRIVER",$sformatf("Drive: PRESETn = %0d, PSEL = %0d, PWRITE = %0d, PENABLE = %0d, PSTRB = %0b, ADDR = %0d,PWDATA = %0d ", tr.PRESETn, tr.PSEL, tr.PWRITE, tr.PENABLE, tr.PSTRB, tr.PADDR, tr.PWDATA), UVM_HIGH)
		
		// Wait until reset is deasserted
		wait (vif.PRESETn == 1);
		@(posedge vif.PCLK); // T0
	
		// Ensure PSEL and PENABLE are low at the start
		vif.PSEL    <= 1'b0;
		vif.PENABLE <= 1'b0;
	
		@(posedge vif.PCLK); // T1
	
		`uvm_info("DRIVER MESSAGE", $sformatf("Received tr.PWRITE = %0d", tr.PWRITE), UVM_HIGH) 
	
		// Setup phase - PSEL, PWRITE, PADDR, PWDATA must be valid
		vif.PSEL    <= 1'b1; 
		vif.PWRITE  <= tr.PWRITE;
		vif.PADDR   <= tr.PADDR;
		`uvm_info("DRIVER_SCHEDULED_VALS", $sformatf("Driver scheduling for next PCLK: PSEL=%0d, PWRITE=%0d, PADDR=%0d, PWDATA=0x%0h", vif.PSEL, vif.PWRITE, vif.PADDR, vif.PWDATA), UVM_HIGH)
		if (tr.PWRITE) begin 
			vif.PWDATA  <= tr.PWDATA;
			vif.PSTRB   <= tr.PSTRB; 
		end else begin 
			vif.PWDATA  <= 'hx;
			vif.PSTRB   <= 'hF;
		end
	
		vif.PENABLE <= 1'b0; // PENABLE is low during setup phase
	
		@(posedge vif.PCLK); // T2
	
		`uvm_info("DRIVER_PROPAGATED_VALS", $sformatf("Driver @T2 (Propagated values): PSEL=%0d, PWRITE=%0d, PADDR=0x%0h, PWDATA=0x%0h, PENABLE=%0d",
		vif.PSEL, vif.PWRITE, vif.PADDR, vif.PWDATA, vif.PENABLE), UVM_HIGH);
	
		// Access phase - PSEL, PWRITE, PADDR, PWDATA must be stable
		vif.PENABLE <= 1'b1; // PENABLE goes high
	
		// Wait for PREADY to be asserted
		wait(vif.PREADY == 1'b1);
	
		// Sample PRDATA and PSLVERR
		if (!tr.PWRITE) begin 
			tr.PRDATA  = vif.PRDATA;
			tr.PSLVERR = vif.PSLVERR;
		end else begin 
			tr.PSLVERR = vif.PSLVERR;
		end
	
		@(posedge vif.PCLK); // T3
		
		vif.PSEL    <= 1'b0;
		vif.PENABLE <= 1'b0;
	
		//tr.print_info();
	endtask
	

endclass  
