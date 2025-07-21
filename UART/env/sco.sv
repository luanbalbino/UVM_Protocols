class sco extends uvm_scoreboard;
	`uvm_component_utils(sco)
	 
	uvm_analysis_imp#(transaction,sco) recv;
	bit [31:0] arr[32] = '{default:0};
	bit [31:0] addr    = 0;
	bit [31:0] data_rd = 0;

	function new(input string inst = "sco", uvm_component parent = null);
		super.new(inst,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		recv = new("recv", this);
	endfunction
			
	virtual function void write(transaction tr);
		`uvm_info("SCO", $sformatf("\n[WRITE] BAUD=%0d LEN=%0d PAR_T=%0d PAR_EN=%0d STOP=%0d TX=0x%0h RX=0x%0h",
									tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data, tr.rx_out), UVM_LOW);
	
		if (tr.rst)
			`uvm_info("SCO", "[RESET] System Reset Asserted", UVM_MEDIUM)
		else if (tr.tx_data === tr.rx_out)
			`uvm_info("SCO", "[PASS] TX matches RX", UVM_LOW)
		else
			`uvm_error("SCO", $sformatf("[FAIL] TX=0x%0h != RX=0x%0h", tr.tx_data, tr.rx_out))
	
		$display("----------------------------------------------------------------");
	endfunction
	 
endclass