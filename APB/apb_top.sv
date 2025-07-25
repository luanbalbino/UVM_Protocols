`include "uvm_macros.svh"
import uvm_pkg::*;

module apb_top(); 

	logic PCLK, PRESETn;
	parameter CLK_PERIOD = 10ns;

	apb_if vif(.PCLK(PCLK), .PRESETn(PRESETn));
	
	AMBA_APB dut(
		.PCLK(PCLK),
		.PRESETn(PRESETn), 
		.PADDR(vif.PADDR), 
		.PWRITE(vif.PWRITE), 
		.PSEL(vif.PSEL), 
		.PENABLE(vif.PENABLE), 
		.PWDATA(vif.PWDATA), 
		.PRDATA(vif.PRDATA), 
		.PREADY(vif.PREADY)
	); 
	
	initial begin
		PCLK = 1'b0; 
		forever #(CLK_PERIOD/2) PCLK = ~PCLK;
	end
		 
	initial begin
		PRESETn = 1'b1;
		#2;
		PRESETn = 1'b0;
		#7;
		PRESETn = 1'b1;
	end

	initial begin
		uvm_config_db#(virtual apb_if.MASTER) :: set(null,"uvm_test_top.env.*","vif", vif.MASTER);
		uvm_config_db#(virtual apb_if.MONITOR) :: set(null,"uvm_test_top.env.*","vif", vif.MONITOR);
		run_test();
	end
	
endmodule
