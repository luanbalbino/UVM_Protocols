`uvm_analysis_imp_decl(_DUT_READ) 
`uvm_analysis_imp_decl(_REF_EXPECTED) 


class apb_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(apb_scoreboard) 
	
    bit [31:0] dut_read_data_q[$];     
    bit [31:0] ref_expected_read_data_q[$]; 

    uvm_analysis_imp_DUT_READ #(apb_trans, apb_scoreboard) dut_read_imp;
    uvm_analysis_imp_REF_EXPECTED #(apb_trans, apb_scoreboard) ref_expected_imp;
    
    int match = 0;
    int mismatch = 0;
    
    function new (string name ="apb_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction
	
	function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        dut_read_imp     = new("dut_read_imp", this); 
        ref_expected_imp = new("ref_expected_imp", this); 

    endfunction
	
    virtual function void write_DUT_READ(input apb_trans trans);
        dut_read_data_q.push_back(trans.PRDATA);
        `uvm_info(get_type_name(), $sformatf("SCOREBOARD DUT READ Q: Q=%0d ADDR=0x%08x DATA=0x%08x", dut_read_data_q.size(), trans.PADDR, trans.PRDATA), UVM_LOW)
    endfunction
 
    virtual function void write_REF_EXPECTED(input apb_trans trans);
        if (!trans.PWRITE) begin 
            ref_expected_read_data_q.push_back(trans.PRDATA);
            `uvm_info(get_type_name(), $sformatf("SCOREBOARD REF EXPECTED READ Q: Q=%0d ADDR=0x%08x DATA=0x%08x", ref_expected_read_data_q.size(), trans.PADDR, trans.PRDATA), UVM_LOW)
        end 
    endfunction

	task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            if (dut_read_data_q.size() > 0 && ref_expected_read_data_q.size() > 0) begin
                bit [31:0] dut_data = dut_read_data_q.pop_front();
                bit [31:0] ref_data = ref_expected_read_data_q.pop_front();
          
                if (dut_data === ref_data) begin
                    match++;
                    `uvm_info(get_type_name(), $sformatf("MATCH: Expected 0x%08x, Got 0x%08x", ref_data, dut_data), UVM_LOW)
                end else begin
                    mismatch++;
                    `uvm_error(get_type_name(), $sformatf("MISMATCH: Expected 0x%08x, Got 0x%08x", ref_data, dut_data))
                end
            end else begin
                #(1); 
            end
        end
    endtask
	 
	virtual function void compare();
		// TBD
	endfunction: compare 
		
	function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    
        if (mismatch > 0) begin
            `uvm_info(get_type_name(), "\n********** TEST FAILED **********", UVM_NONE)
            `uvm_info(get_type_name(), $sformatf("* Mismatches          : %0d", mismatch), UVM_NONE)
            `uvm_info(get_type_name(), "*********************************", UVM_NONE)
        end else if (match > 0) begin 
            `uvm_info(get_type_name(), "\n********** TEST PASSED **********", UVM_NONE)
            `uvm_info(get_type_name(), $sformatf("* Matches             : %0d", match), UVM_NONE)
            `uvm_info(get_type_name(), "*********************************", UVM_NONE)
        end else begin
            `uvm_warning(get_type_name(), "No read comparisons performed (0 matches, 0 mismatches). Test might not be fully exercising the read path.")
        end
    endfunction : report_phase
endclass
