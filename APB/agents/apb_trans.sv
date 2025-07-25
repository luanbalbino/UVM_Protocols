`include "uvm_macros.svh"
import uvm_pkg::*;
class apb_trans extends uvm_sequence_item;
	
	rand logic [31:0] PADDR;  //Address bus
	rand logic [31:0] PWDATA; //Write data bus
	
	// master
	logic PWRITE;        // Indicate transfer direction (Write=H, Read=L)
	logic PENABLE;       // Indicate the second and subsequents cycles
	logic PSEL;	         // Select slave
	logic PRESETn;       // Assynchronous rst
	logic [0:3] PSTRB;   // I'll not use this for now..
	
	// slave
	logic [31:0] PRDATA; // read bus data
	logic PSLVERR; 		 // This is optional, I won't use it for now... but indicates trasnfer error
	logic PREADY;  		 // extend a transfer..
 
	constraint c1{
		PADDR[31:0]>=32'd0; 
		PADDR[31:0] < 32'd32;
	}

	`uvm_object_utils_begin(apb_trans)
		`uvm_field_int(PADDR, UVM_ALL_ON)
		`uvm_field_int(PWDATA, UVM_ALL_ON)
		`uvm_field_int(PWRITE, UVM_ALL_ON)
		`uvm_field_int(PENABLE, UVM_ALL_ON)
		`uvm_field_int(PSEL, UVM_ALL_ON)
		`uvm_field_int(PRESETn, UVM_ALL_ON)
		`uvm_field_int(PSTRB, UVM_ALL_ON)
		`uvm_field_int(PRDATA, UVM_ALL_ON)  
		`uvm_field_int(PSLVERR, UVM_ALL_ON)
		`uvm_field_int(PREADY, UVM_ALL_ON)
	`uvm_object_utils_end

 
	function new(string name = "apb_trans");
		super.new(name);
	endfunction 

	function void print_info();
		`uvm_info("SEQ_ITEM",  $sformatf("Transaction: PRESETn = %0d, PSEL = %0d, PWRITE = %0d, PENABLE = %0d, ADDR = %0d, PWDATA = 0x%08x", PRESETn, PSEL, PWRITE, PENABLE, PADDR, PWDATA), UVM_LOW);
	endfunction
 
endclass
